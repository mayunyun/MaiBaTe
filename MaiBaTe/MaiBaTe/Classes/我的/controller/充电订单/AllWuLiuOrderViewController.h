//
//  AllWuLiuOrderViewController.h
//  MaiBaTe
//
//  Created by LONG on 2018/4/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "WuLiuOrderHeaderTitleView.h"

@interface AllWuLiuOrderViewController : BaseViewController<WuLiuOrderHeaderTitleViewDelegate,UIScrollViewDelegate>
//头部的选项卡
@property(nonatomic,strong) WuLiuOrderHeaderTitleView *titleView;

//滚动条
@property(nonatomic,strong) UIScrollView *scrollView;

//大数组，子控制器的
@property(nonatomic,strong) NSMutableArray *childViews;

@property (nonatomic,strong)NSString * stitle;

@end
