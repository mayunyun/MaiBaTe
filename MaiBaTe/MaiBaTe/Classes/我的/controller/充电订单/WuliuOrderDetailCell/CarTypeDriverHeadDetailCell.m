//
//  CarTypeDriverHeadDetailCell.m
//  MaiBaTe
//
//  Created by LONG on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CarTypeDriverHeadDetailCell.h"

@implementation CarTypeDriverHeadDetailCell

-(void)setModel:(WuliuOrderModel *)model{
    _model = model;
    self.orderNo.text = [NSString stringWithFormat:@"订单号:%@",_model.orderno];
    NSString * urlstring = [NSString stringWithFormat:@"%@/%@",PHOTO_ADDRESS,_model.headimg];
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:urlstring] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.userIcon.layer.cornerRadius = 15.f;
    self.userIcon.layer.masksToBounds = YES;
    NSLog(@"%@",urlstring);
    self.username.text = [NSString stringWithFormat:@"%@",_model.contactname];
    NSString * status = [NSString stringWithFormat:@"%@",_model.driver_orderstatus];
    self.carType.text = [NSString stringWithFormat:@"%@",_model.cargotypenames];
    NSString * sendtime = [_model.appointmenttime substringToIndex:[_model.appointmenttime length] - 2];
    self.useCarTime.text = [NSString stringWithFormat:@"%@",sendtime];
    NSString * createTime = [_model.createtime substringToIndex:[_model.createtime length] - 2];
    self.orderPublishTime.text = [NSString stringWithFormat:@"%@",createTime];
    self.startPoint.text = [NSString stringWithFormat:@"%@",_model.startaddress];
    self.endPoint.text = [NSString stringWithFormat:@"%@",_model.endaddress];
    self.menpaihaoLab.text = [NSString stringWithFormat:@"%@",_model.floorhousenumber];
    self.beizhuLab.text = [NSString stringWithFormat:@"%@",_model.remarks];
    self.tijiLab.text = [NSString stringWithFormat:@"%@m³",_model.volume];

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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
