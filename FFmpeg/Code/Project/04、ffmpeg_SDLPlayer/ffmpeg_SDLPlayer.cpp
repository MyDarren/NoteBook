#include <stdio.h>

#ifdef __cplusplus
extern "C" {
    #include <SDL2/SDL.h>
}
#endif

int windowWidth = 500;
int windowHeight = 500;
const int pixelWidth = 480;
const int pixelHeight = 272;

const int bpp = 12;
unsigned char *buffer[pixelWidth * pixelHeight * bpp / 8];

#define SFM_REFRESH_EVENT (SDL_USEREVENT + 1)
#define SFM_BREAK_EVENT (SDL_USEREVENT + 2)

int thread_exit = 0;

int sfp_refresh_thread (void *opaque){
    thread_exit = 0;
    while (!thread_exit){
        SDL_Event event;
        event.type = SFM_REFRESH_EVENT;
        SDL_PushEvent(&event);
        SDL_Delay(40);
    }
    thread_exit = 0;
    SDL_Event event;
    event.type = SFM_BREAK_EVENT;
    SDL_PushEvent(&event);

    return 0;
}

int main (int argc,char *argv[]) {
    char *fileName = argv[1];
    if (!fileName) {
        printf("input file is null\n");
        return -1;
    }
    if (SDL_Init(SDL_INIT_VIDEO)) {
        printf("cannot init SDL:%s",SDL_GetError());
        return -1;
    }
    SDL_Window *window = SDL_CreateWindow(
        "ffmpeg SDL Player",
        SDL_WINDOWPOS_UNDEFINED,
        SDL_WINDOWPOS_UNDEFINED,
        windowWidth,
        windowHeight,
        SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE
    );
    if (!window) {
        printf("cannot create window:%s",SDL_GetError());
        return -1;
    }
    SDL_Renderer *renderer = SDL_CreateRenderer(window,-1,0);
    SDL_Texture *texture = SDL_CreateTexture(
        renderer,
        SDL_PIXELFORMAT_IYUV,
        SDL_TEXTUREACCESS_STREAMING,
        pixelWidth,
        pixelHeight
    );
    SDL_Rect rect;
    rect.x = 0;
    rect.y = 0;
    rect.w = windowWidth;
    rect.h = windowHeight;

    SDL_Thread *thread = SDL_CreateThread(sfp_refresh_thread,NULL,NULL);
    SDL_Event event;

    FILE *inputFile = fopen(fileName,"rb+");

    while (1){
        SDL_WaitEvent(&event);
        if (event.type == SFM_REFRESH_EVENT) {
            if (fread(buffer,1,pixelWidth * pixelHeight * bpp / 8, inputFile) != pixelWidth * pixelHeight * bpp / 8) {
                fseek(inputFile,0,SEEK_SET);
                fread(buffer,1,pixelWidth * pixelHeight * bpp / 8,inputFile);
            }
            SDL_UpdateTexture(texture,NULL,buffer,pixelWidth);
            
            rect.x = 0;
            rect.y = 0;
            rect.w = windowWidth;
            rect.h = windowHeight;

            SDL_RenderClear(renderer);
            SDL_RenderCopy(renderer,texture,NULL,&rect);
            SDL_RenderPresent(renderer);
        }else if (event.type == SDL_WINDOWEVENT) {
            SDL_GetWindowSize(window,&windowWidth,&windowHeight);
        }else if (event.type == SDL_QUIT) {
            thread_exit = 1;
        }else if (event.type == SFM_BREAK_EVENT) {
            break;
        }
    }
    SDL_Quit();
    return 0;
}