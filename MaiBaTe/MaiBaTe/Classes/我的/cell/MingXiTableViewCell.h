//
//  MingXiTableViewCell.h
//  MaiBaTe
//
//  Created by LONG on 17/8/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MingXiModel.h"
@interface MingXiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeimage;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *jiaoyiDH;
@property (weak, nonatomic) IBOutlet UILabel *chongzhiDH;
@property (weak, nonatomic) IBOutlet UILabel *paytypeLab;

@property (nonatomic, strong)MingXiModel *data;

@end
