//
//  MingXiTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 17/8/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MingXiTableViewCell.h"

@implementation MingXiTableViewCell

- (void)setData:(MingXiModel *)data
{
    _data = data;
    if ([_data.type intValue] == 1) {
        _typeimage.image = [UIImage imageNamed:@"账户入金"];
    }else if([_data.type intValue] == 0){
        _typeimage.image = [UIImage imageNamed:@"账户出金"];
    }
    _moneyLab.text =  [NSString stringWithFormat:@"%.2f",[_data.money floatValue]];
    _timeLab.text = [NSString stringWithFormat:@"%@",_data.createtime];
    _jiaoyiDH.text = [NSString stringWithFormat:@"%@",_data.tradeno];
    _chongzhiDH.text = [NSString stringWithFormat:@"%@",_data.chargeno];
    if ([_data.paytype intValue] == 0) {
        _paytypeLab.text = @"微信";

    }else if ([_data.paytype intValue] == 1){
        _paytypeLab.text = @"支付宝";

    }else if ([_data.paytype intValue] == 2){
        _paytypeLab.text = @"银行卡";

    }else if ([_data.paytype intValue] == 3){
        _paytypeLab.text = @"余额";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
