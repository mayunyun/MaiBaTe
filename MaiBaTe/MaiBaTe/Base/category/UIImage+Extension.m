//
//  UIImage+Extension.m
//  ysywb
//
//  Created by 黄松凯 on 15/6/15.
//  Copyright (c) 2015年 SK. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)


+(UIImage *)resizedImage:(NSString *)name
{
    UIImage *image=[UIImage imageNamed:name];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
    
}


+ (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}




//简单获取和修改frame属性
+ (UIImage *)imageNamed:(NSString *)name WithColor:(UIColor *)color
{
    UIImage * image = [UIImage imageNamed:name];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageNamed:(NSString *)name WithColor:(UIColor *)color andProgress:(CGFloat)progress{
    
    UIImage * image = [UIImage imageNamed:name];
    UIColor * originalColor = [UIColor colorWithPatternImage:image];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGRect coloRrect = CGRectMake(0, 0, image.size.width*progress, image.size.height);
    CGRect notColoRrect = CGRectMake(image.size.width*progress, 0, image.size.width-image.size.width*progress, image.size.height);
    CGContextFillRect(context, coloRrect);
    [originalColor setFill];
    CGContextFillRect(context, notColoRrect);
    
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com