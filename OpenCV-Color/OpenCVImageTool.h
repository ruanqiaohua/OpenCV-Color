//
//  OpenCVImageTool.h
//  baibao
//
//  Created by 阮巧华 on 2019/11/16.
//  Copyright © 2019 阮巧华. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVImageTool : NSObject

/// 获取文本图片拍照偏移角度
+ (CGFloat)getTextPhotoAngle:(UIImage *)image;
/// 获取旋转后图片
+ (UIImage *)getRotateImage:(UIImage *)image degree:(CGFloat)degree;
/// 获取二值化图片
+ (UIImage *)getBinImage:(UIImage *)originImage;
/// 去红后的照片
+ (UIImage *)repayRedImage:(UIImage *)image;
/// 去蓝后的照片
+ (UIImage *)repayBuleImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
