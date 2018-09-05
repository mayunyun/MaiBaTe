//
//  UIImage+Extension.h
//  ysywb
//
//  Created by 黄松凯 on 15/6/15.
//  Copyright (c) 2015年 SK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)


+(UIImage *)resizedImage:(NSString *)name;

//返回一张改颜色的图片
+ (UIImage *)imageNamed:(NSString *)name WithColor:(UIColor *)color;
+ (UIImage *)imageNamed:(NSString *)name WithColor:(UIColor *)color andProgress:(CGFloat)progress;

+ (UIImage *)imageWithColor:(UIColor *)color;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com