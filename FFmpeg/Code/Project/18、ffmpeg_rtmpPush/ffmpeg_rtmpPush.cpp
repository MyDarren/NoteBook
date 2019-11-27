#include <stdio.h>

#ifdef __cplusplus
extern "C" {
    #include <libavformat/avformat.h>
    #include <libavcodec/avcodec.h>
    #include <libavutil/mathematics.h>
    #include <libavutil/time.h>
}
#endif

int main (int argc,char *argv[]) {
    const char *inputFileName = "cuc_ieschool.mp4";
    const char *outputFileName = "rtmp://localhost:1935/rtmplive/room";
    av_register_all();
    avformat_network_init();
    AVFormatContext *inputFormatContext;
    AVFormatContext *outputFormatContext;
    AVOutputFormat *outputFormat;
    if (avformat_open_input(&inputFormatContext,inputFileName,NULL,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot open input file!");
        return -1;
    }
    if (avformat_find_stream_info(inputFormatContext,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot find input file stream info!");
        return -1;
    }
    int inputVideoIndex = -1;
    for (int i = 0; i < inputFormatContext->nb_streams; i++){
        AVStream *stream = inputFormatContext->streams[i];
        if (stream->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
            inputVideoIndex = i;
            break;
        }
    }
    av_dump_format(inputFormatContext,0,inputFileName,false);

    //flv--->RTMP   mpegs--->UDP
    if (avformat_alloc_output_context2(&outputFormatContext,NULL,"flv",outputFileName) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot alloc output format context!");
        return -1;
    }
    outputFormat = outputFormatContext->oformat;

    for (int i = 0; i < inputFormatContext->nb_streams; i++){
        AVStream *inStream = inputFormatContext->streams[i];
        AVStream *outStream = avformat_new_stream(outputFormatContext,inStream->codec->codec);
        if (!outStream) {
            av_log(NULL,AV_LOG_ERROR,"cannot alloc output stream!");
            return -1;
        }
        if (avcodec_copy_context(outStream->codec,inStream->codec) < 0) {
            av_log(NULL,AV_LOG_ERROR,"cannot copy context from input to output stream codec context!");
            return -1;
        }
        outStream->codec->codec_tag = 0;
        if (outputFormatContext->oformat->flags & AVFMT_GLOBALHEADER) {
            outStream->codec->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
        }
    }
    av_dump_format(outputFormatContext,0,outputFileName,true);

    if (!(outputFormat->flags & AVFMT_NOFILE)) {
        if (avio_open(&outputFormatContext->pb,outputFileName,AVIO_FLAG_WRITE) < 0) {
            av_log(NULL,AV_LOG_ERROR,"cannot open output file!");
            return -1;
        }
    }
    avformat_write_header(outputFormatContext,NULL);

    int64_t startime = av_gettime();
    int frameIndex = 0;
    AVPacket packet;
    while (1){
        if (av_read_frame(inputFormatContext,&packet) < 0) break;
        if (packet.pts == AV_NOPTS_VALUE) {
            AVRational timeBase = inputFormatContext->streams[inputVideoIndex]->time_base;
            int64_t calcDuration = (double)AV_TIME_BASE / av_q2d(inputFormatContext->streams[inputVideoIndex]->r_frame_rate);
            packet.pts = (double)(frameIndex * calcDuration) / (double)(av_q2d(timeBase) * AV_TIME_BASE);
            packet.dts = packet.pts;
            packet.duration = (double)calcDuration / (double)(av_q2d(timeBase) * AV_TIME_BASE);
        }
        if (packet.stream_index == inputVideoIndex) {
            AVRational timeBase = inputFormatContext->streams[inputVideoIndex]->time_base;
            AVRational timeBaseQ = {1,AV_TIME_BASE};
            int64_t ptsTime = av_rescale_q(packet.dts,timeBase,timeBaseQ);
            int64_t nowTime = av_gettime() - startime;
            if (ptsTime > nowTime) {
                av_usleep(ptsTime - nowTime);
            }
        }
        AVStream *inStream = inputFormatContext->streams[packet.stream_index];
        AVStream *outStream = outputFormatContext->streams[packet.stream_index];
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
        if (packet.stream_index == inputVideoIndex) {
            printf("Send %8d video frames to output URL\n",frameIndex);
            frameIndex ++;
        }
        if (av_interleaved_write_frame(outputFormatContext,&packet) < 0) {
            av_log(NULL,AV_LOG_ERROR,"cannot write frame!");
            break;
        }
        av_free_packet(&packet);
    }
    av_write_trailer(outputFormatContext);
    avformat_close_input(&inputFormatContext);
    if (outputFormatContext && !(outputFormatContext->oformat->flags & AVFMT_NOFILE)) {
        avio_close(outputFormatContext->pb);
    }
    avformat_free_context(outputFormatContext);
    return 0;
}