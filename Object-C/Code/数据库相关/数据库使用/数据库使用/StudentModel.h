//
//  StudentModel.h
//  数据库使用
//
//  Created by WaiLaiXing on 16/4/14.
//  Copyright © 2016年 WaiLaiXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentModel : NSObject

@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)NSInteger age;
+ (instancetype)studentModelWith:(NSString *)name age:(NSInteger)age;

@end
