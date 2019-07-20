//
//  StudentModel.m
//  数据库使用
//
//  Created by WaiLaiXing on 16/4/14.
//  Copyright © 2016年 WaiLaiXing. All rights reserved.
//

#import "StudentModel.h"

@implementation StudentModel

+ (instancetype)studentModelWith:(NSString *)name age:(NSInteger)age{
    StudentModel *student = [[StudentModel alloc] init];
    student.name = name;
    student.age = age;
    return student;
}

@end
