//
//  AllWuliuOrderListVC.h
//  MaiBaTe
//
//  Created by 钱龙 on 2018/1/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface AllWuliuOrderListVC : BaseViewController
@property (nonatomic,strong)NSString * type;//1物流发货  2司机接货
@property (nonatomic,strong)NSString * isBack;//判断是从搜索返回的界面

@property (nonatomic,strong)NSMutableArray * arr;
@end
