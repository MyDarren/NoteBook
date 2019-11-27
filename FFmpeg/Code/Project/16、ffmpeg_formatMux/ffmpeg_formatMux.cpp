#include <stdio.h>

#ifdef __cplusplus
extern "C" {
    #include <libavformat/avformat.h>
    #include <libavcodec/avcodec.h>
};
#endif

int main (int argc,char *argv[]){
    // const char *inputVideoFileName = "cuc_ieschool.ts";
    const char *inputVideoFileName = "cuc_ieschool.h264";
    // const char *inputAudioFileName = "cuc_ieschool.mp3";                //Header missing    
    const char *inputAudioFileName = "gowest.aac";                   //aacbsfc可用
    const char *outputFileName = "cuc_ieschool.mp4";
    AVFormatContext *inputVideoFormatContext;
    AVFormatContext *inputAudioFormatContext;
    AVFormatContext *outputFormatContext;
    AVOutputFormat *outputFormat;
    av_register_all();
    if (avformat_open_input(&inputVideoFormatContext,inputVideoFileName,NULL,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot open input video file!");
        return -1;
    }
    if (avformat_find_stream_info(inputVideoFormatContext,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot find input file video stream info!");
        return -1;
    }
    if (avformat_open_input(&inputAudioFormatContext,inputAudioFileName,NULL,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot open input audio file!");
        return -1;
    }
    if (avformat_find_stream_info(inputAudioFormatContext,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot find input file audio stream info!");
        return -1;
    }

    printf("==========Input Information==========\n");
    av_dump_format(inputVideoFormatContext,0,inputVideoFileName,false);
    av_dump_format(inputAudioFormatContext,0,inputAudioFileName,false);
    printf("=====================================\n");

    if (avformat_alloc_output_context2(&outputFormatContext,NULL,NULL,outputFileName) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot alloc output format context!");
        return -1;
    }
    outputFormat = outputFormatContext->oformat;

    int inputVideoIndex = -1;
    int inputAudioIndex = -1;
    int outputVideoIndex = -1;
    int outputAudioIndex = -1;
    for (int i = 0; i < inputVideoFormatContext->nb_streams; i++){
        AVStream *inputVideoStream = inputVideoFormatContext->streams[i];
        if (inputVideoStream->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
            AVStream *outputVideoStream = avformat_new_stream(outputFormatContext,inputVideoStream->codec->codec);
            if (!outputVideoStream) {
                av_log(NULL,AV_LOG_ERROR,"cannot alloc output video stream!");
                return -1;
            }
            inputVideoIndex = i;
            outputVideoIndex = outputVideoStream->index;
            if (avcodec_copy_context(outputVideoStream->codec,inputVideoStream->codec) < 0){
                av_log(NULL,AV_LOG_ERROR,"cannot copy context from input to output stream codec context!");
                return -1;
            }
            outputVideoStream->codec->codec_tag = 0;
            if (outputFormat->flags & AVFMT_GLOBALHEADER){
                outputVideoStream->codec->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
            }
            break;
        }
    }
    for (int i = 0; i < inputAudioFormatContext->nb_streams; i++){
        AVStream *inputAudioStream = inputAudioFormatContext->streams[i];
        if (inputAudioStream->codec->codec_type == AVMEDIA_TYPE_AUDIO) {
            AVStream *outputAudioStream = avformat_new_stream(outputFormatContext,inputAudioStream->codec->codec);
            if (!outputAudioStream){
                av_log(NULL,AV_LOG_ERROR,"cannot alloc output audio stream!");
                return -1;
            }
            inputAudioIndex = i;
            outputAudioIndex = outputAudioStream->index;
            if (avcodec_copy_context(outputAudioStream->codec,inputAudioStream->codec) < 0) {
                av_log(NULL,AV_LOG_ERROR,"cannot copy context from input to output stream codec context!");
                return -1;
            }
            outputAudioStream->codec->codec_tag = 0;
            if (outputFormat->flags & AVFMT_GLOBALHEADER) {
                outputAudioStream->codec->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
            }
            break;
        }
    }
    printf("==========Output Information==========\n");
    av_dump_format(outputFormatContext,0,outputFileName,true);
    printf("=====================================\n");
    
    if (!(outputFormat->flags & AVFMT_NOFILE)) {
        if (avio_open(&outputFormatContext->pb,outputFileName,AVIO_FLAG_WRITE) < 0){
            av_log(NULL,AV_LOG_ERROR,"cannot open output file!");
            return -1;
        }
    }

    if (avformat_write_header(outputFormatContext,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot write header to output file!");
        return -1;
    }

    AVBitStreamFilterContext *h264bsfc = av_bitstream_filter_init("h264_mp4toannexb");
    AVBitStreamFilterContext *aacbsfc = NULL;
    AVCodecID codecID = inputAudioFormatContext->streams[inputAudioIndex]->codec->codec_id;
    if (codecID == AV_CODEC_ID_AAC) {
        aacbsfc = av_bitstream_filter_init("aac_adtstoasc");
    }
    
    int currentVideoPts = 0;
    int currentAudioPts = 0;
    int frameIndex = 0;
    AVPacket packet;
    while (1){
        AVFormatContext *formatContext;
        AVStream *inStream;
        AVStream *outStream;
        int streamIndex = 0;
        if (av_compare_ts(
            currentVideoPts,
            inputVideoFormatContext->streams[inputVideoIndex]->time_base,
            currentAudioPts,
            inputAudioFormatContext->streams[inputAudioIndex]->time_base) <= 0) {
            formatContext = inputVideoFormatContext;
            streamIndex = outputVideoIndex;
            if (av_read_frame(formatContext,&packet) >= 0) {
                do{
                    inStream = formatContext->streams[packet.stream_index];
                    outStream = outputFormatContext->streams[streamIndex];
                    if (packet.stream_index == inputVideoIndex) {
                        //H264裸流没有PTS，因此需要手动写入
                        if (packet.pts == AV_NOPTS_VALUE) {
                            AVRational timeBase = inStream->time_base;
                            int64_t calcDuration = (double)AV_TIME_BASE / av_q2d(inStream->r_frame_rate);
                            packet.pts = (double)(frameIndex * calcDuration) / (double)(av_q2d(timeBase) * AV_TIME_BASE);
                            packet.dts = packet.pts;
                            packet.duration = (double)calcDuration / (double)(av_q2d(timeBase) * AV_TIME_BASE);
                            frameIndex ++;
                        }
                        currentVideoPts = packet.pts;
                        break;
                    }
                } while (av_read_frame(formatContext,&packet) >= 0);
            }else{
                break;
            }
        }else{
            formatContext = inputAudioFormatContext;
            streamIndex = outputAudioIndex;
            if (av_read_frame(formatContext,&packet) >= 0) {
                do{
                    inStream = formatContext->streams[packet.stream_index];
                    outStream = outputFormatContext->streams[streamIndex];
                    if (packet.stream_index == inputAudioIndex) {
                        if (packet.pts == AV_NOPTS_VALUE) {
                            AVRational timeBase = inStream->time_base;
                            int64_t calcDuration = (double)AV_TIME_BASE / av_q2d(inStream->r_frame_rate);
                            packet.pts = (double)(frameIndex * calcDuration) / (double)(av_q2d(timeBase) * AV_TIME_BASE);
                            packet.dts = packet.pts;
                            packet.duration = (double)calcDuration / (double)(av_q2d(timeBase) * AV_TIME_BASE);
                            frameIndex ++;
                        }
                        currentAudioPts = packet.pts;
                        break;
                    }
                } while (av_read_frame(formatContext,&packet) >= 0);
            }else{
                break;
            }
        }
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
        if (aacbsfc) {
            av_bitstream_filter_filter(
                aacbsfc,
                outStream->codec,
                NULL,
                &packet.data,
                &packet.size,
                packet.data,
                packet.size,
                0
            );
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
        packet.stream_index = streamIndex;

        printf("Write packet:size:%5d\tpts:%lld\n",packet.size,packet.pts);
        if (av_interleaved_write_frame(outputFormatContext,&packet) < 0) {
            printf("cannot muxing packet\n");
            break;
        }
        av_free_packet(&packet);
    }
    //对于某些没有文件头的封装格式，不需要此函数，比如说MPEG2TS
    av_write_trailer(outputFormatContext);
    av_bitstream_filter_close(h264bsfc);
    if (aacbsfc) {
        av_bitstream_filter_close(aacbsfc);
    }
    avformat_close_input(&inputVideoFormatContext);
    avformat_close_input(&inputAudioFormatContext);
    if (outputFormatContext && !(outputFormat->flags & AVFMT_NOFILE)){
        avio_close(outputFormatContext->pb);
    }
    avformat_free_context(outputFormatContext);

    return 0;
}