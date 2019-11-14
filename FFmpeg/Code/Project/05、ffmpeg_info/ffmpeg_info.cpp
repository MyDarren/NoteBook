#include <stdio.h>

#ifdef __cplusplus
extern "C" {
    #include <libavformat/avformat.h>
    #include <libavcodec/avcodec.h>
    #include <libavfilter/avfilter.h>
};
#endif

char *configurationInfo(){
    char *info = (char *)malloc(40000);
    memset(info,0,40000);
    sprintf(info,"%s\n",avcodec_configuration());

    return info;
}

struct URLProtocol;

/**
 * Protocol Support Information
*/
char *urlProtocolInfo(){
    char *info = (char *)malloc(40000);
    memset(info,0,40000);

    struct URLProtocol *pup = NULL;
    struct URLProtocol **p_temp = &pup;
    avio_enum_protocols((void **)p_temp,0);
    while ((*p_temp) != NULL){
        sprintf(info,"%s[In ] %15s\n",info,avio_enum_protocols((void **)p_temp,0));
    }
    pup = NULL;

    avio_enum_protocols((void **)p_temp,1);
    while ((*p_temp) != NULL){
        sprintf(info,"%s[Out] %15s\n",info,avio_enum_protocols((void **)p_temp,1));
    }

    return info;
}

/**
 * AVFormat Support Information
*/
char *avformatInfo(){
    char *info = (char *)malloc(40000);
    memset(info,0,40000);

    AVInputFormat *inputFormat = av_iformat_next(NULL);
    AVOutputFormat *outputFormat = av_oformat_next(NULL);
    while (inputFormat != NULL){
        sprintf(info,"%s[In ] %15s\n",info,inputFormat->name);
        inputFormat = inputFormat->next;
    }
    while (outputFormat != NULL){
        sprintf(info,"%s[Out] %15s\n",info,outputFormat->name);
        outputFormat = outputFormat->next;
    }
    return info;
}

char *avcodecInfo(){
    char *info = (char *)malloc(40000);
    memset(info,0,40000);
    
    AVCodec *codec = av_codec_next(NULL);
    while (codec != NULL){
        if (codec->decode != NULL) {
            sprintf(info,"%s[Decode]",info);
        }else{
            sprintf(info,"%s[Encode]",info);
        }
        switch (codec->type){
            case AVMEDIA_TYPE_VIDEO:
                sprintf(info,"%s[Video]",info);
                break;
            case AVMEDIA_TYPE_AUDIO:
                sprintf(info,"%s[Audio]",info);
                break;
            default:
                sprintf(info,"%s[Other]",info);
                break;
        }
        sprintf(info,"%s %10s\n",info,codec->name);
        codec = codec->next;
    }
    return info;
}

char *avfilterInfo(){
    char *info = (char *)malloc(40000);
    memset(info,0,40000);
    
    AVFilter *filter = (AVFilter *)avfilter_next(NULL);
    while (filter->next != NULL){
        sprintf(info,"%s[%15s]\n",info,filter->name);
        filter = filter->next;
    }
    return info;
}

int main (int argc,char *argv[]){
    char *infoStr = NULL;

    infoStr = configurationInfo();
    printf("\n<<Configuration>>\n%s",infoStr);
    free(infoStr);

    infoStr = urlProtocolInfo();
    printf("\n<<URLProtocol>>\n%s",infoStr);
    free(infoStr);

    infoStr = avformatInfo();
    printf("\n<<AVFormat>>\n%s",infoStr);
    free(infoStr);

    infoStr = avcodecInfo();
    printf("\n<<AVCodec>>\n%s",infoStr);
    free(infoStr);

    infoStr = avfilterInfo();
    printf("\n<<AVFilter>>\n%s",infoStr);
    free(infoStr);

    return 0;
}