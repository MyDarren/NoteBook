#include <libavutil/log.h>

int main (int argc, char *argv[]){
    av_log_set_level(AV_LOG_DEBUG);
    av_log(NULL,AV_LOG_INFO,"hello world\n");
    return 0;
}

//clang -g -o ffmpegLog ffmpegLog.c `pkg-config --libs libavutil`
//clang -g -o ffmpegLog ffmpegLog.c -lavutil