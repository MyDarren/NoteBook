//
//  NSString+CustomString.m
//  CategorySet
//
//  Created by test on 2018/9/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NSString+CustomString.h"

@implementation NSString (CustomString)

+ (void)testString{
    NSLog(@"%s",__func__);
}

@end

@implementation NSString (ColorString)

+ (void)colorString{
    NSLog(@"%s",__func__);
}

@end

@implementation NSString (DeviceString)

+ (void)deviceString{
    NSLog(@"%s",__func__);
}

@end



