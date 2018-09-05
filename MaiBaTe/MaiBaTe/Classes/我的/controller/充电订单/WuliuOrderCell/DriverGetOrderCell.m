//
//  DriverGetOrderCell.m
//  MaiBaTe
//
//  Created by 钱龙 on 2018/1/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DriverGetOrderCell.h"
#import "WuLiuOrderViewController.h"
#import "AllWuliuOrderListVC.h"

@implementation DriverGetOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(WuliuOrderModel *)model{
    _model = model;
    NSString * status;
    if ([self.controller isKindOfClass:[WuLiuOrderViewController class]]||[self.controller isKindOfClass:[AllWuliuOrderListVC class]]) {
        self.orderNo.text = [NSString stringWithFormat:@"订单号:%@",_model.orderno];
        self.name.text = [NSString stringWithFormat:@"%@",_model.contactname];
        self.startPoint.text = [NSString stringWithFormat:@"%@",_model.startaddress];
        self.endPoint.text = [NSString stringWithFormat:@"%@",_model.endaddress];
        self.carType.text = [NSString stringWithFormat:@"%@",_model.cargotypenames];
        NSString * createTime = [_model.createtime substringToIndex:[_model.createtime length] - 3];
        self.time.text = [NSString stringWithFormat:@"%@",createTime];
        self.price.text = [NSString stringWithFormat:@"￥%.2f",[_model.siji_money floatValue]];
        status = [NSString stringWithFormat:@"%@",_model.driver_orderstatus];
        self.cartypeLab.text = @"货物类型";
        self.priceLab.text = @"金额";
    }else{
        self.orderNo.text = [NSString stringWithFormat:@"订单号:%@",_model.owner_orderno];
        self.name.text = [NSString stringWithFormat:@"%@",_model.owner_link_name];
        self.startPoint.text = [NSString stringWithFormat:@"%@",_model.owner_address];
        self.endPoint.text = [NSString stringWithFormat:@"%@",_model.owner_send_address];
        self.carType.text = [NSString stringWithFormat:@"%@",_model.car_type];
        NSString * createTime = [_model.owner_createtime substringToIndex:[_model.owner_createtime length] - 3];
        self.time.text = [NSString stringWithFormat:@"%@",createTime];
        self.price.text = [NSString stringWithFormat:@"￥%.2f",[_model.siji_money floatValue]];
        status = [NSString stringWithFormat:@"%@",_model.cust_orderstatus];
        self.cartypeLab.text = @"用车类型";
        self.priceLab.text = @"酬劳";
    }
    self.orderStatus.textColor = UIColorFromRGB(0xffb400);
    if ([status isEqualToString:@"0"]) {
        self.orderStatus.text = [NSString stringWithFormat:@"%@",@"前往中"];
    }else if ([status isEqualToString:@"1"]){
        self.orderStatus.text = [NSString stringWithFormat:@"%@",@"开始订单"];
    }else if ([status isEqualToString:@"2"]){
        self.orderStatus.hidden = YES;
        self.statusImageV.image = [UIImage imageNamed:@"14.1"];
    }else{
        self.orderStatus.hidden = YES;
        self.statusImageV.image = [UIImage imageNamed:@"14.2"];
    }
}
- (IBAction)phoneBtnClicked:(id)sender {
    if (_phoneCallBlcok) {
        self.phoneCallBlcok();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
