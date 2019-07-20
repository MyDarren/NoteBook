//
//  NSMutableURLRequest+upload.m
//  网络请求相关
//
//  Created by  夏发启 on 16/4/21.
//  Copyright © 2016年  夏发启. All rights reserved.
//

#import "NSMutableURLRequest+upload.h"

@implementation NSMutableURLRequest (upload)

static NSString *boundary = @"postUpload";

+ (instancetype)requestWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval localFilePath:(NSString *)localFilePath fileName:(NSString *)fileName{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
    request.HTTPMethod = @"POST";
    //拼接数据体
    NSMutableData *dataM = [NSMutableData data];
    //1. --(可以随便写, 但是不能有中文)\r\n
    NSString *str = [NSString stringWithFormat:@"--%@\r\n",boundary];
    [dataM appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //2. Content-Disposition: form-data; name="userfile(php脚本中用来读取文件的字段)"; filename="demo.json(要保存到服务器的文件名)"
    str = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",fileName];
    [dataM appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //3. Content-Type: application/octet-stream(上传文件的类型)\r\n\r\n
    str = @"Content-Type: application/octet-stream\r\n\r\n";
    [dataM appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //4. 要上传的文件的二进制流
    [dataM appendData:[NSData dataWithContentsOfFile:localFilePath]];
    //5. \r\n--(可以随便写, 但是不能有中文)--\r\n
    str = [NSString stringWithFormat:@"\r\n--%@--",boundary];
    [dataM appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //设置请求体
    request.HTTPBody = dataM;
    //设置请求头
    //Content-Length(文件的大小)	4049  //可以省略不写
    //Content-Type	multipart/form-data; boundary(分隔符)=(可以随便写, 但是不能有中文)
    NSString *headerStr = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:headerStr forHTTPHeaderField:@"Content-Type"];
    return request;
}

@end
