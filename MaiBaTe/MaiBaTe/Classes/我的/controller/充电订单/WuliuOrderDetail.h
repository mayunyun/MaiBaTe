//
//  WuliuOrderDetail.h
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "WuliuOrderModel.h"
@interface WuliuOrderDetail : BaseViewController
@property (nonatomic,strong)NSString * custstatus;
@property (nonatomic,strong)NSString * driverstatus;
@property (nonatomic,strong)WuliuOrderModel * model;
@property (nonatomic,strong)NSMutableDictionary * needDic;
@end
