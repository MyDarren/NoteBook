#include <stdio.h>

#ifdef __cplusplus
extern "C" {
    #include <libavformat/avformat.h>
    #include <libavcodec/avcodec.h>
    #include <libavutil/imgutils.h>
};
#endif

int flushEncoder(AVFormatContext *formatContext,unsigned int streamIndex) {
    int result;
    int gotPicture;
    AVPacket packet;
    AVCodecContext *codecContext = formatContext->streams[streamIndex]->codec;
    if (!(codecContext->codec->capabilities & AV_CODEC_CAP_DELAY)) {
        return 0;
    }
    while (1){
        packet.data = NULL;
        packet.size = 0;
        av_init_packet(&packet);
        result = avcodec_encode_video2(codecContext,&packet,NULL,&gotPicture);
        av_frame_free(NULL);
        if (result < 0) {
            break;
        }
        if (!gotPicture) {
            result = 0;
            break;
        }
        printf("Flush Encoder:Succeed to encode 1 frame!\tsize:%5d\n",packet.size);
        result = av_write_frame(formatContext,&packet);
        if (result < 0) {
            break;
        }
    }
    return result;
}

int main(int argc,char *argv[]){
    FILE *inputFile = fopen("bigbuckbunny_480x272.yuv","rb");
    int inputWidth = 480;
    int inputHeight = 272;
    const char *outputFile = "bigbuckbunny_480x272.hevc";

    av_register_all();
    AVFormatContext *formatContext;
    AVOutputFormat *outputFormat;
    if (avformat_alloc_output_context2(&formatContext,NULL,NULL,outputFile) < 0) {
        return -1;
    }
    outputFormat = formatContext->oformat;

    if (avio_open(&formatContext->pb,outputFile,AVIO_FLAG_READ_WRITE) < 0) {
        return -1;
    }

    AVStream *videoStream = avformat_new_stream(formatContext,NULL);
    videoStream->time_base.num = 1;
    videoStream->time_base.den = 25;
    if (!videoStream) {
        return -1;
    }

    //Param that must set
    AVCodecContext *codecContext = videoStream->codec;
    codecContext->codec_id = outputFormat->video_codec;
    codecContext->codec_type = AVMEDIA_TYPE_VIDEO;
    codecContext->pix_fmt = AV_PIX_FMT_YUV420P;
    codecContext->width = inputWidth;
    codecContext->height = inputHeight;
    codecContext->bit_rate = 400000;
    codecContext->gop_size = 250;
    codecContext->time_base.num = 1;
    codecContext->time_base.den = 25;

    //H264
    // codecContext->me_range = 16;
    // codecContext->max_qdiff = 4;
    // codecContext->qcompress = 0.6;
    codecContext->qmin = 10;
    codecContext->qmax = 51;

    //Optional Param
    codecContext->max_b_frames = 3;

    //Set Option
    AVDictionary *param = NULL;
    if (codecContext->codec_id == AV_CODEC_ID_H264) {
        av_dict_set(&param,"preset","slow",0);
        av_dict_set(&param,"tune","zerolatency",0);
        //av_dict_set(&param,"profile","main",0);
    }
    if (codecContext->codec_id == AV_CODEC_ID_H265) {
        av_dict_set(&param,"x265-params","qp=20",0);
        av_dict_set(&param,"preset","ultrafast",0);
        av_dict_set(&param,"tune","zero-latency",0);
    }
    //Show some information
    av_dump_format(formatContext,0,outputFile,true);

    AVCodec *codec = avcodec_find_encoder(codecContext->codec_id);
    if (!codec) {
        av_log(NULL,AV_LOG_ERROR,"cannot find output encoder!");
        return -1;
    }
    if (avcodec_open2(codecContext,codec,&param) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot open output encoder!");
        return -1;
    }

    AVFrame *frame = av_frame_alloc();
    int size = av_image_get_buffer_size(codecContext->pix_fmt,codecContext->width,codecContext->height,1);
    uint8_t *frameBuffer = (uint8_t *)av_malloc(size);
    av_image_fill_arrays(
        frame->data,
        frame->linesize,
        frameBuffer,
        codecContext->pix_fmt,
        codecContext->width,
        codecContext->height,
        1
    );

    avformat_write_header(formatContext,NULL);
    int ySize = codecContext->width * codecContext->height;
    AVPacket packet;
    av_new_packet(&packet,size);
    int index = 0;
    int result = 0;
    int gotPicture = 0;   
    while (fread(frameBuffer,1,ySize * 3 / 2,inputFile)){
        frame->data[0] = frameBuffer;
        frame->data[1] = frameBuffer + ySize;
        frame->data[2] = frameBuffer + ySize * 5 / 4;
        frame->pts = index;
        result = avcodec_encode_video2(codecContext,&packet,frame,&gotPicture);
        if (result < 0) {
            av_log(NULL,AV_LOG_ERROR,"cannot encode video!");
            return -1;
        }
        if (gotPicture) {
            index++;
            packet.stream_index = videoStream->index;
            result = av_write_frame(formatContext,&packet);
            av_free_packet(&packet);
            printf("index=%d\tpts=%lld\tsize:%d\tySize:%d\n",index,frame->pts,size,ySize);
        }
    }
    result = flushEncoder(formatContext,0);
    if (result < 0) {
        printf("flush Encoder failed!\n");
        return -1;
    }
    av_write_trailer(formatContext);
    if (videoStream) {
        avcodec_close(videoStream->codec);
        av_frame_free(&frame);
        av_free(frameBuffer);
    }
    avio_close(formatContext->pb);
    avformat_free_context(formatContext);
    fclose(inputFile);
    return 0;
}