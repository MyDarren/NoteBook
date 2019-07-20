#include <libavformat/avformat.h>
#include <stdio.h>

//AAC是新一代的音频有损压缩技术，它通过一些附加的编码技术（比如PS,SBR等），
//衍生出了LC-AAC,HE-AAC,HE-AACv2三种主要的编码，
//LC-AAC就是比较传统的AAC，相对而言，主要用于中高码率(>=80Kbps)，
//HE-AAC(相当于AAC+SBR)主要用于中低码(<=80Kbps)，
//而新近推出的HE-AACv2(相当于AAC+SBR+PS)主要用于低码率(<=48Kbps）,
//事实上大部分编码器设成<=48Kbps自动启用PS技术，而>48Kbps就不加PS,就相当于普通的HE-AAC

//此代码只对HE-AAC有效，而对于 LC-AAC，需要手动修改一下
void adts_header(char *szAdtsHeader, int dataLen){

    int audio_object_type = 2;
    int sampling_frequency_index = 7;
    int channel_config = 2;
    int adtsLen = dataLen + 7;

    szAdtsHeader[0] = 0xff;                                  //syncword:0xfff                          高8bits
    szAdtsHeader[1] = 0xf0;                                  //syncword:0xfff                          低4bits
    szAdtsHeader[1] |= (0 << 3);                             //MPEG Version:0 for MPEG-4,1 for MPEG-2  1bit
    szAdtsHeader[1] |= (0 << 1);                             //Layer:0                                 2bits
    szAdtsHeader[1] |= 1;                                    //protection absent:1                     1bit

    szAdtsHeader[2] = (audio_object_type - 1)<<6;            //profile:audio_object_type - 1                      2bits
    szAdtsHeader[2] |= (sampling_frequency_index & 0x0f)<<2; //sampling frequency index:sampling_frequency_index  4bits
    szAdtsHeader[2] |= (0 << 1);                             //private bit:0                                      1bit
    szAdtsHeader[2] |= (channel_config & 0x04)>>2;           //channel configuration:channel_config               高1bit

    szAdtsHeader[3] = (channel_config & 0x03)<<6;            //channel configuration:channel_config      低2bits
    szAdtsHeader[3] |= (0 << 5);                             //original：0                               1bit
    szAdtsHeader[3] |= (0 << 4);                             //home：0                                   1bit
    szAdtsHeader[3] |= (0 << 3);                             //copyright id bit：0                       1bit
    szAdtsHeader[3] |= (0 << 2);                             //copyright id start：0                     1bit
    szAdtsHeader[3] |= ((adtsLen & 0x1800) >> 11);           //frame length：value   高2bits

    szAdtsHeader[4] = (uint8_t)((adtsLen & 0x7f8) >> 3);     //frame length:value    中间8bits
    szAdtsHeader[5] = (uint8_t)((adtsLen & 0x7) << 5);       //frame length:value    低3bits
    szAdtsHeader[5] |= 0x1f;                                 //buffer fullness:0x7ff 高5bits
    szAdtsHeader[6] = 0xfc;
}

int main (int argc, char *argv[]){

    if (argc < 3) {
        av_log(NULL,AV_LOG_ERROR,"params error\n");
        return -1;
    }

    char *inputFile = argv[1];
    char *outputFile = argv[2];
    if (!inputFile || !outputFile) {
        av_log(NULL,AV_LOG_ERROR,"inputFile or outputFile is null\n");
        return -1;
    }
    
    int result;
    int audioIndex;
    int length;
    AVFormatContext *context = NULL;
    AVPacket packet;
    
    av_register_all();
    result = avformat_open_input(&context,inputFile,NULL,NULL);
    if (result < 0) {
        av_log(NULL,AV_LOG_ERROR,"can't open file:%s\n",av_err2str(result));
        return -1;
    }

    FILE *file = fopen(outputFile,"wb");
    if (!file) {
        av_log(NULL,AV_LOG_ERROR,"can't open output file\n");
        avformat_close_input(&context);
        return -1;
    }
    
    audioIndex = av_find_best_stream(context,AVMEDIA_TYPE_AUDIO,-1,-1,NULL,0);
    if (audioIndex < 0) {
        av_log(NULL,AV_LOG_ERROR,"can't find audio stream\n");
        avformat_close_input(&context);
        fclose(file);
        return -1;
    }

    av_init_packet(&packet);
    while(av_read_frame(context,&packet) >= 0){
        if (packet.stream_index == audioIndex) {
            char adts_header_buf[7];
            adts_header(adts_header_buf,packet.size);
            fwrite(adts_header_buf,1,7,file);
            length = fwrite(packet.data,1,packet.size,file);
            if (length != packet.size) {
                av_log(NULL,AV_LOG_WARNING,"warning,length of data is not equal to size of packet");
            }
        }
        av_packet_unref(&packet);
    }
    
    avformat_close_input(&context);
    if (!file) {
        fclose(file);
    }

    return 0;
}