//
//  CollectionHeadView.h
//  MaiBaTe
//
//  Created by LONG on 17/8/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionHeadDelegate <NSObject>

@optional
-(void)CollectionHeadBtnHaveString:(NSInteger *)resultString;

@end

@interface CollectionHeadView : UICollectionReusableView<SDCycleScrollViewDelegate>

@property(nonatomic,weak) id<CollectionHeadDelegate> delegate;


@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;

@property (nonatomic,strong)UIViewController *viewController;

-(void)dataHeadView;
@end
