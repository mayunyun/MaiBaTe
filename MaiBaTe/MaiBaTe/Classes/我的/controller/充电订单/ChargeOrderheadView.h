//
//  ChargeOrderheadView.h
//  MaiBaTe
//
//  Created by LONG on 17/8/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChargeOrderheadView;
@protocol ChargeOrderheadViewDelegate <NSObject>

@optional
- (void)titleView:(ChargeOrderheadView *)titleView scollToIndex:(NSInteger)tagIndex;

@end
@interface ChargeOrderheadView : UIView
@property (nonatomic,weak) id<ChargeOrderheadViewDelegate>delegate;

-(void)wanerSelected:(NSInteger)tagIndex;
@end
