//
//  MBTTabar.h
//  MaiBaTe
//
//  Created by LONG on 17/8/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBTTabar;

@protocol MBTTabarDelegate <NSObject>

@optional
- (void)tabBarPlusBtnClick:(MBTTabar *)tabBar;

@end

@interface MBTTabar : UITabBar

/** tabbar的代理 */
@property (nonatomic, weak) id<MBTTabarDelegate> myDelegate ;

@end
