//
//  NSMutableURLRequest+upload.h
//  网络请求相关
//
//  Created by  夏发启 on 16/4/21.
//  Copyright © 2016年  夏发启. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (upload)

+ (instancetype)requestWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval localFilePath:(NSString *)localFilePath fileName:(NSString *)fileName;

@end
