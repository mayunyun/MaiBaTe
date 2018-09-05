//
//  WuLiuOrderHeaderTitleView.h
//  MaiBaTe
//
//  Created by LONG on 2018/4/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WuLiuOrderHeaderTitleView;

@protocol WuLiuOrderHeaderTitleViewDelegate <NSObject>

@optional
- (void)titleView:(WuLiuOrderHeaderTitleView *)titleView scollToIndex:(NSInteger)tagIndex;

@end
@interface WuLiuOrderHeaderTitleView : UIView
@property (nonatomic,weak) id<WuLiuOrderHeaderTitleViewDelegate>delegate;

-(void)wanerSelected:(NSInteger)tagIndex;
@end
