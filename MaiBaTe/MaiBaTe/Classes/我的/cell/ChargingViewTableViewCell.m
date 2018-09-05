//
//  ChargingViewTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 17/8/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ChargingViewTableViewCell.h"

@implementation ChargingViewTableViewCell

- (void)setData:(ChargingModel *)data
{
    _data = data;
    //下圆角
    _bgview.frame = CGRectMake(40, 40, UIScreenW-75, 90);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgview.bounds byRoundingCorners:UIRectCornerTopRight |UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _bgview.bounds;
    maskLayer.path = maskPath.CGPath;
    
    _bgview.layer.mask = maskLayer;
    
    _createtimeLab.text = [NSString stringWithFormat:@"%@",_data.createtime];
    _ordernoLab.text = [NSString stringWithFormat:@"%@",_data.orderno];
    _electricsbmLab.text = [NSString stringWithFormat:@"%@",_data.electricsbm];
    _realmoneyLab.text = [NSString stringWithFormat:@"￥%.2f",[_data.realmoney floatValue]];
    
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
