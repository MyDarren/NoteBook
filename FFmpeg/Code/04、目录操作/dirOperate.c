#include <libavformat/avformat.h>

int main (int argc, char *argv[]){
    AVIODirContext *context = NULL;
    AVIODirEntry *entry = NULL;
    int result;
    result = avio_open_dir(&context,"./",NULL);
    if (result < 0) {
        av_log(NULL,AV_LOG_ERROR,"fail to open dir\n");
        return -1;
    }
    while(1){
        result = avio_read_dir(context,&entry);
        if (result >= 0) {
            av_log(NULL,AV_LOG_ERROR,"fail to read dir\n");
            goto __fail;
        }
        if (!entry) {
            break;
        }
        
        av_log(NULL,AV_LOG_INFO,"size:%lld--name:%s--type:%d\n",entry->size,entry->name,entry->type);
        avio_free_directory_entry(&entry);
    }
    
    __fail:
    avio_close_dir(&context);
    return 0;
}