//
//  UIImage+CustomImage.h
//  IdentityRecognition
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CustomImage)

+ (UIImage *)imageWithColor:(UIColor *)color;

/** 纠正图片的方向 */
- (UIImage *)fixOrientation;

/** 按给定的方向旋转图片 */
- (UIImage*)rotate:(UIImageOrientation)oriention;

/** 压缩图片至指定尺寸 */
- (UIImage *)rescaleImageToSize:(CGSize)size;

/** 压缩图片至指定像素 */
- (UIImage *)rescaleImageToPX:(CGFloat )toPX;

+ (NSData *)zipImageWithImage:(UIImage *)image maxKbytes:(CGFloat)maxKbytes;

@end
