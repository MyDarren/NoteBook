#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <libavutil/channel_layout.h>
#include <libavutil/opt.h>
#include <libavutil/mathematics.h>
#include <libavutil/timestamp.h>
#include <libavformat/avformat.h>
#include <libswscale/swscale.h>
#include <libswresample/swresample.h>

int main (int argc, char *argv[]){
    av_register_all();
    const char *fileName = "video.mp4";
    AVFormatContext *formatContext;
    avformat_alloc_output_context2(&formatContext,NULL,"mp4",fileName);
    if (!formatContext){
        printf("cannot alloc mp4 format\n");
        return 1;
    }
    AVOutputFormat *outputFormat = formatContext->oformat;
    AVStream *stream = avformat_new_stream(formatContext,NULL);
    if (!stream){
        printf("cannot alloc stream\n");
        return 1;
    }
    stream->id = formatContext->nb_streams - 1;
    stream->time_base = (AVRational){1,25};
    
    AVCodec *codec = avcodec_find_encoder(outputFormat->video_codec);
    AVCodecContext *codecContext = avcodec_alloc_context3(codec);
    codecContext->codec_id = outputFormat->video_codec;
    codecContext->bit_rate = 400000;
    codecContext->width = 1920;
    codecContext->height = 1080;
    codecContext->time_base = stream->time_base;
    codecContext->gop_size = 12;
    codecContext->pix_fmt = AV_PIX_FMT_YUV420P;
    avcodec_parameters_from_context(stream->codecpar,codecContext);


    return 0;
}
