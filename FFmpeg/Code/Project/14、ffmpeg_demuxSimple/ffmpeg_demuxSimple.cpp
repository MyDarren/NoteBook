#include <stdio.h>

#ifdef __cplusplus
extern "C"{
    #include <libavformat/avformat.h>
    #include <libavcodec/avcodec.h>
};
#endif

/**
 * 1、使用FFmpeg解复用音频流时，如果是MP3码流，直接存储AVPacket即可
 *    如果是AAC码流，直接存储AVPacket后的文件可能是不能播放的
 *    如果封装格式是TS(MPEG2 Transport Stream)，直接存储后的文件是可以直接播放的
 *    如果是FLV、MP4、MKV等格式则不行，因为FLV、MP4这些属于特殊容器，经过仔细对比后发现，
 *      调用av_read_frame()后得到的AVPacket的data里面的内容是AAC纯数据，即不包含ADTS文件头的AAC数据，
 *      如果想要得到可以播放的AAC文件，需要在每个AVPacket前面加上7个字节ADTS文件头
 * 2、使用FFmpeg分离H264码流时，直接存储AVPacket后的文件可能不能播放
 *    如果封装格式是TS(MPEG2 Transport Stream)，直接存储后的文件是可以直接播放的
 *    如果是FLV、MP4、MKV等格式则不行，需要首先写入SPS和PPS，否则会导致分离出来的数据没有SPS、PPS而无法播放
 *        
 *    H264码流的SPS和PPS信息存储在AVCodecContext结构体的extradata中，需要使用"h264_mp4toannexb"的bitstream filter处理
 *    方式一：使用bitstream filter处理每个AVPacket
 *          把每个AVPacket中的数据(data字段)经过bitstream filter过滤一遍，关键函数av_bitstream_filter_filter()
 *          AVBitStreamFilterContext *h264bsfc = av_bitstream_filter_init("h264_mp4toannexb");
 *          while(av_read_frame(formatContext,&packet) >= 0) {
 *              if (packet.stream_index == videoIndex) {
 *                  av_bitstream_filter_filter(
 *                      h264bsfc,
 *                      videoCodecContext,
 *                      NULL,
 *                      &packet.data
 *                      &packet.size,
 *                      packet.data,
 *                      packet.size,
 *                      0
 *                  );
 *                  fwrite(packet.data,1,packet.size,videoFile);
 *              }
 *              av_free_packet(&packet);
 *          }
 *          av_bitstream_filter_close(h264bsfc);
 *          上述代码中，把av_bitstream_filter_filter()的输入数据和输出数据(分别对应第4、5、6、7个参数)都设置成AVPacket的data字段
 *          需要注意的是bitstream filter需要初始化和销毁，分别通过函数av_bitstream_filter_init()和av_bitstream_filter_close()
 *          经过上述代码处理后，AVPacket中的数据有如下变化：
 *          1、每个AVPacket的data添加了H264的NALU的起始码{0,0,0,1}
 *          2、每个IDR帧数据前面添加了SPS和PPS
 *      方式二：手动添加SPS、PPS
 *          将AVCodecContext的extradata数据经过bitstream filter处理之后得到SPS、PPS，拷贝至每个IDR帧之前，下面代码示例写入SPS、PPS过程
 *          FILE *file = fopen("test.h264","ab");
 *          AVCodecContext *videoCodecContext = ...;
 *          unsigned char *dummy = NULL;
 *          int dummy_len;
 *          AVBitStreamFilterContext *bsfc = av_bitstream_filter_init("h264_mp4toannexb");
 *          av_bitstream_filter_filter(bsfc,videoCodecContext,NULL,&dummy,&dummy_len,NULL,0,0);
 *          fwrite(videoCodecContext->extradata,videoCodecContext->extradata_size,1,file);
 *          av_bitstream_filter_close(bsfc);
 *          free(dummy);
 *          然后修改AVPacket的data，把前4个字节改为起始码，示例代码如下：
 *          char nal_start[] = {0,0,0,1};
 *          memcpy(packet->data,nal_start,4);
 *          经过上述两步也可以得到可以播放的H264码流，相对第一种方法来说复杂一些
 *    当封装格式为MPEG2TS的时候，不存在上述问题           
*/

