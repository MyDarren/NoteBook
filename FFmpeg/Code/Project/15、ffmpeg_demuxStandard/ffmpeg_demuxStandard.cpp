#include <stdio.h>

#ifdef __cplusplus
extern "C" {
    #include <libavformat/avformat.h>
    #include <libavcodec/avcodec.h>
};
#endif

int main (int argc,char *argv[]) {
    const char *inputFileName = "cuc_ieschool.ts";
    const char *outVideoFileName = "cuc_ieschool.h264";
    const char *outAudioFileName = "cuc_ieschool.aac";
    AVFormatContext *inputFormatContext;
    AVFormatContext *outVideoFormatContext;
    AVFormatContext *outAudioFormatContext;
    AVOutputFormat *outVideoFormat;
    AVOutputFormat *outAudioFormat;
    av_register_all();
    if (avformat_open_input(&inputFormatContext,inputFileName,NULL,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot open input file!");
        return -1;
    }
    if (avformat_find_stream_info(inputFormatContext,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot find input file stream info!");
        return -1;
    }
    avformat_alloc_output_context2(&outVideoFormatContext,NULL,NULL,outVideoFileName);
    if (!outVideoFormatContext) {
        av_log(NULL,AV_LOG_ERROR,"cannot create output video formatContext!");
        return -1;
    }
    outVideoFormat = outVideoFormatContext->oformat;

    avformat_alloc_output_context2(&outAudioFormatContext,NULL,NULL,outAudioFileName);
    if (!outAudioFormatContext) {
        av_log(NULL,AV_LOG_ERROR,"cannot create output audio formatContext!");
        return -1;
    }
    outAudioFormat = outAudioFormatContext->oformat;

    int videoIndex = -1;
    int audioIndex = -1;
    for (int i = 0; i < inputFormatContext->nb_streams; i++){
        AVStream *inStream = inputFormatContext->streams[i];
        AVStream *outStream = NULL;
        AVFormatContext *outFormatContext;
        if (inStream->codec->codec_type == AVMEDIA_TYPE_VIDEO){
            videoIndex = i;
            outStream = avformat_new_stream(outVideoFormatContext,inStream->codec->codec);
            outFormatContext = outVideoFormatContext;
        }else if (inStream->codec->codec_type == AVMEDIA_TYPE_AUDIO) {
            audioIndex = i;
            outStream = avformat_new_stream(outAudioFormatContext,inStream->codec->codec);
            outFormatContext = outAudioFormatContext;
        }else{
            break;
        }
        if (!outStream) {
            av_log(NULL,AV_LOG_ERROR,"cannot alloc output stream!");
            return -1;
        }
        if (avcodec_copy_context(outStream->codec,inStream->codec) < 0) {
            av_log(NULL,AV_LOG_ERROR,"cannot copy context from input to output stream codec context!");
            return -1;
        }
        if (outFormatContext->oformat->flags & AVFMT_GLOBALHEADER) {
            outStream->codec->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
        }
    }
    printf("\n==========Input Video==========\n");
    av_dump_format(inputFormatContext,0,inputFileName,false);
    printf("\n==========Output Video==========\n");
    av_dump_format(outVideoFormatContext,0,outVideoFileName,true);
    printf("\n==========Output Audio==========\n");
    av_dump_format(outAudioFormatContext,0,outAudioFileName,true);

    if (!(outVideoFormatContext->flags & AVFMT_NOFILE)) {
        if (avio_open(&outVideoFormatContext->pb,outVideoFileName,AVIO_FLAG_READ_WRITE) < 0) {
            av_log(NULL,AV_LOG_ERROR,"cannot open output video file!");
            return -1;
        }
    }
    if (!(outAudioFormatContext->flags & AVFMT_NOFILE)) {
        if (avio_open(&outAudioFormatContext->pb,outAudioFileName,AVIO_FLAG_READ_WRITE) < 0) {
            av_log(NULL,AV_LOG_ERROR,"cannot open output audio file!");
            return -1;
        }
    }
    if (avformat_write_header(outVideoFormatContext,NULL) < 0) {
            av_log(NULL,AV_LOG_ERROR,"cannot write output video file header!");
            return -1;
    }
    if (avformat_write_header(outAudioFormatContext,NULL) < 0) {
            av_log(NULL,AV_LOG_ERROR,"cannot write output audio file header!");
            return -1;
    }

    AVBitStreamFilterContext *h264bsfc = av_bitstream_filter_init("h264_mp4toannexb");
    int result;
    int frameIndex;
    AVPacket packet;
    while (1){
        AVFormatContext *formatContext;
        AVStream *inStream;
        AVStream *outStream;
        if (av_read_frame(inputFormatContext,&packet) < 0) {
            break;
        }
        inStream = inputFormatContext->streams[packet.stream_index];
        if (packet.stream_index == videoIndex) {
            outStream = outVideoFormatContext->streams[0];
            formatContext = outVideoFormatContext;
            av_bitstream_filter_filter(
                h264bsfc,
                inStream->codec,
                NULL,
                &packet.data,
                &packet.size,
                packet.data,
                packet.size,
                0
            );
        }else if (packet.stream_index == audioIndex) {
            outStream = outAudioFormatContext->streams[0];
            formatContext = outAudioFormatContext;
        }else{
            continue;
        }
        packet.pts = av_rescale_q_rnd(
            packet.pts,
            inStream->time_base,
            outStream->time_base,
            (AVRounding)(AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX)
        );
        packet.dts = av_rescale_q_rnd(
            packet.dts,
            inStream->time_base,
            outStream->time_base,
            (AVRounding)(AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX)
        );
        packet.duration = av_rescale_q(
            packet.duration,
            inStream->time_base,
            outStream->time_base
        );
        packet.pos = -1;
        packet.stream_index = 0;
        //这种方式从MP4文件中提取的AAC音频可以直接播放
        if (av_interleaved_write_frame(formatContext,&packet) < 0) {
            break;
        }
        av_free_packet(&packet);
        frameIndex ++;
    }
    av_bitstream_filter_close(h264bsfc);

    av_write_trailer(outVideoFormatContext);
    av_write_trailer(outAudioFormatContext);
    avformat_close_input(&inputFormatContext);
    if (outVideoFormatContext && !(outVideoFormat->flags & AVFMT_NOFILE)){
        avio_close(outVideoFormatContext->pb);
    }
    if (outAudioFormatContext && !(outAudioFormat->flags & AVFMT_NOFILE)){
        avio_close(outAudioFormatContext->pb);
    }
    avformat_free_context(outVideoFormatContext);
    avformat_free_context(outAudioFormatContext);
    
    return 0;
}