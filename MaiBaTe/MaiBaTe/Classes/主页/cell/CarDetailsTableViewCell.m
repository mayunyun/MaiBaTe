//
//  CarDetailsTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 2017/12/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CarDetailsTableViewCell.h"

@interface CarDetailsTableViewCell()

@property(nonatomic,strong) UILabel *titleView;
@property(nonatomic,strong) UILabel *otherView;
@property(nonatomic,strong) UILabel *xianView;

@end
@implementation CarDetailsTableViewCell

-(void)setdata:(NSString *)title otherStr:(NSString *)str{
    
    UIView *contentView = self.contentView;
    
    _xianView.sd_layout
    .leftSpaceToView(contentView, 40*MYWIDTH)
    .rightSpaceToView(contentView, 40*MYWIDTH)
    .bottomEqualToView(contentView)
    .heightIs(1);
    
    _titleView.sd_layout
    .leftSpaceToView(contentView, 40*MYWIDTH)
    .topEqualToView(contentView)
    .widthIs(100)
    .bottomSpaceToView(_xianView, 0);
    
    _otherView.sd_layout
    .rightSpaceToView(contentView, 40*MYWIDTH)
    .leftSpaceToView(_titleView, 0)
    .topEqualToView(contentView)
    .bottomSpaceToView(_xianView, 0);
    
    _titleView.text = title;
    _otherView.text = str;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self titleView];
        [self otherView];
        [self xianView];

    }
    return self;
}
- (UILabel *)titleView{
    if (_titleView == nil) {
        _titleView =[[UILabel alloc]init];
        _titleView.font = [UIFont systemFontOfSize:13];
        _titleView.textColor = UIColorFromRGB(0x555555);
        [self.contentView addSubview: _titleView];
    }
    return _titleView;
}
- (UILabel *)otherView{
    if (_otherView == nil) {
        _otherView =[[UILabel alloc]init];
        _otherView.font = [UIFont systemFontOfSize:13];
        _otherView.textColor = UIColorFromRGB(0x666666);
        _otherView.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview: _otherView];
    }
    return _otherView;
}
- (UILabel *)xianView{
    if (_xianView == nil) {
        _xianView =[[UILabel alloc]init];
        _xianView.backgroundColor = UIColorFromRGB(MYLine);
        [self.contentView addSubview: _xianView];
    }
    return _xianView;
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
