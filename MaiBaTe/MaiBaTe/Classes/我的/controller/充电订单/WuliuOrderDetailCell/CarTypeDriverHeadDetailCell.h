//
//  CarTypeDriverHeadDetailCell.h
//  MaiBaTe
//
//  Created by LONG on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WuliuOrderModel.h"

@interface CarTypeDriverHeadDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIButton *phone;
@property (weak, nonatomic) IBOutlet UILabel *startPoint;
@property (weak, nonatomic) IBOutlet UILabel *endPoint;
@property (weak, nonatomic) IBOutlet UILabel *carType;
@property (weak, nonatomic) IBOutlet UILabel *useCarTime;
@property (weak, nonatomic) IBOutlet UILabel *orderPublishTime;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageV;
@property (weak, nonatomic) IBOutlet UILabel *tijiLab;
@property (weak, nonatomic) IBOutlet UILabel *menpaihaoLab;
@property (weak, nonatomic) IBOutlet UILabel *beizhuLab;


@property (nonatomic,strong)void(^phoneBtnClickBlock)(void);
@property (nonatomic,strong)WuliuOrderModel * model;
@end
