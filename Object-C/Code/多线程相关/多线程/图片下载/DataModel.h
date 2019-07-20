//
//  DataModel.h
//  多线程
//
//  Created by Darren on 16/3/7.
//  Copyright © 2016年 Darren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *icon;
@property (nonatomic,copy)NSString *download;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
