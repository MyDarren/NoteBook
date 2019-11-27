#include <stdio.h>

#ifdef __cplusplus
extern "C"{
    #include <libavformat/avformat.h>
    #include <libavcodec/avcodec.h>
    #include <libswscale/swscale.h>
    #include <libavutil/imgutils.h>
    // #include <SDL/SDL.h>
    #include <SDL2/SDL.h>
};
#endif

#define SFM_REFRESH_EVENT (SDL_USEREVENT + 1)
#define SFM_BREAK_EVENT (SDL_USEREVENT + 2)

int thread_exit = 0;
int thread_pause = 0;

int sfp_refresh_thread(void *opaque){
    thread_exit = 0;
    thread_pause = 0;
    while (!thread_exit){
        if (!thread_pause) {
            SDL_Event event;
            event.type = SFM_REFRESH_EVENT;
            SDL_PushEvent(&event);
        }
        SDL_Delay(40);
    }
    thread_exit = 0;
    thread_pause = 0;
    SDL_Event event;
    event.type = SFM_BREAK_EVENT; 
    SDL_PushEvent(&event);
    
    return 0;
}

/*
#define SFM_REFRESH_EVENT (SDL_USEREVENT + 1)
int thread_exit = 0;

int sfp_refresh_thread(void *opaque){
    SDL_Event event;
    while(thread_exit == 0) {
        event.type = SFM_REFRESH_EVENT;
        SDL_PushEvent(&event);
        SDL_Delay(40);
    }
    return 0;
}
*/

