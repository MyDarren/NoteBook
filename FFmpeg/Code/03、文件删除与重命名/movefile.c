#include <libavformat/avformat.h>

int main (int argc, char *argv[]){
    int result = avpriv_io_move("./testFile.txt","./renamedfile.txt");
    if (result < 0) {
        av_log(NULL,AV_LOG_ERROR,"rename file failed\n");
        return -1;
    }
    av_log(NULL,AV_LOG_INFO,"success to rename file\n");
    return 0;
}

//clang -g -o movefile movefile.c `pkg-config --libs libavformat`