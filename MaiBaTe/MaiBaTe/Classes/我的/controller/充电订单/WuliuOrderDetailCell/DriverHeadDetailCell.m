//
//  DriverHeadDetailCell.m
//  MaiBaTe
//
//  Created by 钱龙 on 2018/1/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DriverHeadDetailCell.h"

@implementation DriverHeadDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(WuliuOrderModel *)model{
    _model = model;
    self.orderNo.text = [NSString stringWithFormat:@"订单号:%@",_model.owner_orderno];
    NSString * urlstring = [NSString stringWithFormat:@"%@/%@/%@",PHOTO_ADDRESS,_model.folder,_model.autoname];
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:urlstring] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.userIcon.layer.cornerRadius = 15.f;
    self.userIcon.layer.masksToBounds = YES;
    NSLog(@"%@",urlstring);
    self.username.text = [NSString stringWithFormat:@"%@",_model.owner_link_name];
    NSString * status = [NSString stringWithFormat:@"%@",_model.driver_orderstatus];
    self.carType.text = [NSString stringWithFormat:@"%@",_model.car_type];
    NSString * sendtime = [_model.owner_sendtime substringToIndex:[_model.owner_sendtime length] - 3];
    self.useCarTime.text = [NSString stringWithFormat:@"%@",sendtime];
    NSString * createTime = [_model.owner_createtime substringToIndex:[_model.owner_createtime length] - 3];
    self.orderPublishTime.text = [NSString stringWithFormat:@"%@",createTime];
    self.startPoint.text = [NSString stringWithFormat:@"%@",_model.owner_address];
    self.endPoint.text = [NSString stringWithFormat:@"%@",_model.owner_send_address];
    self.orderStatus.textColor = UIColorFromRGB(0xffb400);
    if ([status isEqualToString:@"0"]) {
        self.orderStatus.text = [NSString stringWithFormat:@"%@",@"前往中"];
    }else if ([status isEqualToString:@"1"]){
        self.orderStatus.text = [NSString stringWithFormat:@"%@",@"开始订单"];
        self.orderStatus.textColor = UIColorFromRGB(0xFE5100);
    }else if ([status isEqualToString:@"2"]){
        self.orderStatus.hidden = YES;
        self.statusImageV.image = [UIImage imageNamed:@"10.1"];
    }else{
//        self.orderStatus.hidden = YES;
        self.orderStatus.text = [NSString stringWithFormat:@"%@",@"已取消"];
    }
}
-(IBAction)phoneBtn:(id)sender{
    if (_phoneBtnClickBlock) {
        self.phoneBtnClickBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