int main (int argc,char *argv[]) {
    char *fileName = argv[1];
    if (!fileName){
        av_log(NULL,AV_LOG_ERROR,"input file is null");
        return -1;
    }
    //注册所有的编解码器，复用/解复用器等等组件。其中调用了avcodec_register_all()注册所有编解码器相关的组件
    av_register_all();
    avformat_network_init();
    //创建AVFormatContext结构体
    AVFormatContext *formatContext = avformat_alloc_context();
    //打开一个输入流（文件或者网络地址）。其中会调用avformat_new_stream()创建AVStream结构体。
    //avformat_new_stream()中会调用avcodec_alloc_context3()创建AVCodecContext结构体
    int result = avformat_open_input(&formatContext,fileName,NULL,NULL);
    if (result < 0){
        av_log(NULL,AV_LOG_ERROR,"can not open input file!");
        return -1;
    }
    //获取媒体的信息
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

    int width = codecContext->width;
    int height = codecContext->height;
    int out_buffer_size = av_image_get_buffer_size(AV_PIX_FMT_YUV420P,width,height,1);
    unsigned char *outBuffer = (unsigned char *)av_malloc(out_buffer_size);

    AVFrame *frame = av_frame_alloc();
    AVFrame *frameYUV = av_frame_alloc();
    AVPacket *packet = (AVPacket *)av_malloc(sizeof(AVPacket));
    av_image_fill_arrays(frameYUV->data,frameYUV->linesize,outBuffer,AV_PIX_FMT_YUV420P,width,height,1);
    
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

    FILE *yuvFile = fopen("output.yuv","wb+");
    int gotPicture;

    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_EVENTS)) {
        printf("cannot not init SDL %s\n",SDL_GetError());
        return -1;
    }

    SDL_Window *window = SDL_CreateWindow(
        "simple ffmpeg player' window", 
        SDL_WINDOWPOS_UNDEFINED,
        SDL_WINDOWPOS_UNDEFINED,
        width,
        height,
        SDL_WINDOW_OPENGL
    );
    
    if (!window){
        printf("cannot not create window %s\n",SDL_GetError());
        return -1;
    }

    SDL_Renderer *renderer = SDL_CreateRenderer(window,-1,0);
    SDL_Texture *texture = SDL_CreateTexture(
        renderer,
        SDL_PIXELFORMAT_IYUV,
        SDL_TEXTUREACCESS_STREAMING,
        width,
        height
    );
    SDL_Rect rect;
    rect.x = 0;
    rect.y = 0;
    rect.w = width;
    rect.h = height;

    SDL_Thread *videoThread = SDL_CreateThread(sfp_refresh_thread,NULL,NULL);
    SDL_Event event;

    for (;;) {
        SDL_WaitEvent(&event);
        if (event.type == SFM_REFRESH_EVENT) {
            while (1){
                //获取媒体的一帧压缩编码数据。其中调用了av_parser_parse2()
                if (av_read_frame(formatContext,packet) < 0) {
                    thread_exit = 1;
                }
                if (packet->stream_index == videoIndex) {
                    break;
                }
            }
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
                SDL_UpdateTexture(texture,&rect,frameYUV->data[0],frameYUV->linesize[0]);
                SDL_RenderClear(renderer);
                SDL_RenderCopy(renderer,texture,NULL,NULL);
                SDL_RenderPresent(renderer);
            }
            av_free_packet(packet);
        }else if (event.type == SDL_KEYDOWN) {
            if (event.key.keysym.sym == SDLK_SPACE) {
                thread_pause = !thread_pause;
            }
        }else if (event.type == SDL_QUIT) {
            thread_exit = 1;
        }else if (event.type == SFM_BREAK_EVENT) {
            break;
        }
    }

    while (1) {
		result = avcodec_decode_video2(codecContext, frame, &gotPicture, packet);
		if (result < 0)
			break;
		if (!gotPicture)
			break;
		sws_scale(
            imageConvertContext, 
            frame->data, 
            frame->linesize, 
            0, 
            codecContext->height, 
			frameYUV->data, 
            frameYUV->linesize
        );
		SDL_UpdateTexture(texture, &rect, frameYUV->data[0], frameYUV->linesize[0]);  
		SDL_RenderClear(renderer);  
		SDL_RenderCopy(renderer, texture,  NULL, NULL);  
		SDL_RenderPresent(renderer);  
		SDL_Delay(40);
	}

    /*
    while (av_read_frame(formatContext,packet) >= 0){
        if (packet->stream_index == videoIndex) {
            result = avcodec_decode_video2(codecContext,frame,&gotPicture,packet);
            if (result < 0) {
                av_log(NULL,AV_LOG_ERROR,"fail to decode video");
                return -1;
            }
            if (gotPicture) {
                sws_scale(imageConvertContext,
                    frame->data,
                    frame->linesize,
                    0,
                    height,
                    frameYUV->data,
                    frameYUV->linesize
                );
                int size = width * height;
                fwrite(frameYUV->data[0],1,size,yuvFile);
                fwrite(frameYUV->data[1],1,size / 4,yuvFile);
                fwrite(frameYUV->data[2],1,size / 4,yuvFile);

#if 1

                SDL_UpdateTexture(texture,
                    NULL,
                    frameYUV->data[0],
                    frameYUV->linesize[0]
                );

#else

                SDL_UpdateYUVTexture(texture,
                    &rect,
                    frameYUV->data[0],
                    frameYUV->linesize[0],
                    frameYUV->data[1],
                    frameYUV->linesize[1],
                    frameYUV->data[2],
                    frameYUV->linesize[2]);

#endif

                SDL_RenderClear(renderer);
                SDL_RenderCopy(renderer,texture,NULL,&rect);
                SDL_RenderPresent(renderer);
                SDL_Delay(40);

            }
        }
        av_free_packet(packet);
    }
    
    while (1){
        result = avcodec_decode_video2(codecContext,frame,&gotPicture,packet);
        if (result < 0 || !gotPicture) {
            break;
        }
        sws_scale(imageConvertContext,
                    frame->data,
                    frame->linesize,
                    0,
                    height,
                    frameYUV->data,
                    frameYUV->linesize
                );
                int size = width * height;
                fwrite(frameYUV->data[0],1,size,yuvFile);
                fwrite(frameYUV->data[1],1,size / 4,yuvFile);
                fwrite(frameYUV->data[2],1,size / 4,yuvFile);

#if 1

                SDL_UpdateTexture(texture,
                    NULL,
                    frameYUV->data[0],
                    frameYUV->linesize[0]
                );

#else

                SDL_UpdateYUVTexture(texture,
                    &rect,
                    frameYUV->data[0],
                    frameYUV->linesize[0],
                    frameYUV->data[1],
                    frameYUV->linesize[1],
                    frameYUV->data[2],
                    frameYUV->linesize[2]);

#endif

                SDL_RenderClear(renderer);
                SDL_RenderCopy(renderer,texture,NULL,&rect);
                SDL_RenderPresent(renderer);
                SDL_Delay(40);
    }
    */
    
    /*
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_TIMER)){
        printf("cannot not init SDL %s\n",SDL_GetError());
        return -1;
    }

    SDL_Surface *surface = SDL_SetVideoMode(width,height,0,0);
    if (!surface){
        printf("cannot not set video mode %s\n",SDL_GetError());
        return -1;
    }

    SDL_Overlay *overlay = SDL_CreateYUVOverlay(width,height,SDL_YV12_OVERLAY,surface);
    SDL_Rect rect;
    rect.x = 0;
    rect.y = 0;
    rect.w = width;
    rect.h = height;

    SDL_WM_SetCaption("Simplest FFmpeg Player",NULL);

    SDL_Thread *videoThread = SDL_CreateThread(sfp_refresh_thread,NULL);
    SDL_Event event;

    for(;;){
        SDL_WaitEvent(&event);
        if (event.type == SFM_REFRESH_EVENT){
            if (av_read_frame(formatContext,packet) >= 0) {
                if (packet->stream_index == videoIndex) {
                    result = avcodec_decode_video2(codecContext,frame,&gotPicture,packet);
                    if (result < 0) {
                        av_log(NULL,AV_LOG_ERROR,"fail to decode video");
                        return -1;
                    }
                    if (gotPicture) {
                        SDL_LockYUVOverlay(overlay);
                        frameYUV->data[0] = overlay->pixels[0];
                        frameYUV->data[1] = overlay->pixels[2];
                        frameYUV->data[2] = overlay->pixels[1];
                        frameYUV->linesize[0] = overlay->pitches[0];
                        frameYUV->linesize[1] = overlay->pitches[2];
                        frameYUV->linesize[2] = overlay->pitches[1];
                        sws_scale(imageConvertContext,frame->data,frame->linesize,0,height,frameYUV->data,frameYUV->linesize);

                        SDL_UnlockYUVOverlay(overlay);
                        SDL_DisplayYUVOverlay(overlay,&rect);
                    }
                }
                av_free_packet(packet);
            }else{
                thread_exit = 1;
                break;
            }
        }
    }
    
    while (av_read_frame(formatContext,packet) >= 0){
        if (packet->stream_index == videoIndex){
            result = avcodec_decode_video2(codecContext,frame,&gotPicture,packet);
            if (result < 0){
                av_log(NULL,AV_LOG_ERROR,"fail to decode video");
                return -1;
            }
            if (gotPicture){
                SDL_LockYUVOverlay(overlay);
                frameYUV->data[0] = overlay->pixels[0];
                frameYUV->data[1] = overlay->pixels[1];
                frameYUV->data[2] = overlay->pixels[2];
                frameYUV->linesize[0] = overlay->pitches[0];
                frameYUV->linesize[1] = overlay->pitches[2];
                frameYUV->linesize[2] = overlay->pitches[1];
                sws_scale(imageConvertContext,frame->data,frame->linesize,0,height,frameYUV->data,frameYUV->linesize);
                
                int size = width * height;
                fwrite(frameYUV->data[0],1,size,yuvFile);
                fwrite(frameYUV->data[1],1,size / 4,yuvFile);
                fwrite(frameYUV->data[2],1,size / 4,yuvFile);

                SDL_UnlockYUVOverlay(overlay);
                SDL_DisplayYUVOverlay(overlay,&rect);
                SDL_Delay(40);
            }
        }
        av_free_packet(packet);
    }
    
    while (1){
        result = avcodec_decode_video2(codecContext,frame,&gotPicture,packet);
        if (result < 0 || !gotPicture){
            break;
        }
        sws_scale(imageConvertContext,frame->data,frame->linesize,0,height,frameYUV->data,frameYUV->linesize);

        SDL_LockYUVOverlay(overlay);
        frameYUV->data[0] = overlay->pixels[0];
        frameYUV->data[1] = overlay->pixels[2];
        frameYUV->data[2] = overlay->pixels[1];
        frameYUV->linesize[0] = overlay->pitches[0];
        frameYUV->linesize[1] = overlay->pitches[2];
        frameYUV->linesize[2] = overlay->pitches[1];

        int size = width * height;
        fwrite(frameYUV->data[0],1,size,yuvFile);
        fwrite(frameYUV->data[1],1,size / 4,yuvFile);
        fwrite(frameYUV->data[2],1,size / 4,yuvFile);

        SDL_UnlockYUVOverlay(overlay);
        SDL_DisplayYUVOverlay(overlay,&rect);
        SDL_Delay(40);
    }
    */
    
    sws_freeContext(imageConvertContext);

    fclose(yuvFile);
    SDL_Quit();
    av_free(outBuffer);
    av_free(packet);
    av_frame_free(&frame);
    av_frame_free(&frameYUV);
    avcodec_close(codecContext);
    avformat_close_input(&formatContext);
    avformat_free_context(formatContext);
    avformat_network_deinit();

    return 0;
    //clang -g -o ffmpeg_videoplayer ffmpeg_videoplayer.cpp `pkg-config --libs libavformat,libavcodec,libswscale,libavutil,SDL2`
}