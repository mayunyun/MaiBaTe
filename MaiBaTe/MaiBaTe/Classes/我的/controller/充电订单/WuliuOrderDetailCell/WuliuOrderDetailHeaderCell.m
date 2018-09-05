//
//  WuliuOrderDetailHeaderCell.m
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "WuliuOrderDetailHeaderCell.h"

@implementation WuliuOrderDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(WuliuOrderModel *)model{
    _model = model;
    self.orderNo.text = [NSString stringWithFormat:@"订单号:%@",_model.owner_orderno];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",_model.owner_link_name];
    NSString * status = [NSString stringWithFormat:@"%@",_model.cust_orderstatus];
    self.carType.text = [NSString stringWithFormat:@"%@",_model.car_type];
    NSString * sendtime = [_model.owner_sendtime substringToIndex:[_model.owner_sendtime length] - 3];
    self.useCarTime.text = [NSString stringWithFormat:@"%@",sendtime];
    NSString * createTime = [_model.owner_createtime substringToIndex:[_model.owner_createtime length] - 3];
    self.createTime.text = [NSString stringWithFormat:@"%@",createTime];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",_model.owner_link_phone];
    self.statusLabel.textColor = UIColorFromRGB(0xffb400);
    if ([status isEqualToString:@"0"]) {
        self.statusLabel.text = [NSString stringWithFormat:@"%@",@"等待接货"];
    }else if ([status isEqualToString:@"1"]){
        self.statusLabel.text = [NSString stringWithFormat:@"%@",@"服务开始"];
        self.statusLabel.textColor = UIColorFromRGB(0xFE5100);
    }else if ([status isEqualToString:@"2"]){
        self.statusLabel.hidden = YES;
        self.statusImageV.image = [UIImage imageNamed:@"10.1"];
    }else{
//        self.statusLabel.hidden = YES;
        self.statusLabel.text = [NSString stringWithFormat:@"%@",@"已取消"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
