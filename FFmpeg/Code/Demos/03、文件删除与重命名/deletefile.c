#include <libavformat/avformat.h>

int main (int argc, char *argv[]){
    int result = avpriv_io_delete("./testFile.txt");
    if (result < 0) {
        av_log(NULL,AV_LOG_ERROR,"delete file failed\n");
        return -1;
    }
    av_log(NULL,AV_LOG_INFO,"success to delete file\n");
    return 0;
}

//clang -g -o deletefile deletefile.c `pkg-config --libs libavformat`