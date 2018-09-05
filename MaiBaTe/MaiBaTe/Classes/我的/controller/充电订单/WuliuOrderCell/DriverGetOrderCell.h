//
//  DriverGetOrderCell.h
//  MaiBaTe
//
//  Created by 钱龙 on 2018/1/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WuliuOrderModel.h"
@interface DriverGetOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *carType;
@property (weak, nonatomic) IBOutlet UILabel *startPoint;
@property (weak, nonatomic) IBOutlet UILabel *endPoint;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageV;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *cartypeLab;

@property (nonatomic,strong)void(^phoneCallBlcok)();
@property (nonatomic,strong)WuliuOrderModel*model;
@property (nonatomic,strong)UIViewController *controller;
@end
