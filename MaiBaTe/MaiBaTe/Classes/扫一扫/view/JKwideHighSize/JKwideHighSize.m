//
//  JKwideHighSize.m
//  大小取值
//
//  Created by 王冲 on 2017/2/19.
//  Copyright © 2017年 希爱欧科技有限公司. All rights reserved.
//

#import "JKwideHighSize.h"

@implementation JKwideHighSize

//确定高度的设置
+(CGSize)string:(NSString *)string sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
    
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}

@end
