#include <stdio.h>

#ifdef __cplusplus
extern "C" {
    #include <libavformat/avformat.h>
    #include <libavcodec/avcodec.h>
    #include <libavutil/imgutils.h>
};
#endif

int main (int argc,char *argv[]){
    
    FILE *inputFile = fopen("bigbuckbunny_480x272.yuv","rb");
    int inputWidth = 480;
    int inputHeight = 272;
    const char *output_file = "bigbuckbunny_480x272.jpg";
    av_register_all();

    AVFormatContext *formatContext;
    AVOutputFormat *outputFormat;

    /**方法一
    formatContext = avformat_alloc_context();
    outputFormat = av_guess_format("mjpeg",NULL,NULL);
    formatContext->oformat = outputFormat;
    */

    ///**方法二
    if (avformat_alloc_output_context2(&formatContext,NULL,NULL,output_file) < 0) {
        return -1;
    }
    outputFormat = formatContext->oformat;
    //*/

    if (avio_open(&formatContext->pb,output_file,AVIO_FLAG_READ_WRITE) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot open output file!");
        return -1;
    }

    AVStream *videoStream = avformat_new_stream(formatContext,0);
    if (!videoStream) {
        return -1;
    }

    AVCodecContext *codecContext = videoStream->codec;
    codecContext->codec_id = outputFormat->video_codec;
    codecContext->codec_type = AVMEDIA_TYPE_VIDEO;
    codecContext->pix_fmt = AV_PIX_FMT_YUVJ420P;
    codecContext->width = inputWidth;
    codecContext->height = inputHeight;
    codecContext->time_base.num = 1;
    codecContext->time_base.den = 25;

    av_dump_format(formatContext,0,output_file,1);

    AVCodec *codec = avcodec_find_encoder(codecContext->codec_id);
    if (!codec) {
        av_log(NULL,AV_LOG_ERROR,"cannot find encoder!");
        return -1;
    }
    if (avcodec_open2(codecContext,codec,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot open encoder!");
        return -1;
    }
    AVFrame *frame = av_frame_alloc();
    // int size = avpicture_get_size(codecContext->pix_fmt,codecContext->width,codecContext->height);
    int size = av_image_get_buffer_size(codecContext->pix_fmt,codecContext->width,codecContext->height,1);
    uint8_t *frameBuffer = (uint8_t *)av_malloc(size);
    if (!frameBuffer) {
        return -1;
    }
    // avpicture_fill((AVPicture *)frame,frameBuffer,codecContext->pix_fmt,codecContext->width,codecContext->height);
    av_image_fill_arrays(
        frame->data,
        frame->linesize,
        frameBuffer,
        codecContext->pix_fmt,
        codecContext->width,
        codecContext->height,
    1);
    avformat_write_header(formatContext,NULL);
    int ySize = codecContext->width * codecContext->height;
    AVPacket packet;
    av_new_packet(&packet,ySize * 3);
    if (fread(frameBuffer,1,ySize * 3 / 2,inputFile) <= 0){
        printf("cannot read input file!\n");
        return -1;
    }
    frame->data[0] = frameBuffer;
    frame->data[1] = frameBuffer + ySize;
    frame->data[2] = frameBuffer + ySize * 5 / 4;
    int gotPicture = 0;
    int result = avcodec_encode_video2(codecContext,&packet,frame,&gotPicture);
    if (result < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot encode video!");
        return -1;
    }
    if (gotPicture) {
        packet.stream_index = videoStream->index;
        result = av_write_frame(formatContext,&packet);
    }
    av_free_packet(&packet);
    av_write_trailer(formatContext);
    if (videoStream) {
        avcodec_close(codecContext);
        av_frame_free(&frame);
        av_free(frameBuffer);
    }
    avio_close(formatContext->pb);
    avformat_free_context(formatContext);
    fclose(inputFile);
    return 0;
}