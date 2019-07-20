#include <libavformat/avformat.h>

int main (int argc, char *argv[]){
    if (argc < 2) {
        av_log(NULL,AV_LOG_ERROR,"params error\n");
        return -1;
    }
    
    AVFormatContext *context = NULL;
    char *file = argv[1];
    int result;
    av_register_all();
    result = avformat_open_input(&context,file,NULL,NULL);
    if (result < 0) {
        av_log(NULL,AV_LOG_ERROR,"fail to open %s\n",file);
        return -1;
    }

    av_dump_format(context,0,file,0);
    avformat_close_input(&context);
    return 0;
}

//clang -g -o mediaInfo mediaInfo.c `pkg-config --libs libavformat`
//./mediaInfo ../../Resource/video.mp4