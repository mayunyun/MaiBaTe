//
//  OrderDetailNeedCell.m
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "OrderDetailNeedCell.h"

@implementation OrderDetailNeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",_dataDic[@"car_name"]];
    self.countLabel.text = [NSString stringWithFormat:@"%@辆",_dataDic[@"lease_count"]];
    self.moneyLab.text = [NSString stringWithFormat:@"%.2f元",[_dataDic[@"total_money"] floatValue]];

    if ([[NSString stringWithFormat:@"%@",_dataDic[@"order_type"]] isEqualToString:@"1"]) {
        self.typeLabel.text = [NSString stringWithFormat:@"%@",@"长租"];
        self.dayLabel.text = [NSString stringWithFormat:@"%@年",_dataDic[@"during_time"]];
        self.priceLab.text = [NSString stringWithFormat:@"￥%@/年",_dataDic[@"year_price"]];

    }else{
        self.typeLabel.text = [NSString stringWithFormat:@"%@",@"短租"];
        self.dayLabel.text = [NSString stringWithFormat:@"%@月",_dataDic[@"during_time"]];
        self.priceLab.text = [NSString stringWithFormat:@"￥%@/月",_dataDic[@"moon_price"]];

    }
    if ([_dataDic[@"orderstatus"] integerValue] == 1){
        self.timeTitle.hidden = NO;
        self.timeLab.hidden = NO;
        self.timeTitle.text = @"到期时间";
        self.timeLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"expiry_time"]];
    }else{
        self.timeTitle.hidden = YES;
        self.timeLab.hidden = YES;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
