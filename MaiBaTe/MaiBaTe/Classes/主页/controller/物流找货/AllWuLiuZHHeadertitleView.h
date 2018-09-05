//
//  AllWuLiuZHHeadertitleView.h
//  MaiBaTe
//
//  Created by LONG on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AllWuLiuZHHeadertitleView;

@protocol AllWuLiuZHHeadertitleViewDelegate <NSObject>

@optional
- (void)titleView:(AllWuLiuZHHeadertitleView *)titleView scollToIndex:(NSInteger)tagIndex;

@end
@interface AllWuLiuZHHeadertitleView : UIView
@property (nonatomic,weak) id<AllWuLiuZHHeadertitleViewDelegate>delegate;

-(void)wanerSelected:(NSInteger)tagIndex;
@end
