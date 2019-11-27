#include <stdio.h>

#ifdef __cplusplus
extern "C" {
    #include <libavcodec/avcodec.h>
};
#endif

#define TEST_H264 0
#define TEST_HEVC 0

int main (int argc, char *argv[]){

    AVCodecID codecID = AV_CODEC_ID_NONE;
    char outputFileName[] = "out_bigbuckbunny_480x272.yuv";

#if TEST_H264
    codecID = AV_CODEC_ID_H264;
    char inputFileName[] = "../../../Resource/bigbuckbunny_480x272.h264";
#elif TEST_HEVC
    codecID = AV_CODEC_ID_HEVC;
    char inputFileName[] = "../../../Resource/bigbuckbunny_480x272.hevc";
#else
    codecID = AV_CODEC_ID_MPEG2VIDEO;
    char inputFileName[] = "../../../Resource/bigbuckbunny_480x272.m2v";
#endif

    avcodec_register_all();

    AVCodec *codec = avcodec_find_decoder(codecID);
    if (!codec) {
        av_log(NULL,AV_LOG_ERROR,"cannot find decoder");
        return -1;
    }
    AVCodecContext *codecContext = avcodec_alloc_context3(codec);
    if (!codecContext) {
        av_log(NULL,AV_LOG_ERROR,"cannot alloc video codec context");
        return -1;
    }
    AVCodecParserContext *parserContext = av_parser_init(codecID);
    if (!parserContext) {
        av_log(NULL,AV_LOG_ERROR,"cannot alloc video parser context");
        return -1;
    }
    if (avcodec_open2(codecContext,codec,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot open codec");
        return -1;
    }
    FILE *inputFile = fopen(inputFileName,"rb");
    if (!inputFile) {
        av_log(NULL,AV_LOG_ERROR,"cannot open input stream");
        return -1;
    }
    FILE *outputFile = fopen(outputFileName,"wb");
    if (!outputFile) {
        av_log(NULL,AV_LOG_ERROR,"cannot open output yuv file");
        return -1;
    }
    AVFrame *frame = av_frame_alloc();
    AVPacket packet;
    av_init_packet(&packet);

    int result,gotPicture,size;
    int current_size = 0;
    int firstTime = 1;
    const int in_buffer_size = 4096;
    uint8_t in_buffer[in_buffer_size + AV_INPUT_BUFFER_PADDING_SIZE] = {0};
    uint8_t *current_ptr;

    while (1){
        current_size = fread(in_buffer,1,in_buffer_size,inputFile);
        if (!current_size){
            break;
        }
        current_ptr = in_buffer;
        while (current_size > 0){
            int length = av_parser_parse2(
                parserContext,
                codecContext,
                &packet.data,
                &packet.size,
                current_ptr,
                current_size,
                AV_NOPTS_VALUE,
                AV_NOPTS_VALUE,
                AV_NOPTS_VALUE
            );
            current_ptr += length;
            current_size -= length;
            if (!packet.size) {
                continue;
            }
            printf("packet.size=%d\n",packet.size);
            switch (parserContext->pict_type){
                case AV_PICTURE_TYPE_I:
                    printf("Type:I\t");
                    break;
                case AV_PICTURE_TYPE_P:
                    printf("Type:P\t");
                    break;
                case AV_PICTURE_TYPE_B:
                    printf("Type:B\t");
                    break;
                default:
                    printf("Type:Other\t");
                    break;
            }
            printf("Number:%4d\n",parserContext->output_picture_number);

            result = avcodec_decode_video2(codecContext,frame,&gotPicture,&packet);
            if (result < 0) {
                av_log(NULL,AV_LOG_ERROR,"fail to decode");
                return -1;
            }
            if (gotPicture) {
                if (firstTime) {
                    av_log(NULL,AV_LOG_INFO,"Codec Full Name:%s\n",codecContext->codec->long_name);
                    av_log(NULL,AV_LOG_INFO,"width:%d---height:%d\n",codecContext->width,codecContext->height);
                    firstTime = 0;
                }
                for (int i = 0; i < frame->height; i++){
                    fwrite(frame->data[0] + frame->linesize[0] * i, 1,frame->width,outputFile);
                }
                for (int i = 0; i < frame->height / 2; i++){
                    fwrite(frame->data[1] + frame->linesize[1] * i, 1,frame->width / 2,outputFile);
                }
                for (int i = 0; i < frame->height / 2; i++){
                    fwrite(frame->data[2] + frame->linesize[2] * i, 1,frame->width / 2,outputFile);
                }
                printf("succeed to decode frame\n");
            }
        }
        
    }
    packet.data = NULL;
    packet.size = 0;

    while (1){
        result = avcodec_decode_video2(codecContext,frame,&gotPicture,&packet);
        if (result < 0 || !gotPicture) {
            break;
        }
        for (int i = 0; i < frame->height; i++){
            fwrite(frame->data[0] + frame->linesize[0] * i, 1,frame->width,outputFile);
        }
        for (int i = 0; i < frame->height / 2; i++){
            fwrite(frame->data[1] + frame->linesize[1] * i, 1,frame->width / 2,outputFile);
        }
        for (int i = 0; i < frame->height / 2; i++){
            fwrite(frame->data[2] + frame->linesize[2] * i, 1,frame->width / 2,outputFile);
        }
        printf("Flush Decoder: Succeed to decode frame\n");
    }

    fclose(inputFile);
    fclose(outputFile);
    av_parser_close(parserContext);
    av_frame_free(&frame);
    avcodec_close(codecContext);
    av_free(codecContext);
    
    return 0;
}