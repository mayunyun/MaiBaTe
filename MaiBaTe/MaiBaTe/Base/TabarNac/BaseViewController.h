//
//  BaseViewController.h
//  MaiBaTe
//
//  Created by apple on 17/8/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BaseViewController : UIViewController




//返回上级VC
- (void)backToLastViewController:(UIButton *)button;



- (void)rightBarTitleButtonTarget:(id)target action:(SEL)action text:(NSString*)str;

- (void)backBarTitleButtonItemTarget:(id)target action:(SEL)action text:(NSString*)str;

#pragma mark - 根据字符串计算label高度
- (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font;
@end
