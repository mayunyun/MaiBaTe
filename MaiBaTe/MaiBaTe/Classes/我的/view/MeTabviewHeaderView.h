//
//  MeTabviewHeaderView.h
//  MaiBaTe
//
//  Created by LONG on 17/8/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeModel.h"
#import "WQLStarView.h"
@protocol MeTabviewHeadDelegate <NSObject>

@optional
-(void)MeTabviewHeaderViewBtnHaveString:(int)resultString;

@end


@interface MeTabviewHeaderView : UIView

@property(nonatomic,weak) id<MeTabviewHeadDelegate> delegate;
@property (nonatomic,strong)WQLStarView * xingxingView;
@property (nonatomic,strong)UIView * starV;
//@property (nonatomic,strong)void(^starLevelBlock)(void);
- (void)settitledata:(MeModel *)data;
@end
