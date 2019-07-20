//
//  SQLiteTool.m
//  数据库使用
//
//  Created by WaiLaiXing on 16/4/14.
//  Copyright © 2016年 WaiLaiXing. All rights reserved.
//

#import "SQLiteTool.h"
#import <sqlite3.h>
#import "StudentModel.h"

@implementation SQLiteTool
static sqlite3 *_db;


//初始化数据库
+ (void)initialize{
    //获取cache文件夹路径
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"student.sqlite"];
    // 打开数据库，就会创建数据库文件
    // fileName保存数据库的全路径文件名
    // ppDb:数据库实例
    //将根据文件路径打开数据库，如果不存在，则会创建一个新的数据库。如果结果等于常量SQLITE_OK，则表示成功打开数据库
    if (sqlite3_open(filePath.UTF8String, &_db) == SQLITE_OK) {
        NSLog(@"打开数据库成功");
    }else
        NSLog(@"打开数据库失败");
}

+ (void)exexuteSQLWithString:(NSString *)sql{
    // 第一个参数：数据库实例
    // 第二个参数：执行的数据库语句
    // char **errmsg :提示错误
    char *errmsg;
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"操作失败－－%s",errmsg);
    }else
        NSLog(@"操作成功");
}

+ (NSArray *)seleteSQLWithString:(NSString *)sql{
    NSMutableArray *array = [NSMutableArray array];
    //数据库语句的字节数，－1表示自动计算字节数
    //ppStmt句柄，用来操作查询的数据
    sqlite3_stmt *ppStmt;
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &ppStmt, NULL) == SQLITE_OK) {
        //准备好
        while (sqlite3_step(ppStmt) == SQLITE_ROW) {
            NSString *name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(ppStmt, 1)];
            NSInteger age = sqlite3_column_int(ppStmt, 2);
            StudentModel *student = [StudentModel studentModelWith:name age:age];
            [array addObject:student];
        }
    }
    return array;
}

@end
