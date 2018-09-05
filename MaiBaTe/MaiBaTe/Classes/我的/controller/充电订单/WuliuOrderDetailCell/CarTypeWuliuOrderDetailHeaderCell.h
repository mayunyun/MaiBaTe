//
//  CarTypeWuliuOrderDetailHeaderCell.h
//  MaiBaTe
//
//  Created by LONG on 2018/4/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WuliuOrderModel.h"

@interface CarTypeWuliuOrderDetailHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *carType;
@property (weak, nonatomic) IBOutlet UILabel *useCarTime;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageV;
@property (weak, nonatomic) IBOutlet UILabel *tijiLab;
@property (weak, nonatomic) IBOutlet UILabel *menpaiHLab;
@property (weak, nonatomic) IBOutlet UILabel *beizhuLab;

@property (nonatomic,strong)WuliuOrderModel * model;
@end
