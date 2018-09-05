//
//  WuliuFaHuoCell.h
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WuliuOrderModel.h"
@interface WuliuFaHuoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageV;
@property (weak, nonatomic) IBOutlet UILabel *cartypeLab;

@property (nonatomic,strong)WuliuOrderModel *model;
@property (nonatomic,strong)UIViewController *controller;

@end
