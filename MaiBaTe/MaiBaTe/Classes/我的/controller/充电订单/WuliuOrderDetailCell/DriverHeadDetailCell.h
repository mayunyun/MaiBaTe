//
//  DriverHeadDetailCell.h
//  MaiBaTe
//
//  Created by 钱龙 on 2018/1/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WuliuOrderModel.h"
@interface DriverHeadDetailCell : UITableViewCell
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
@property (nonatomic,strong)void(^phoneBtnClickBlock)(void);
@property (nonatomic,strong)WuliuOrderModel * model;
@end
