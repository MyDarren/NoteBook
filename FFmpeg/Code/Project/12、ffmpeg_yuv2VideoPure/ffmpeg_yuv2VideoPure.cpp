#include <stdio.h>

#ifdef __cplusplus
extern "C" {
    #include <libavcodec/avcodec.h>
    #include <libavutil/imgutils.h>
    #include <libavutil/opt.h>
}
#endif

#define TEST_H264 0
#define TEST_HEVC 0

int main (int argc, char *argv[]){
    const char *inputFileName = "bigbuckbunny_480x272.yuv";
    const char *outputFileName = "bigbuckbunny_480x272.h264";
    int inputWidth = 480;
    int inputHeight = 272;
    AVCodecID codecID = AV_CODEC_ID_H264;

#if TEST_H264
    outputFileName = "bigbuckbunny_480x272.h264";
    codecID = AV_CODEC_ID_H264;
#else
    outputFileName = "bigbuckbunny_480x272.hevc";
    codecID = AV_CODEC_ID_HEVC;
#endif

    avcodec_register_all();
    AVCodec *codec = avcodec_find_encoder(codecID);
    if (!codec) {
        av_log(NULL,AV_LOG_ERROR,"cannot find encoder!");
        return -1;
    }
    AVCodecContext *codecContext = avcodec_alloc_context3(codec);
    if (!codecContext) {
        av_log(NULL,AV_LOG_ERROR,"cannot alloc codec context!");
        return -1;
    }
    codecContext->codec_id = codecID;
    codecContext->codec_type = AVMEDIA_TYPE_VIDEO;
    codecContext->pix_fmt = AV_PIX_FMT_YUV420P;
    codecContext->width = inputWidth;
    codecContext->height = inputHeight;
    codecContext->bit_rate = 400000;
    codecContext->gop_size = 250;
    codecContext->time_base.num = 1;
    codecContext->time_base.den = 25;
    codecContext->max_b_frames = 1;

    if (codecID == AV_CODEC_ID_H264) {
        av_opt_set(codecContext->priv_data,"preset","slow",0);
        av_opt_set(codecContext->priv_data,"tune","zerolatency",0);
    }
    if (avcodec_open2(codecContext,codec,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot open codec!");
        return -1;
    }

    AVFrame *frame = av_frame_alloc();
    frame->format = codecContext->pix_fmt;
    frame->width = codecContext->width;
    frame->height = codecContext->height;
    int result = av_image_alloc(
        frame->data,
        frame->linesize,
        codecContext->width,
        codecContext->height,
        codecContext->pix_fmt,
        16
    );
    if (result < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot alloc raw picture!");
        return -1;
    }

    FILE *inputFile = fopen(inputFileName,"rb");
    if (!inputFile) {
        printf("cannot open input file!\n");
        return -1;
    }
    FILE *outputFile = fopen(outputFileName,"wb");
    if (!outputFile) {
        printf("cannot open output file!\n");
        return -1;
    }

    int ySize = codecContext->width * codecContext->height;
    AVPacket packet;
    av_new_packet(&packet,result);
    int index = 0;
    int gotPicture = 0;
    while (fread(frame->data[0],1,ySize,inputFile) &&
           fread(frame->data[1],1,ySize / 4,inputFile) &&
           fread(frame->data[2],1,ySize / 4,inputFile)){
        frame->pts = index;
        result = avcodec_encode_video2(codecContext,&packet,frame,&gotPicture);
        if (result < 0) {
            av_log(NULL,AV_LOG_ERROR,"cannot encoder video!");
            return -1;
        }
        if (gotPicture) {
            index++;
            fwrite(packet.data,1,packet.size,outputFile);
            av_free_packet(&packet);
        }
    }
    fclose(inputFile);
    fclose(outputFile);
    av_freep(&frame->data[0]);
    av_frame_free(&frame);
    av_free_packet(&packet);
    avcodec_close(codecContext);
    avcodec_free_context(&codecContext);
    
    return 0;
}