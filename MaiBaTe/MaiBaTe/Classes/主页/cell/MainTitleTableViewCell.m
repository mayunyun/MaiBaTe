//
//  MainTitleTableViewCell.m
//  PetrpleumLove
//
//  Created by LONG on 16/8/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MainTitleTableViewCell.h"

@interface MainTitleTableViewCell()

@property(nonatomic,strong) UIView *bgview;//背景
@property(nonatomic,strong) UIImageView *iconView;//头像
@property(nonatomic,strong) UILabel *titleView;//标题


@end

@implementation MainTitleTableViewCell
- (void)setdata{
    CGFloat margin = 10;
    
    //设置各控件的frame以及data
    
    
    
    //标题
    _titleView.sd_layout
    .leftSpaceToView(_bgview, margin)
    .topSpaceToView(_bgview,0.6 * margin)
    .rightSpaceToView(_bgview,1.5 * margin)
    .heightIs(25);
    
    _iconView.sd_layout
    .rightSpaceToView(_bgview,margin)
    .topSpaceToView(_bgview, 0.9 * margin)
    .heightIs(18)
    .widthIs(18);
    
    _iconView.image = [UIImage imageNamed:@"更多(1)"];
    _titleView.text = @"最新动态";
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self bgview];
        [self iconView];
        [self titleView];
      
       
    }
    return self;
}
- (UIView *)bgview
{
    if(_bgview ==nil)
    {
        _bgview =[[UIView alloc]init];
        _bgview.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgview];
    
        _bgview.frame = CGRectMake(10, 14, UIScreenW-20, 50-14);
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _bgview.bounds;
        maskLayer.path = maskPath.CGPath;
        _bgview.layer.mask = maskLayer;
    }
    
    return _bgview;
}

//头像view
- (UIImageView *)iconView
{
    if(_iconView ==nil)
    {
        _iconView =[[UIImageView alloc]init];
        
        [_bgview addSubview:_iconView];
    }
    
    return _iconView;
}
- (UILabel *)titleView
{
    if(_titleView ==nil)
    {
        _titleView =[[UILabel alloc]init];
        _titleView.font = [UIFont systemFontOfSize:11];
        _titleView.textColor = UIColorFromRGB(0x333333);
        [_bgview addSubview: _titleView];
    }
    
    return _titleView;
    
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
