#include <stdio.h>

#ifdef __cplusplus
extern "C" {
    #include <libavformat/avformat.h>
    #include <libavcodec/avcodec.h>
    #include <libswresample/swresample.h>
    #include <SDL2/SDL.h>
};
#endif

static Uint8 *audio_chunk;
static Uint32 audio_len;
static Uint8 *audio_pos;

#define MAX_AUDIO_FRAME_SIZE 192000 // 1 second of 48kHZ 32bit audio

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

int main (int argc, char *argv[]){
    char *fileName = argv[1];
    if (!fileName) {
        av_log(NULL,AV_LOG_ERROR,"input file is null!");
        return -1;
    }
    av_register_all();
    avformat_network_init();
    AVFormatContext *formatContext = avformat_alloc_context();
    if (avformat_open_input(&formatContext,fileName,NULL,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot open input file!");
        return -1;
    }
    if (avformat_find_stream_info(formatContext,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot find input file stream info!");
        return -1;
    }
    av_dump_format(formatContext,0,fileName,false);
    int audioIndex = -1;
    for (int i = 0; i < formatContext->nb_streams; i++){
        AVStream *stream = formatContext->streams[i];
        if (stream->codec->codec_type == AVMEDIA_TYPE_AUDIO) {
            audioIndex = i;
            break;
        }
    }
    if (audioIndex == -1) {
        av_log(NULL,AV_LOG_ERROR,"cannot find input file audio stream!");
        return -1;
    }
    AVCodecContext *codecContext = formatContext->streams[audioIndex]->codec;
    AVCodec *codec = avcodec_find_decoder(codecContext->codec_id);
    if (!codec) {
        av_log(NULL,AV_LOG_ERROR,"cannot find input file audio stream decoder!");
        return -1;
    }
    if (avcodec_open2(codecContext,codec,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot open input file audio stream decoder!");
        return -1;
    }
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_TIMER)) {
        printf("cannot init SDL:%s\n",SDL_GetError());
        return -1;
    }

    uint64_t out_channel_layout = AV_CH_LAYOUT_STEREO;
    // int out_nb_samples = codecContext->frame_size;
    int out_nb_samples = 1024;
    AVSampleFormat out_sample_fmt = AV_SAMPLE_FMT_S16;
    int out_sample_rate = 44100;
    int out_channels = av_get_channel_layout_nb_channels(out_channel_layout);

    SDL_AudioSpec wanted_spec;
    wanted_spec.freq = out_sample_rate;
    wanted_spec.format = AUDIO_S16SYS;
    wanted_spec.channels = out_channels;
    wanted_spec.silence = 0;
    wanted_spec.samples = out_nb_samples;
    wanted_spec.callback = fill_Audio;
    wanted_spec.userdata = codecContext;

    if (SDL_OpenAudio(&wanted_spec,NULL) < 0) {
        printf("cannot open audio:%s\n",SDL_GetError());
        return -1;
    }

    FILE *pcmFile = fopen("output.pcm","wb");
    AVPacket *packet = (AVPacket *)av_malloc(sizeof(AVPacket));
    av_init_packet(packet);
    AVFrame *frame = av_frame_alloc();

    int out_buffer_size = av_samples_get_buffer_size(
        NULL,
        out_channels,
        out_nb_samples,
        out_sample_fmt,
        1
    );
    uint8_t *out_Buffer = (uint8_t *)av_malloc(MAX_AUDIO_FRAME_SIZE * 2);
    int in_channel_layout = av_get_default_channel_layout(codecContext->channels);
    struct SwrContext *audioConvertContext = swr_alloc();
    audioConvertContext = swr_alloc_set_opts(
        audioConvertContext,
        out_channel_layout,
        out_sample_fmt,
        out_sample_rate,
        in_channel_layout,
        codecContext->sample_fmt,
        codecContext->sample_rate,
        0,
        NULL
    );
    swr_init(audioConvertContext);
    SDL_PauseAudio(0);

    int result = 0;
    int gotPicture = 0;
    int index = 0;
    while (av_read_frame(formatContext,packet) >= 0){
        if (packet->stream_index == audioIndex) {
            result = avcodec_decode_audio4(codecContext,frame,&gotPicture,packet);
            if (result < 0) {
                av_log(NULL,AV_LOG_ERROR,"decode aduio failed!");
                return -1;
            }
            if (gotPicture) {
                swr_convert(
                    audioConvertContext,
                    &out_Buffer,
                    MAX_AUDIO_FRAME_SIZE,
                    (const uint8_t **)frame->data,
                    frame->nb_samples
                );
                printf("index:%5d\tpts:%lld\tpacketSize:%d\n",index,frame->pts,frame->pkt_size);

                if(wanted_spec.samples != frame->nb_samples){
					SDL_CloseAudio();
					out_nb_samples = frame->nb_samples;
					out_buffer_size = av_samples_get_buffer_size(
                        NULL,
                        out_channels,
                        out_nb_samples,
                        out_sample_fmt, 
                        1
                    );
					wanted_spec.samples = out_nb_samples;
					SDL_OpenAudio(&wanted_spec, NULL);
				}

                fwrite(out_Buffer,1,out_buffer_size,pcmFile);
                index++;
            }
            audio_chunk = (Uint8 *)out_Buffer;
            audio_len = out_buffer_size;
            audio_pos = audio_chunk;
            SDL_PauseAudio(0);
            while (audio_len > 0){
                SDL_Delay(1);
            }
        }
        av_free_packet(packet);
    }
    swr_free(&audioConvertContext);
    SDL_CloseAudio();
    SDL_Quit();
    fclose(pcmFile);
    av_frame_free(&frame);
    av_packet_free(&packet);
    av_free(out_Buffer);
    avcodec_close(codecContext);
    avformat_close_input(&formatContext);
    avformat_free_context(formatContext);
    return 0;
}