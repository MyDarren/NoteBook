//
//  DataModel.m
//  多线程
//
//  Created by Darren on 16/3/7.
//  Copyright © 2016年 Darren. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    DataModel *model = [[DataModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end
