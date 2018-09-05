//
//  OrderDetailHeadCell.m
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "OrderDetailHeadCell.h"

@implementation OrderDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.OrderNumLabel.text = [NSString stringWithFormat:@"订单号:%@",_dic[@"orderno"]];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",_dic[@"link_phone"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",_dic[@"link_name"]];
    self.needCountLabel.text = [NSString stringWithFormat:@"%@辆",_dic[@"need_count"]];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f元",[_dic[@"order_money"] floatValue]];
    
    NSString*string = [NSString stringWithFormat:@"%@",_dic[@"createtime"]];
//    if (string.length>10) {
//        string = [string substringToIndex:10];//截取掉下标10之后的字符串
//    }
    self.timeLabel.text = string;
    
    if ([_dic[@"orderstatus"] integerValue] == 0) {
        self.OrderStatusLabel.text = @"未审核";
        self.OrderStatusLabel.textColor = UIColorFromRGB(0xFE5100);
        self.sanjaoImageV.image = [UIImage imageNamed:@"5.7"];
    }else if ([_dic[@"orderstatus"] integerValue] == 1){
        self.OrderStatusLabel.text = @"审核通过";
        self.OrderStatusLabel.textColor = UIColorFromRGB(0x00C85D);
        self.sanjaoImageV.image = [UIImage imageNamed:@"5.8"];
    }else if ([_dic[@"orderstatus"] integerValue] == 2){
        self.OrderStatusLabel.text = @"审核未通过";
        self.OrderStatusLabel.textColor = UIColorFromRGB(0x888888);
        self.sanjaoImageV.image = [UIImage imageNamed:@"5.9"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
