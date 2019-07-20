//
//  SQLiteTool.h
//  数据库使用
//
//  Created by WaiLaiXing on 16/4/14.
//  Copyright © 2016年 WaiLaiXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteTool : NSObject

+ (void)exexuteSQLWithString:(NSString *)sql;
+ (NSArray *)seleteSQLWithString:(NSString *)sql;

@end
