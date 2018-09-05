//
//  CarTypeWuliuOrderDetail.h
//  MaiBaTe
//
//  Created by LONG on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "WuliuOrderModel.h"
@interface CarTypeWuliuOrderDetail : BaseViewController
@property (nonatomic,strong)NSString * custstatus;
@property (nonatomic,strong)NSString * driverstatus;
@property (nonatomic,strong)WuliuOrderModel * model;
@property (nonatomic,strong)NSMutableDictionary * needDic;
@end
