//
//  OrderDetailPassCell.m
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "OrderDetailPassCell.h"

@implementation OrderDetailPassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",_dic[@"shijiquche_name"]];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",_dic[@"shijiquche_linkerphone"]];
    
    NSString*string = [NSString stringWithFormat:@"%@",_dic[@"shijiquche_time"]];
//    if (string.length>10) {
//        string = [string substringToIndex:10];//截取掉下标10之后的字符串
//    }
    self.timeLabel.text = string;
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@",_dic[@"shijiquche_address"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
