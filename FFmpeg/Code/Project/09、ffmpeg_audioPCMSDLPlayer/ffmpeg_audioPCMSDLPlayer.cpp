#include <stdio.h>

#ifdef __cplusplus
extern "C" {
    #include <SDL2/SDL.h>
};
#endif

static Uint8 *audio_chunk;
static Uint32 audio_len;
static Uint8 *audio_pos;

void fill_Audio(void *udata,Uint8 *stream,int len){
    SDL_memset(stream,0,len);
    if (audio_len == 0) {
        return;
    }
    len = len > audio_len ? audio_len : len;
    SDL_MixAudio(stream,audio_pos,len,SDL_MIX_MAXVOLUME);
    audio_pos += len;
    audio_len -= len;
}

int main(int argc,char *argv[]) {

    char *fileName = argv[1];
    if (!fileName) {
        printf("input file is null!\n");
        return -1;
    }

    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_TIMER)) {
        printf("cannot init SDL:%s\n",SDL_GetError());
        return -1;
    }

    int out_sample_rate = 44100;
    SDL_AudioFormat out_sample_fmt = AUDIO_S16SYS;
    int out_channels = 2;
    int out_nb_samples = 1024;

    SDL_AudioSpec wanted_spec;
    wanted_spec.freq = out_sample_rate;
    wanted_spec.format = out_sample_fmt;
    wanted_spec.channels = out_channels;
    wanted_spec.silence = 0;
    wanted_spec.samples = out_nb_samples;
    wanted_spec.callback = fill_Audio;

    if (SDL_OpenAudio(&wanted_spec,NULL) < 0) {
        printf("cannot open SDL:%s\n",SDL_GetError());
        return -1;
    }

    FILE *pcmFile = fopen(fileName,"rb+");
    if (!pcmFile) {
        printf("cannot open input file!");
        return -1;
    }

    int pcm_buffer_size = 4096;
    char *pcm_buffer = (char *)malloc(pcm_buffer_size);
    int data_count = 0;

    while (1){
        if (fread(pcm_buffer,1,pcm_buffer_size,pcmFile) != pcm_buffer_size) {
            fseek(pcmFile,0,SEEK_SET);
            fread(pcm_buffer,1,pcm_buffer_size,pcmFile);
            data_count = 0;
        }
        printf("Now playing %10d Bytes daya.\n",data_count);
        data_count += pcm_buffer_size;
        audio_chunk = (Uint8 *)pcm_buffer;
        audio_len = pcm_buffer_size;
        audio_pos = audio_chunk;
        SDL_PauseAudio(0);
        while (audio_len > 0){
            SDL_Delay(1);
        }
    }
    free(pcm_buffer);
    fclose(pcmFile);
    SDL_Quit();
    return 0;
}