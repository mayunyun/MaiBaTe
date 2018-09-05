//
//  MBTTabar.m
//  MaiBaTe
//
//  Created by LONG on 17/8/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MBTTabar.h"

#define LBMagin 12
@interface MBTTabar (){
    int type;
    UILabel *_label;
}

/** plus按钮 */
@property (nonatomic, weak) UIButton *plusBtn ;
@property (nonatomic, strong) LLGifView *gifView;

@end

@implementation MBTTabar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        //去掉tabBar顶部线条
//        [self setValue:@(YES) forKeyPath:@"_hidesShadow"];
//        if (statusbarHeight>20) {
            [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.7]]];
            self.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.6];
//        }else{
//            [self setBackgroundImage:[UIImage imageNamed:@"白Bar"]];
//            [self setShadowImage:[UIImage imageNamed:@"iconfont-touming"]];
//        }
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateHighlighted];
        
        self.plusBtn = plusBtn;
        
        
        [plusBtn addTarget:self action:@selector(plusBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:plusBtn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"chongdianzhuangtai" object:nil];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    //系统自带的按钮类型是UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
    self.plusBtn.size = CGSizeMake(self.plusBtn.currentBackgroundImage.size.width, self.plusBtn.currentBackgroundImage.size.height);
    self.plusBtn.centerX = UIScreenW/2;
    //调整发布按钮的中线点Y值
    self.plusBtn.centerY = self.height * 0.6 - 2*LBMagin ;
    if (statusbarHeight>20) {
        self.plusBtn.centerY = self.height * 0.6 - 4*LBMagin ;
    }
    [self saoyisao];
    
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.text = @"扫描充电";
        _label.font = [UIFont systemFontOfSize:11];
        [_label sizeToFit];
        _label.textColor = UIColorFromRGB(0x333333);
        [self addSubview:_label];
        _label.centerX = self.plusBtn.centerX;
        _label.centerY = CGRectGetMaxY(self.plusBtn.frame) + LBMagin ;
    }
    
    int btnIndex = 0;
    for (UIView *btn in self.subviews) {//遍历tabbar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            //每一个按钮的宽度==tabbar的五分之一
            btn.width = self.width / 5;
            
            btn.x = btn.width * btnIndex;
            
            btnIndex++;
            //如果是索引是2(从0开始的)，直接让索引++，目的就是让发现按钮的位置向右移动，空出来扫描按钮的位置
            if (btnIndex == 2) {
                btnIndex++;
            }
            
        }
    }
    
    [self bringSubviewToFront:self.plusBtn];
    
}
- (void)saoyisao{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"扫描" ofType:@"gif"];
    if (type == 2) {
        filePath = [[NSBundle mainBundle] pathForResource:@"充电中" ofType:@"gif"];
        _label.text = @"充电中";
    }else{
        filePath = [[NSBundle mainBundle] pathForResource:@"扫描" ofType:@"gif"];
        _label.text = @"扫描充电";
    }
    
    //适用于帧数少的gif动画
    _gifView = [[LLGifView alloc] initWithFrame:CGRectMake(0, 0, _plusBtn.width, _plusBtn.height) filePath:filePath];
    [_plusBtn addSubview:_gifView];
    [_gifView startGif];
}
- (void)InfoNotificationAction:(NSNotification *)notification{
    
    
    NSString *str = notification.userInfo[@"chongdian"];
    if ([str isEqualToString:@"(null)"]) {
        type = 0;
        [self saoyisao];
        return;
    }else if ([str rangeOfString:@"false"].location!=NSNotFound){//"false"
        type = 1;
        [self saoyisao];
        return;
    }else if ([str rangeOfString:@"true"].location!=NSNotFound){//"true"
        type = 2;
        [self saoyisao];
        return;
    }else{
        type = 0;
        [self saoyisao];
    }
    NSLog(@"---接收到通知---");
    
}
//点击了发布按钮
- (void)plusBtnDidClick
{
    //如果tabbar的代理实现了对应的代理方法，那么就调用代理的该方法
    if ([self.delegate respondsToSelector:@selector(tabBarPlusBtnClick:)]) {
        [self.myDelegate tabBarPlusBtnClick:self];
    }
    
}

//重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO) {
        
        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.plusBtn];
        
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [self.plusBtn pointInside:newP withEvent:event]) {
            return self.plusBtn;
        }else{//如果点不在发布按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    }
    
    else {//tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chongdianzhuangtai" object:self];
    
    
}
@end
