//
//  MyPurseTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 17/8/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyPurseTableViewCell.h"
@interface MyPurseTableViewCell()

@end
@implementation MyPurseTableViewCell
- (void)setdata:(NSString *)title{
    CGFloat margin = 15;
    UIView *contentView = self.contentView;
    
    //设置各控件的frame以及data
    //背景
    
    _bgview.sd_layout
    .leftSpaceToView(contentView,1.0 * margin)
    .topSpaceToView(contentView,0.5 * margin)
    .rightSpaceToView(contentView,1.0 * margin)
    .bottomSpaceToView(contentView,0.5 * margin);
    
    //头像
    _iconView.sd_layout
    .leftSpaceToView(_bgview,1 * margin)
    .centerYEqualToView(_bgview)
    .heightIs(25)
    .widthIs(25);
    
    //标题
    _titleView.sd_layout
    .leftSpaceToView(_iconView,1 * margin)
    .centerYEqualToView(_bgview)
    .widthIs(100)
    .heightIs(25);
    
    
    _otherView.sd_layout
    .leftSpaceToView(_titleView,1.5 * margin)
    .centerYEqualToView(_bgview)
    .rightSpaceToView(_bgview,1 * margin)
    .heightIs(25);
    
    _iconView.image = [UIImage imageNamed:title];
    _titleView.text = title;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self bgview];
        [self iconView];//头像
        [self titleView];
        [self otherView];
        
    }
    return self;
}

- (UIImageView *)bgview
{
    if(_bgview ==nil)
    {
        _bgview =[[UIImageView alloc]init];
        _bgview.image = [UIImage imageNamed:@"圆角矩形"];
        [self.contentView addSubview:_bgview];
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
        _titleView.font = [UIFont systemFontOfSize:15];
        _titleView.textColor = UIColorFromRGB(0x333333);
        [_bgview addSubview: _titleView];
    }
    
    return _titleView;
    
}
- (UILabel *)otherView
{
    if(_otherView ==nil)
    {
        _otherView =[[UILabel alloc]init];
        _otherView.font = [UIFont systemFontOfSize:15];
        _otherView.textColor = UIColorFromRGB(0x666666);
        _otherView.textAlignment = NSTextAlignmentRight;
        [_bgview addSubview: _otherView];
    }
    
    return _otherView;
    
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