//手动添加暂时有点问题，后面研究再修复
#define USE_H264BSFCAUTO 1

int main (int argc,char *argv[]){
    const char *inputFileName = "cuc_ieschool.flv";
    const char *outVideoFileName = "cuc_ieschool.h264";
    const char *outAudioFileName = "cuc_ieschool.mp3";
    av_register_all();
    AVFormatContext *formatContext = avformat_alloc_context();
    if (avformat_open_input(&formatContext,inputFileName,NULL,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot open input file!");
        return -1;
    }
    if (avformat_find_stream_info(formatContext,NULL) < 0) {
        av_log(NULL,AV_LOG_ERROR,"cannot find input file stream info!");
        return -1;
    }
    int videoIndex = -1;
    int audioIndex = -1;
    for (int i = 0; i < formatContext->nb_streams; i++){
        AVStream *stream = formatContext->streams[i];
        if (stream->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
            videoIndex = i;
        }
        if (stream->codec->codec_type == AVMEDIA_TYPE_AUDIO) {
            audioIndex = i;
        }
    }
    if (videoIndex == -1) {
        av_log(NULL,AV_LOG_ERROR,"cannot find video stream!");
        return -1;
    }
    if (audioIndex == -1) {
        av_log(NULL,AV_LOG_ERROR,"cannot find audio stream!");
        return -1;
    }
    AVCodecContext *outVideoContext = formatContext->streams[videoIndex]->codec;
    AVCodecContext *outAudioContext = formatContext->streams[audioIndex]->codec;

    //再avcodec_open2之前添加下面一行代码，FFmpeg会在调用avcodec_open2时，在写header时填充SPS、PPS等信息
    //outVideoContext->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;

    FILE *outVideoFile = fopen(outVideoFileName,"wb");
    FILE *outAudioFile = fopen(outAudioFileName,"wb");
    AVPacket *packet = (AVPacket *)av_malloc(sizeof(AVPacket));

    AVBitStreamFilterContext *h264bsfc = av_bitstream_filter_init("h264_mp4toannexb");
#if !USE_H264BSFCAUTO
    unsigned char *dummy = NULL;
    int dummy_len;
    char nal_start[] = {0,0,0,1};
    av_bitstream_filter_filter(
        h264bsfc,
        outVideoContext,
        NULL,
        &dummy,
        &dummy_len,
        NULL,
        0,
        0
    );
    // fwrite(outVideoContext->extradata,outVideoContext->extradata_size,1,outVideoFile);
    // av_bitstream_filter_close(h264bsfc); 
    // free(dummy);
#endif

    while (av_read_frame(formatContext,packet) >= 0){
        if (packet->stream_index == videoIndex) {

#if !USE_H264BSFCAUTO

            if (packet->flags & AV_PKT_FLAG_KEY) {
                fwrite(outVideoContext->extradata,outVideoContext->extradata_size,1,outVideoFile);
            }
            memcpy(packet->data,nal_start,4);
            fwrite(packet->data,1,packet->size,outVideoFile);
#else
            av_bitstream_filter_filter(
                h264bsfc,
                outVideoContext,
                NULL,
                &packet->data,
                &packet->size,
                packet->data,
                packet->size,
                0
            );
            fwrite(packet->data,1,packet->size,outVideoFile);
#endif
            printf("Write Video Packet. Size:%d\tpts:%lld\n",packet->size,packet->pts);
        }
        if (packet->stream_index == audioIndex) {
            printf("Write Audio Packet. Size:%d\tpts:%lld\n",packet->size,packet->pts);
            fwrite(packet->data,1,packet->size,outAudioFile);
        }
    }
    av_bitstream_filter_close(h264bsfc);   
    fclose(outVideoFile);
    fclose(outAudioFile);
    av_packet_free(&packet);
    avformat_close_input(&formatContext);
    avformat_free_context(formatContext);
    return 0;
}