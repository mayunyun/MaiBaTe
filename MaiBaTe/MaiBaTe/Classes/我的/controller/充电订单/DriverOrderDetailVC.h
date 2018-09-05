//
//  DriverOrderDetailVC.h
//  MaiBaTe
//
//  Created by 钱龙 on 2018/1/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "WuliuOrderModel.h"
@interface DriverOrderDetailVC : BaseViewController
@property (nonatomic,strong)NSString * status;
@property (nonatomic,strong)WuliuOrderModel * model;
@property (nonatomic,strong)NSMutableDictionary * needDic;
@end
