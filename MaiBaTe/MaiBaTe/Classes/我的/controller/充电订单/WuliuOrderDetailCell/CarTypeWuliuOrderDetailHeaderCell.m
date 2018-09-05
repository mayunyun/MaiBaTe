//
//  CarTypeWuliuOrderDetailHeaderCell.m
//  MaiBaTe
//
//  Created by LONG on 2018/4/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CarTypeWuliuOrderDetailHeaderCell.h"

@implementation CarTypeWuliuOrderDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(WuliuOrderModel *)model{
    _model = model;
    self.orderNo.text = [NSString stringWithFormat:@"订单号:%@",_model.orderno];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",_model.contactname];
    NSString * status = [NSString stringWithFormat:@"%@",_model.cust_orderstatus];
    self.carType.text = [NSString stringWithFormat:@"%@",_model.cargotypenames];
    NSString * sendtime = [_model.appointmenttime substringToIndex:[_model.appointmenttime length] - 2];
    self.useCarTime.text = [NSString stringWithFormat:@"%@",sendtime];
    NSString * createTime = [_model.createtime substringToIndex:[_model.createtime length] - 2];
    self.createTime.text = [NSString stringWithFormat:@"%@",createTime];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",_model.contactphone];
    self.tijiLab.text = [NSString stringWithFormat:@"%@m³",_model.volume];
    self.menpaiHLab.text = [NSString stringWithFormat:@"%@",_model.floorhousenumber];
    self.beizhuLab.text = [NSString stringWithFormat:@"%@",_model.remarks];

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
