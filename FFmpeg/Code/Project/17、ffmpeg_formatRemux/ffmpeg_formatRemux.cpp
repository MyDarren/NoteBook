#include <stdio.h>

#ifdef __cplusplus
extern "C"{
    #include <libavformat/avformat.h>
    #include <libavcodec/avcodec.h>
};
#endif

int main (int argc,char *argv[]){
    const char *inputFileName = "cuc_ieschool.mp4";
    const char *outputFileName = "cuc_ieschool.flv";
    AVFormatContext *inputFormatContext;
    AVFormatContext *outputFormatContext;
    av_register_all();
    if (avformat_open_input(&inputFormatContext,inputFileName,NULL,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot open input file!");
        return -1;
    }
    if (avformat_find_stream_info(inputFormatContext,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot find input file stream info!");
        return -1;
    }
    av_dump_format(inputFormatContext,0,inputFileName,false);

    if (avformat_alloc_output_context2(&outputFormatContext,NULL,NULL,outputFileName) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot alloc output context!");
        return -1;
    }
    for (int i = 0; i < inputFormatContext->nb_streams; i++){
        AVStream *inStream = inputFormatContext->streams[i];
        AVStream *outStream = avformat_new_stream(outputFormatContext,inStream->codec->codec);
        if (!outStream) {
            av_log(NULL,AV_LOG_ERROR,"cannot alloc new stream!");
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

    if (!(outputFormatContext->oformat->flags & AVFMT_NOFILE)) {
        if (avio_open(&outputFormatContext->pb,outputFileName,AVIO_FLAG_WRITE) < 0) {
            av_log(NULL,AV_LOG_ERROR,"cannot open output file!");
            return -1;
        }
    }
    if (avformat_write_header(outputFormatContext,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot write header!");
        return -1;
    }
    int frameIndex = 0;
    AVPacket packet;
    while (1){
        if (av_read_frame(inputFormatContext,&packet) >= 0) {
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
            if (av_interleaved_write_frame(outputFormatContext,&packet) < 0) {
                av_log(NULL,AV_LOG_ERROR,"cannot write frame!");
                return -1;
            }
            printf("Write %8d frames to output file\n",frameIndex);
            frameIndex ++;
            av_free_packet(&packet);
        }else{
            break;
        }
    }
    av_write_trailer(outputFormatContext);
    avformat_close_input(&inputFormatContext);
    if (outputFormatContext && !(outputFormatContext->oformat->flags & AVFMT_NOFILE)) {
        avio_close(outputFormatContext->pb);
    }
    avformat_free_context(outputFormatContext);

    return 0;
}