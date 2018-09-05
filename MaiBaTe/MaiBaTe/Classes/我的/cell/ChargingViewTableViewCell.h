//
//  ChargingViewTableViewCell.h
//  MaiBaTe
//
//  Created by LONG on 17/8/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChargingModel.h"
@interface ChargingViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UILabel *createtimeLab;
@property (weak, nonatomic) IBOutlet UILabel *ordernoLab;
@property (weak, nonatomic) IBOutlet UILabel *electricsbmLab;
@property (weak, nonatomic) IBOutlet UILabel *realmoneyLab;

@property(nonatomic,strong) ChargingModel *data;

@end
