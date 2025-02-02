//
//  UIButton+Extension.m
//  YQFDiscover
//
//  Created by 黄松凯 on 16/1/12.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)
//创建一个按钮,传入按钮的标题，标题颜色，字体，对齐方式，位置，背景颜色，位置，点击状态
+ (UIButton *)buttonWithTitle:(NSString *)title TitleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont image:(UIImage *)image backgroundImage:(UIImage *)backImage bgColor:(UIColor *)bgColor rect:(CGRect)rect state:(UIControlState)state target:(id)target action:(SEL)action
{
    UIButton *btn = [[UIButton alloc]init];
    btn.frame=rect;
    [btn setTitle:title forState:state];
    [btn setImage:image forState:state];
    [btn setBackgroundImage:backImage forState:state];
    [btn setTitleColor:titleColor forState:state];
    [btn.titleLabel setFont:titleFont];
    btn.backgroundColor = bgColor;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(dispatch_source_t )startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle finished:(void(^)(UIButton *button))finished
{
    __block NSInteger timeOut = timeout; //The countdown time
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //To perform a second
    dispatch_source_set_event_handler(_timer, ^{
        if(timeOut<=0){ //it is time to
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //it is time to  set title
                [self setTitle:tittle forState:UIControlStateNormal];
                [self setBackgroundColor:UIColorFromRGB(0xFFB500)];
                self.userInteractionEnabled = YES;
                finished(self);
            });
        }else{
            
            NSString *strTime = [NSString stringWithFormat:@"%ld", timeOut];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self setTitle:[NSString stringWithFormat:@"%@%@",strTime,waitTittle] forState:UIControlStateNormal];
                [self setBackgroundColor:[UIColor grayColor]];
                self.userInteractionEnabled = NO;
                
            });
            timeOut--;
            
        }
    });
    dispatch_resume(_timer);
    return _timer;
}
-(void)cancelTimer:(dispatch_source_t)timer
{
    if (!timer) return;
    dispatch_source_cancel(timer);
}-(UIImageView *)addImg:(UIImage *)img withIMGframe:(CGRect )IMGframe
{
    UIImageView *img_VC = [[UIImageView alloc]initWithFrame:IMGframe];
    img_VC.image = img;
    img_VC.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:img_VC];
    
    return img_VC;
}
-(void)setFrame:(CGRect)frame Title:(NSString *)title font:(UIFont *)font fontColor:(UIColor *)fontColor State:(UIControlState)state
{
    self.frame = frame;
    [self setTitle:title forState:state];
    [self setTitleColor:fontColor forState:state];
    [self.titleLabel setFont:font];
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
