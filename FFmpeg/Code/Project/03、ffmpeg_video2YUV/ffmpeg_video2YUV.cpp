#include <stdio.h>

#ifdef __cplusplus
extern "C" {
    #include <libavformat/avformat.h>
    #include <libavcodec/avcodec.h>
    #include <libswscale/swscale.h>
    #include <libavutil/imgutils.h>
};
#endif

int main(int argc,char *argv[]) {
    char *fileName = argv[1];
    if (!fileName) {
        av_log(NULL,AV_LOG_ERROR,"input file is null");
        return -1;
    }
    av_register_all();

    AVFormatContext *formatContext = avformat_alloc_context();
    if (avformat_open_input(&formatContext,fileName,NULL,NULL) < 0){
        av_log(NULL,AV_LOG_ERROR,"cannot open input file");
        return -1;
    }
    if (avformat_find_stream_info(formatContext,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot find stream info");
        return -1;
    }
    av_dump_format(formatContext,0,fileName,0);

    int result = 0;
    int videoIndex = -1;
    for (int i = 0; i < formatContext->nb_streams; i++){
        AVStream *stream = formatContext->streams[i];
        if (stream->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
            videoIndex = i;
            break;
        }
    }
    if (videoIndex == -1) {
        av_log(NULL,AV_LOG_ERROR,"cannot find video stream");
        return -1;
    }

    AVCodecContext *codecContext = formatContext->streams[videoIndex]->codec;
    AVCodec *codec = avcodec_find_decoder(codecContext->codec_id);
    if (!codec) {
        av_log(NULL,AV_LOG_ERROR,"cannot find video decoder");
        return -1;
    }
    if (avcodec_open2(codecContext,codec,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot open video decoder");
        return -1;
    }

    int width = codecContext->width;
    int height = codecContext->height;
    int gotPicture;
    FILE *outputFile = fopen("output.yuv","wb+");

    AVFrame *frame = av_frame_alloc();
    AVFrame *frameYUV = av_frame_alloc();
    AVPacket *packet = (AVPacket *)av_malloc(sizeof(AVPacket));

    unsigned char *outBuffer = (unsigned char *)av_malloc(av_image_get_buffer_size(AV_PIX_FMT_YUV420P,width,height,1));
    av_image_fill_arrays(
        frameYUV->data,
        frameYUV->linesize,
        outBuffer,
        AV_PIX_FMT_YUV420P,
        width,
        height,
        1
    );

    struct SwsContext *imageConvertContext = sws_getContext(
        width,
        height,
        codecContext->pix_fmt,
        width,
        height,
        AV_PIX_FMT_YUV420P,
        SWS_BICUBIC,
        NULL,
        NULL,
        NULL
    );

    while (av_read_frame(formatContext,packet) >= 0){
        if (packet->stream_index == videoIndex) {
            result = avcodec_decode_video2(codecContext,frame,&gotPicture,packet);
            if (result < 0) {
                av_log(NULL,AV_LOG_ERROR,"fail to decode video");
                return -1;
            }
            if (gotPicture) {
                sws_scale(
                    imageConvertContext,
                    frame->data,
                    frame->linesize,
                    0,
                    height,
                    frameYUV->data,
                    frameYUV->linesize
                );
                int size = width * height;
                fwrite(frameYUV->data[0],1,size,outputFile);
                fwrite(frameYUV->data[1],1,size / 4,outputFile);
                fwrite(frameYUV->data[2],1,size / 4,outputFile);
            }
        }
        av_free_packet(packet);
    }
    while (1){
        result = avcodec_decode_video2(codecContext,frame,&gotPicture,packet);
        if (result < 0 || !gotPicture) {
            break;
        }
        sws_scale(
            imageConvertContext,
            frame->data,
            frame->linesize,
            0,
            height,
            frameYUV->data,
            frameYUV->linesize
        );
        int size = width * height;
            fwrite(frameYUV->data[0],1,size,outputFile);
            fwrite(frameYUV->data[1],1,size / 4,outputFile);
            fwrite(frameYUV->data[2],1,size / 4,outputFile);
    }
    sws_freeContext(imageConvertContext);
    
    fclose(outputFile);
    av_free_packet(packet);
    av_frame_free(&frame);
    av_frame_free(&frameYUV);
    avcodec_close(codecContext);
    avformat_close_input(&formatContext);
    avformat_free_context(formatContext);

    return 0;
}