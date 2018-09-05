//
//  UncheckedCell.m
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "UncheckedCell.h"

@implementation UncheckedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    if ([_dataDic[@"orderstatus"] integerValue]==0) {
        self.sanjiaoImageView.image = [UIImage imageNamed:@"sanjiao"];
    }else if([_dataDic[@"orderstatus"] integerValue]==1){
        self.sanjiaoImageView.image = [UIImage imageNamed:@"lvsesanjiao"];
    }else if ([_dataDic[@"orderstatus"] integerValue]==2){
        self.sanjiaoImageView.image = [UIImage imageNamed:@"huisanjiao"];
    }
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单号:%@",_dataDic[@"orderno"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",_dataDic[@"link_name"]];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",_dataDic[@"link_phone"]];
    self.needLabel.text = [NSString stringWithFormat:@"%@辆",_dataDic[@"sumcarnum"]];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f元",[_dataDic[@"order_money"] floatValue]];
    
    NSString*string = [NSString stringWithFormat:@"%@",_dataDic[@"createtime"]];
    if (string.length>10) {
        string = [string substringToIndex:10];//截取掉下标10之后的字符串
    }
    self.timeLabel.text = string;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
