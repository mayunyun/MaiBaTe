//
//  UILabel+Extension.m
//  YQFDiscover
//
//  Created by 黄松凯 on 16/1/12.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+ (UILabel *)labelWithTitle:(NSString *)title TitleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont textAligment:(NSTextAlignment)textAligment bgColor:(UIColor *)bgColor rect:(CGRect)rect
{
    UILabel *label = [[UILabel alloc]init];
    [label setText:title];
    [label setTextColor:titleColor];
    [label setTextAlignment:textAligment];
    label.backgroundColor=bgColor;
    label.frame=rect;
    return label;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
