//
//  WuliuFaHuoCell.m
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "WuliuFaHuoCell.h"
#import "WuLiuOrderViewController.h"
#import "AllWuliuOrderListVC.h"

@implementation WuliuFaHuoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(WuliuOrderModel *)model{
    _model = model;
    
    if ([self.controller isKindOfClass:[WuLiuOrderViewController class]]||[self.controller isKindOfClass:[AllWuliuOrderListVC class]]) {
        self.orderNo.text = [NSString stringWithFormat:@"订单号:%@",_model.orderno];
        self.carTypeLabel.text = [NSString stringWithFormat:@"%@",_model.cargotypenames];
        NSString * createTime = [_model.createtime substringToIndex:[_model.createtime length] - 3];
        self.createTimeLabel.text = [NSString stringWithFormat:@"%@",createTime];
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[_model.price floatValue]];
        self.cartypeLab.text = @"货物类型";
    }else{
        self.orderNo.text = [NSString stringWithFormat:@"订单号:%@",_model.owner_orderno];
        self.carTypeLabel.text = [NSString stringWithFormat:@"%@",_model.car_type];
        NSString * createTime = [_model.owner_createtime substringToIndex:[_model.owner_createtime length] - 3];
        self.createTimeLabel.text = [NSString stringWithFormat:@"%@",createTime];
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[_model.owner_totalprice floatValue]];
        self.cartypeLab.text = @"车型";
    }
    NSString * status = [NSString stringWithFormat:@"%@",_model.cust_orderstatus];
    self.statusLabel.textColor = UIColorFromRGB(0xffb400);
    if ([status isEqualToString:@"0"]) {
        self.statusLabel.text = [NSString stringWithFormat:@"%@",@"等待接货"];
    }else if ([status isEqualToString:@"1"]){
        self.statusLabel.text = [NSString stringWithFormat:@"%@",@"服务开始"];
    }else if ([status isEqualToString:@"2"]){
        self.statusLabel.hidden = YES;
        self.statusImageV.image = [UIImage imageNamed:@"14.1"];
    }else{
        self.statusLabel.hidden = YES;
        self.statusImageV.image = [UIImage imageNamed:@"14.2"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
