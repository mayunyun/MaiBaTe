//
//  ZuLinCarTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZuLinCarTableViewCell.h"

@interface ZuLinCarTableViewCell()

@property(nonatomic,strong) UIView *bgview;//背景
@property(nonatomic,strong) UILabel *titleView;//标题
@property(nonatomic,strong) UILabel *xianView;//线
@property(nonatomic,strong) UIImageView *iconView;//头像

@property(nonatomic,strong) UIImageView *cheView;//车
@property(nonatomic,strong) UIImageView *biaoView;//续航
@property(nonatomic,strong) UIImageView *dianView;//电量
@property(nonatomic,strong) UIImageView *chiView;//尺寸
@property(nonatomic,strong) UIImageView *qianView;//钱/时间

@property(nonatomic,strong) UILabel *cheLab;//
@property(nonatomic,strong) UILabel *biaoLab;//
@property(nonatomic,strong) UILabel *dianLab;//
@property(nonatomic,strong) UILabel *chiLab;//
@property(nonatomic,strong) UILabel *qianLab;//


@end


@implementation ZuLinCarTableViewCell

- (void)setdata:(ZuLinModel *)data{
    self.data = data;
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10*MYWIDTH;
    
    //设置各控件的frame以及data
    //背景
    _bgview.sd_layout
    .leftSpaceToView(contentView, 1.5*margin)
    .topSpaceToView(contentView, 0.6*margin)
    .rightSpaceToView(contentView, 1.5*margin)
    .bottomSpaceToView(contentView, 0.6*margin);
    
    //详情BUT
    _xiangqingbut.sd_layout
    .topEqualToView(_bgview)
    .rightSpaceToView(_bgview,1.5 * margin)
    .heightIs(45*MYWIDTH)
    .widthIs(150*MYWIDTH);

    //标题
    _titleView.sd_layout
    .leftSpaceToView(_bgview, margin)
    .topEqualToView(_bgview)
    .rightSpaceToView(_xiangqingbut, margin)
    .heightIs(45*MYWIDTH);
    
    _xianView.sd_layout
    .leftEqualToView(_bgview)
    .topSpaceToView(_titleView,0)
    .rightEqualToView(_bgview)
    .heightIs(1);
    
    _iconView.sd_layout
    .leftSpaceToView(_bgview,1.5*margin)
    .topSpaceToView(_xianView,margin)
    .bottomSpaceToView(_bgview, margin)
    .widthIs(145*MYWIDTH);
    
    CGFloat margin1 = 8*MYWIDTH;

    _cheView.sd_layout
    .leftSpaceToView(_iconView, 1.5*margin)
    .topEqualToView(_iconView)
    .widthIs(19*MYWIDTH)
    .heightIs(19*MYWIDTH);
    
    _biaoView.sd_layout
    .leftSpaceToView(_iconView, 1.5*margin)
    .topSpaceToView(_cheView, margin1)
    .widthIs(19*MYWIDTH)
    .heightIs(19*MYWIDTH);
    
    _dianView.sd_layout
    .leftSpaceToView(_iconView, 1.5*margin)
    .topSpaceToView(_biaoView, margin1)
    .widthIs(19*MYWIDTH)
    .heightIs(19*MYWIDTH);
    
    _chiView.sd_layout
    .leftSpaceToView(_iconView, 1.5*margin)
    .topSpaceToView(_dianView, margin1)
    .widthIs(19*MYWIDTH)
    .heightIs(19*MYWIDTH);
    
    _qianView.sd_layout
    .leftSpaceToView(_iconView, 1.5*margin)
    .topSpaceToView(_chiView, margin1)
    .widthIs(19*MYWIDTH)
    .heightIs(19*MYWIDTH);

    _cheLab.sd_layout
    .leftSpaceToView(_cheView, margin)
    .topEqualToView(_cheView)
    .rightSpaceToView(_bgview, 0.5*margin)
    .heightIs(19*MYWIDTH);
    
    _biaoLab.sd_layout
    .leftSpaceToView(_biaoView, margin)
    .topEqualToView(_biaoView)
    .rightSpaceToView(_bgview, 0.5*margin)
    .heightIs(19*MYWIDTH);
    
    _dianLab.sd_layout
    .leftSpaceToView(_dianView, margin)
    .topEqualToView(_dianView)
    .rightSpaceToView(_bgview, 0.5*margin)
    .heightIs(19*MYWIDTH);
    
    _chiLab.sd_layout
    .leftSpaceToView(_chiView, margin)
    .topEqualToView(_chiView)
    .rightSpaceToView(_bgview, 0.5*margin)
    .heightIs(19*MYWIDTH);
    
    _qianLab.sd_layout
    .leftSpaceToView(_qianView, 0.8*margin)
    .topSpaceToView(_chiLab, 0.6*margin)
    .rightSpaceToView(_bgview, 0.5*margin)
    .heightIs(25*MYWIDTH);
    
    NSString *image = [NSString stringWithFormat:@"%@/%@%@",PHOTO_ADDRESS,_data.folder,_data.autoname];
    NSLog(@"%@",image);
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"icon_noting_face"]];
    [_titleView setText:[NSString stringWithFormat:@"%@",_data.car_name]];
    
    [_cheLab setText:[NSString stringWithFormat:@"%@",_data.typename]];
    [_biaoLab setText:[NSString stringWithFormat:@"续航:%@",_data.car_extension_mileage]];
    [_dianLab setText:[NSString stringWithFormat:@"电量:%@",_data.car_electricity]];
    [_chiLab setText:[NSString stringWithFormat:@"尺寸:%@",_data.outside_size]];
    
    if ([_data.moon_price floatValue]>1000.0) {
        NSString *moonStr;
        if ([_data.moon_price floatValue]/1000==[_data.moon_price intValue]/1000){
            moonStr = [NSString stringWithFormat:@"￥%dK/月",[_data.moon_price intValue]/1000];
        }else{
            moonStr = [NSString stringWithFormat:@"￥%.1fK/月",[_data.moon_price floatValue]/1000];
        }
        NSString *yearStr;
        if ([_data.year_price floatValue]/10000==[_data.year_price intValue]/10000){
            yearStr = [NSString stringWithFormat:@"￥%dW/年",[_data.year_price intValue]/10000];
        }else{
            yearStr = [NSString stringWithFormat:@"￥%.1fW/年",[_data.year_price floatValue]/10000];
        }
        [_qianLab setText:[NSString stringWithFormat:@"%@%@",moonStr,yearStr]];
    }else{
        [_qianLab setText:[NSString stringWithFormat:@"￥%@/月￥%@/年",_data.moon_price,_data.year_price]];
    }
    [self changeTextColor:_qianLab Txt:_qianLab.text];

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self bgview];
        [self xiangqingbut];
        [self iconView];
        [self titleView];
        [self xianView];
        [self cheView];
        [self biaoView];
        [self dianView];
        [self chiView];
        [self qianView];
        [self cheLab];
        [self biaoLab];
        [self dianLab];
        [self chiLab];
        [self qianLab];
    }
    return self;
}
- (UIView *)bgview
{
    if(_bgview ==nil)
    {
        _bgview =[[UIView alloc]init];
        _bgview.layer.cornerRadius = 10;
        _bgview.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgview];
        
    }
    
    return _bgview;
}
- (UIButton *)xiangqingbut{
    if (_xiangqingbut == nil) {
        _xiangqingbut = [[UIButton alloc]init];
        _xiangqingbut.backgroundColor = [UIColor whiteColor];
        [_xiangqingbut setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_xiangqingbut setTitle:@"查看参数详情 >" forState:UIControlStateNormal];
        _xiangqingbut.titleLabel.font = [UIFont systemFontOfSize:13*MYWIDTH];
        _xiangqingbut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

        [_bgview addSubview:_xiangqingbut];
    }
    return _xiangqingbut;
}
- (UILabel *)titleView
{
    if(_titleView ==nil)
    {
        _titleView =[[UILabel alloc]init];
        _titleView.font = [UIFont systemFontOfSize:15*MYWIDTH];
        _titleView.textColor = UIColorFromRGB(0x222222);
        [_bgview addSubview: _titleView];
    }
    
    return _titleView;
    
}
- (UILabel *)xianView
{
    if(_xianView ==nil)
    {
        _xianView =[[UILabel alloc]init];
        _xianView.backgroundColor = UIColorFromRGB(MYLine);
        [_bgview addSubview: _xianView];
    }
    
    return _xianView;
    
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

- (UIImageView *)cheView
{
    if(_cheView ==nil)
    {
        _cheView =[[UIImageView alloc]init];
        _cheView.image = [UIImage imageNamed:@"cheview"];
        [_bgview addSubview:_cheView];
    }
    return _cheView;
}
- (UIImageView *)biaoView
{
    if(_biaoView ==nil)
    {
        _biaoView =[[UIImageView alloc]init];
        _biaoView.image = [UIImage imageNamed:@"biaoview"];
        [_bgview addSubview:_biaoView];
    }
    return _biaoView;
}
- (UIImageView *)dianView
{
    if(_dianView ==nil)
    {
        _dianView =[[UIImageView alloc]init];
        _dianView.image = [UIImage imageNamed:@"dianview"];
        [_bgview addSubview:_dianView];
    }
    return _dianView;
}
- (UIImageView *)chiView
{
    if(_chiView ==nil)
    {
        _chiView =[[UIImageView alloc]init];
        _chiView.image = [UIImage imageNamed:@"chiview"];
        [_bgview addSubview:_chiView];
    }
    return _chiView;
}
- (UIImageView *)qianView
{
    if(_qianView ==nil)
    {
        _qianView =[[UIImageView alloc]init];
        _qianView.image = [UIImage imageNamed:@"qianview"];
        [_bgview addSubview:_qianView];
    }
    return _qianView;
}
- (UILabel *)cheLab
{
    if(_cheLab ==nil)
    {
        _cheLab =[[UILabel alloc]init];
        _cheLab.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14*MYWIDTH];
        _cheLab.textColor = UIColorFromRGB(0xED6D1F);
        [_bgview addSubview: _cheLab];
    }
    return _cheLab;
}
- (UILabel *)biaoLab
{
    if(_biaoLab ==nil)
    {
        _biaoLab =[[UILabel alloc]init];
        _biaoLab.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14*MYWIDTH];
        _biaoLab.textColor = UIColorFromRGB(0x555555);
        [_bgview addSubview: _biaoLab];
    }
    return _biaoLab;
}
- (UILabel *)dianLab
{
    if(_dianLab ==nil)
    {
        _dianLab =[[UILabel alloc]init];
        _dianLab.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14*MYWIDTH];
        _dianLab.textColor = UIColorFromRGB(0x555555);
        [_bgview addSubview: _dianLab];
    }
    return _dianLab;
}
- (UILabel *)chiLab
{
    if(_chiLab ==nil)
    {
        _chiLab =[[UILabel alloc]init];
        _chiLab.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14*MYWIDTH];
        _chiLab.textColor = UIColorFromRGB(0x555555);
        [_bgview addSubview: _chiLab];
    }
    return _chiLab;
}
- (UILabel *)qianLab
{
    if(_qianLab ==nil)
    {
        _qianLab =[[UILabel alloc]init];
        _qianLab.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14*MYWIDTH];
        _qianLab.textColor = UIColorFromRGB(0xED6D1F);
        _qianLab.numberOfLines = 1;
        [_bgview addSubview: _qianLab];
    }
    return _qianLab;
}
//改变某字符串的颜色
- (void)changeTextColor:(UILabel *)label Txt:(NSString *)text
{
    //关键字在字符串中的位置
    NSUInteger location = [text rangeOfString:@"/月"].location;
    NSUInteger location1 = [text rangeOfString:@"/年"].location;
    //长度
    NSUInteger length = [text rangeOfString:@"/月"].length;
    NSUInteger length1 = [text rangeOfString:@"/年"].length;
    //改变颜色之前的转换
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
    //改变颜色
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(location, length)];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(location1, length1)];

    //赋值
    label.attributedText = str1;
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
