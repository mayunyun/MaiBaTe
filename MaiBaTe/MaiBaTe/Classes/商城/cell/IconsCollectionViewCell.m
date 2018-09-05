//
//  IconsCollectionViewCell.m
//  MaiBaTe
//
//  Created by LONG on 2017/9/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "IconsCollectionViewCell.h"

@implementation IconsCollectionViewCell

- (void)setData:(ShopAddrModel *)data
{
    _data = data;
    
    NSString *image = [NSString stringWithFormat:@"%@/%@%@",PHOTO_ADDRESS,_data.folder,_data.autoname];
    [_imgStr sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"icon_noting_face"]];
    _imgStr.contentMode = UIViewContentModeScaleAspectFit;
    [_titleBut setTitle:[NSString stringWithFormat:@" %@",_data.proname] forState:UIControlStateNormal];
    if ([_data.type intValue]==1) {
        _priceLab.text = [NSString stringWithFormat:@"￥%.2f",[_data.price floatValue]];
    }else if ([_data.type intValue]==2){
        _priceLab.text = [NSString stringWithFormat:@"%@积分",_data.price];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
