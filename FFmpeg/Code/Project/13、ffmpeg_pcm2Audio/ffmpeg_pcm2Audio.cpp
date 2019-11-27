#include <stdio.h>

#ifdef __cplusplus
extern "C" {
    #include <libavformat/avformat.h>
    #include <libavcodec/avcodec.h>
    #include <libswresample/swresample.h>
    #include <libavutil/samplefmt.h>
};
#endif

int flushEncoder(AVFormatContext *formatContext,unsigned int streamIndex) {
    int result;
    int gotPicture;
    AVPacket packet;
    AVCodecContext *codecContext = formatContext->streams[streamIndex]->codec;
    if (!(codecContext->codec->capabilities & AV_CODEC_CAP_DELAY)){
        return 0;
    }
    while (1){
        packet.data = NULL;
        packet.size = 0;
        av_init_packet(&packet);
        result = avcodec_encode_audio2(codecContext,&packet,NULL,&gotPicture);
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

int main (int argc,char *argv[]){
    const char *inputFileName = "WavinFlag.pcm";
    const char *outputFileName = "WavinFlag.aac";
    FILE *inputFile = fopen(inputFileName,"rb");
    av_register_all();
    AVFormatContext *formatContext;
    AVOutputFormat *outputFormat;
    if (avformat_alloc_output_context2(&formatContext,NULL,NULL,outputFileName) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot alloc output formatContext!");
        return -1;
    }
    outputFormat = formatContext->oformat;

    if (avio_open(&formatContext->pb,outputFileName,AVIO_FLAG_READ_WRITE) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot open output file!");
        return -1;
    }

    AVStream *stream = avformat_new_stream(formatContext,NULL);
    if (!stream) {
        av_log(NULL,AV_LOG_ERROR,"cannot alloc new stream!");
        return -1;
    }

    AVCodec *codec = avcodec_find_encoder(outputFormat->audio_codec);
    if (!codec) {
        av_log(NULL,AV_LOG_ERROR,"cannot find output encoder!");
        return -1;
    }

    AVCodecContext *codecContext = stream->codec;
    codecContext->codec_id = outputFormat->audio_codec;
    codecContext->codec_type = AVMEDIA_TYPE_AUDIO;
    codecContext->sample_fmt = codec->sample_fmts[0];
    codecContext->sample_rate = 44100;
    codecContext->channel_layout = AV_CH_LAYOUT_STEREO;
    codecContext->channels = av_get_channel_layout_nb_channels(codecContext->channel_layout);
    codecContext->bit_rate = 144100;
    codecContext->profile = FF_PROFILE_AAC_MAIN;
    codecContext->strict_std_compliance = FF_COMPLIANCE_EXPERIMENTAL;
    av_dump_format(formatContext,0,outputFileName,true);

    if (avcodec_open2(codecContext,codec,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot open output encoder!");
        return -1;
    }

    SwrContext *audioConvertContext = swr_alloc();
    audioConvertContext = swr_alloc_set_opts(
        audioConvertContext,
        codecContext->channel_layout,
        AV_SAMPLE_FMT_FLTP,
        codecContext->sample_rate,
        codecContext->channel_layout,
        AV_SAMPLE_FMT_S16,
        codecContext->sample_rate,
        0,
        NULL
    );
    swr_init(audioConvertContext);

    AVFrame *frame = av_frame_alloc();
    frame->nb_samples = codecContext->frame_size;
    frame->format = codecContext->sample_fmt;

    uint8_t **convertData = (uint8_t **)calloc(codecContext->channels,sizeof(*convertData));
    av_samples_alloc(convertData,NULL,codecContext->channels,codecContext->frame_size,codecContext->sample_fmt,1);

    int size = av_samples_get_buffer_size(
        NULL,
        codecContext->channels,
        codecContext->frame_size,
        codecContext->sample_fmt,
        1
    );

    uint8_t *frameBuffer = (uint8_t *)av_malloc(size);
    avcodec_fill_audio_frame(
        frame,
        codecContext->channels,
        codecContext->sample_fmt,
        frameBuffer,
        size,
        1
    );
    
    avformat_write_header(formatContext,NULL);
    AVPacket packet;
    av_new_packet(&packet,size);
    int index = 0;
    int result = 0;
    int gotPicture = 0;
    while (fread(frameBuffer,1,4096,inputFile)){
        swr_convert(
            audioConvertContext,
            convertData,
            codecContext->frame_size,
            (const uint8_t **)frame->data,
            codecContext->frame_size
        );

        int length = codecContext->frame_size * av_get_bytes_per_sample(codecContext->sample_fmt);
        memcpy(frame->data[0],convertData[0],length);
        memcpy(frame->data[1],convertData[1],length);
        
        frame->pts = index * 100;
        gotPicture = 0;
        result = avcodec_encode_audio2(codecContext,&packet,frame,&gotPicture);
        if (result < 0) {
            av_log(NULL,AV_LOG_ERROR,"cannot encode audio!");
            return -1;
        }
        if (packet.data == NULL) {
            continue;
        }
        if (gotPicture) {
            index ++;
            packet.stream_index = stream->index;
            result = av_write_frame(formatContext,&packet);
            av_free_packet(&packet);
        }
    }
    result = flushEncoder(formatContext,0);
    if (result < 0) {
        return -1;
    }
    av_write_trailer(formatContext);
    if (stream) {
        avcodec_close(codecContext);
        av_free(frameBuffer);
        av_frame_free(&frame);
    }

    avio_close(formatContext->pb);
    avformat_free_context(formatContext);
    fclose(inputFile);
    
    return 0;
}