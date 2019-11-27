#include <stdio.h>

#ifdef __cplusplus
extern "C" {
    #include <libavformat/avformat.h>
    #include <libavcodec/avcodec.h>
    #include <libswresample/swresample.h>
};
#endif

int main (int argc, char *argv[]) {
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

    FILE *pcmFile = fopen("output.pcm","wb");

    int out_channel_layout = AV_CH_LAYOUT_STEREO;
    AVSampleFormat out_sample_format = AV_SAMPLE_FMT_S16;
    int out_sample_rate = 44100;
    int out_channels = av_get_channel_layout_nb_channels(out_channel_layout);
    int out_nb_samples = codecContext->frame_size;

    int out_buffer_size = av_samples_get_buffer_size(
        NULL,
        out_channels,
        out_nb_samples,
        out_sample_format,
        1
    );
    uint8_t *out_buffer = (uint8_t *)av_malloc(out_buffer_size);

    struct SwrContext *audioConvertContext = swr_alloc();
    audioConvertContext = swr_alloc_set_opts(
        audioConvertContext,
        out_channel_layout,
        out_sample_format,
        out_sample_rate,
        codecContext->channel_layout,
        codecContext->sample_fmt,
        codecContext->sample_rate,
        0,
        NULL
    );
    swr_init(audioConvertContext);

    int result = 0;
    int gotPicture = 0;
    int index = 0;
    AVPacket *packet = (AVPacket *)av_malloc(sizeof(AVPacket));
    AVFrame *frame = av_frame_alloc();
    while (av_read_frame(formatContext,packet) >= 0){
        if (packet->stream_index == audioIndex) {
            result = avcodec_decode_audio4(codecContext,frame,&gotPicture,packet);
            if (result < 0) {
                av_log(NULL,AV_LOG_ERROR,"decode audio failed!");
                return -1;
            }
            if (gotPicture) {
                swr_convert(
                    audioConvertContext,
                    &out_buffer,
                    out_buffer_size,
                    (const uint8_t **)frame->data,
                    frame->nb_samples
                );
                printf("index:%5d\tpts:%lld\tpacketSize:%d\n",index,frame->pts,frame->pkt_size);
                index ++;
                fwrite(out_buffer,1,out_buffer_size,pcmFile);
            }
        }
        av_free_packet(packet);
    }
    swr_free(&audioConvertContext);
    fclose(pcmFile);
    av_free(out_buffer);
    av_frame_free(&frame);
    av_free_packet(packet);
    avcodec_close(codecContext);
    avformat_close_input(&formatContext);
    avformat_free_context(formatContext);
    
    return 0;
}