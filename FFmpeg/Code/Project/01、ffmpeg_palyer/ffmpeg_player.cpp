#include <stdio.h>

#ifdef __cplusplus
extern "C"{
    #include <libavformat/avformat.h>
    #include <libavcodec/avcodec.h>
    #include <libswscale/swscale.h>
    // #include <SDL/SDL.h>
    // #include <SDL/SDL_main.h>
    // #include <SDL2/SDL.h>
};
#endif

int main (int argc,char *argv[]) {
    char *fileName = argv[1];
    if (!fileName){
        av_log(NULL,AV_LOG_ERROR,"input file is null");
        return -1;
    }
    av_register_all();
    AVFormatContext *formatContext = avformat_alloc_context();
    int result = avformat_open_input(&formatContext,fileName,NULL,NULL);
    if (result < 0){
        av_log(NULL,AV_LOG_ERROR,"can not open input file!");
        return -1;
    }
    if (avformat_find_stream_info(formatContext,NULL) < 0){
        av_log(NULL,AV_LOG_ERROR,"cannot find stream info");
        return -1;
    }

    printf("------------- File Information ------------------\n");
    av_dump_format(formatContext,0,fileName,0);
    printf("-------------------------------------------------\n");

    int videoIndex = -1;
    for (int i = 0; i < formatContext->nb_streams; i++){
        AVStream *stream = formatContext->streams[i];
        if (stream->codec->codec_type == AVMEDIA_TYPE_VIDEO){
            videoIndex = i;
            break;
        }
    }
    AVCodecContext *codecContext = formatContext->streams[videoIndex]->codec;
    AVCodec *codec = avcodec_find_decoder(codecContext->codec_id);
    if (!codec) {
        av_log(NULL,AV_LOG_ERROR,"cannot find codec");
        return -1;
    }
    if (avcodec_open2(codecContext,codec,NULL) < 0){
        av_log(NULL,AV_LOG_ERROR,"cannot open decoder");
        return -1;
    }

    // if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_TIMER)){
    // //     printf("cannot not init SDL %s\n",SDL_GetError());
    // //     return -1;
    // }

    // int width = codecContext->width;
    // int height = codecContext->height;

    // SDL_Surface *screen = SDL_SetVideoMode(width,height,0,0);
    // if (!screen){
    //     printf("cannot not set video mode %s\n",SDL_GetError());
    //     return -1;
    // }

    // SDL_Overlay *bmp = SDL_CreateYUVOverlay(width,height,SDL_YV12_OVERLAY,screen);
    // SDL_Rect rect = {0, 0 ,width, height};
    // SDL_WM_SetCaption("Simplest FFmpeg Player",NULL);

    // AVFrame *frame = av_frame_alloc();
    // AVFrame *frameYUV = av_frame_alloc();

    // FILE *yuvFile = fopen("output.yuv","wb+");

    //  = sws_getContext(
    //     width,
    //     height,
    //     codecContext->pix_fmt,
    //     width,
    //     height,
    //     AV_PIX_FMT_YUV420P,
    //     SWS_BICUBIC,
    //     NULL,NULL,NULL);

    struct SwsContext *imageConvertContext;

    imageConvertContext = sws_getContext(codecContext->width, codecContext->height, codecContext->pix_fmt, codecContext->width, codecContext->height, AV_PIX_FMT_YUV420P, SWS_BICUBIC, NULL, NULL, NULL); 
    
    // AVPacket *packet = av_malloc(sizeof(AVPacket));
    // while (av_read_frame(codecContext,packet) >= 0){
    //     if (packet->stream_index == videoIndex){
    //         /* code */
    //     }
        
    // }
    
    
    //avformat_find_stream_info
}