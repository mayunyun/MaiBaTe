//
//  UIControl+UIControl_UIControl_buttonCon.h
//  MaiBaTe
//
//  Created by 邱 德政 on 17/10/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#define defaultInterval .5//默认时间间隔
@interface UIControl (UIControl_buttonCon)

@property(nonatomic,assign)NSTimeInterval timeInterval;//用这个给重复点击加间隔

@property(nonatomic,assign)BOOL isIgnoreEvent;//YES不允许点击NO允许点击

@end
