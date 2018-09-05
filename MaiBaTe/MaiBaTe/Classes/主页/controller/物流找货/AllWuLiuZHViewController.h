//
//  AllWuLiuZHViewController.h
//  MaiBaTe
//
//  Created by LONG on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "AllWuLiuZHHeadertitleView.h"
@interface AllWuLiuZHViewController : BaseViewController<AllWuLiuZHHeadertitleViewDelegate,UIScrollViewDelegate>
//头部的选项卡
@property(nonatomic,strong) AllWuLiuZHHeadertitleView *titleView;

//滚动条
@property(nonatomic,strong) UIScrollView *scrollView;

//大数组，子控制器的
@property(nonatomic,strong) NSMutableArray *childViews;

@property (nonatomic,strong)NSString *city;

@end
