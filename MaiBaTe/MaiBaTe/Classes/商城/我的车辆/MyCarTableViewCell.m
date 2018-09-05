//
//  MyCarTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 2017/10/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyCarTableViewCell.h"
@interface MyCarTableViewCell()

@property(nonatomic,strong) UIView *bgview;//背景
@property(nonatomic,strong) UIImageView *iconView;//头像
@property(nonatomic,strong) UILabel *titleView;//标题
@property(nonatomic,strong) UIView *xianview;
@property(nonatomic,strong) UIImageView *iconView1;//头像
@property(nonatomic,strong) UIImageView *iconView2;//头像
@property(nonatomic,strong) UIImageView *iconView3;//头像
@property(nonatomic,strong) UIImageView *iconView4;//头像
//@property(nonatomic,strong) UIImageView *iconView5;//头像
@property(nonatomic,strong) UIImageView *iconView6;//头像
@property(nonatomic,strong) UILabel *titleView1;//标题
@property(nonatomic,strong) UILabel *titleView2;//标题
@property(nonatomic,strong) UILabel *titleView3;//标题
@property(nonatomic,strong) UILabel *titleView4;//标题
//@property(nonatomic,strong) UILabel *titleView5;//标题
@property(nonatomic,strong) UILabel *titleView6;//标题
@property(nonatomic,strong) UIView *xianview1;
@property(nonatomic,strong) UILabel *beizhuview;

@end
@implementation MyCarTableViewCell


- (void)setData:(MyCarModel *)data
{
    _data = data;
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10*MYWIDTH;
    
    //设置各控件的frame以及data
    _bgview.sd_layout
    .leftSpaceToView(contentView, 15*MYWIDTH)
    .rightSpaceToView(contentView, 15*MYWIDTH)
    .topSpaceToView(contentView, 10*MYWIDTH)
    .bottomSpaceToView(contentView, 10*MYWIDTH);
    
    
    //头像
    _iconView.sd_layout
    .leftSpaceToView(_bgview,margin)
    .topSpaceToView(_bgview,margin)
    .widthIs(20*MYWIDTH)
    .heightIs(20*MYWIDTH);
    
    //标题
    _titleView.sd_layout
    .leftSpaceToView(_iconView,margin)
    .topSpaceToView(_bgview, margin)
    .rightSpaceToView(_bgview, margin)
    .heightIs(20*MYWIDTH);
    
    //线
    _xianview.sd_layout
    .leftSpaceToView(_bgview,0)
    .topSpaceToView(_titleView, margin)
    .rightSpaceToView(_bgview, 0)
    .heightIs(1);
    
    _iconView1.sd_layout
    .leftSpaceToView(_bgview, margin)
    .topSpaceToView(_xianview, 1.5*margin)
    .widthIs(margin)
    .heightIs(margin);
    
    _iconView2.sd_layout
    .leftSpaceToView(_bgview, margin)
    .topSpaceToView(_iconView1, 1.5*margin)
    .widthIs(margin)
    .heightIs(margin);
    
    _iconView3.sd_layout
    .leftSpaceToView(_bgview, margin)
    .topSpaceToView(_iconView2, 1.5*margin)
    .widthIs(margin)
    .heightIs(margin);
    
    _iconView4.sd_layout
    .leftSpaceToView(_bgview, UIScreenW/2-15*MYWIDTH + margin)
    .topSpaceToView(_xianview, 2*margin)
    .widthIs(margin)
    .heightIs(margin);
    
//    _iconView5.sd_layout
//    .leftSpaceToView(_bgview, UIScreenW/2-15*MYWIDTH + margin)
//    .topSpaceToView(_iconView4, margin)
//    .widthIs(margin)
//    .heightIs(margin);
    
    _iconView6.sd_layout
    .leftSpaceToView(_bgview, UIScreenW/2-15*MYWIDTH + margin)
    .topSpaceToView(_iconView4, 3*margin)
    .widthIs(margin)
    .heightIs(margin);
    
    _titleView1.sd_layout
    .leftSpaceToView(_iconView1,margin)
    .rightSpaceToView(_bgview, UIScreenW/2-15*MYWIDTH)
    .centerYEqualToView(_iconView1)
    .heightIs(20*MYWIDTH);
    
    _titleView2.sd_layout
    .leftSpaceToView(_iconView2,margin)
    .rightSpaceToView(_bgview, UIScreenW/2-15*MYWIDTH)
    .centerYEqualToView(_iconView2)
    .heightIs(20*MYWIDTH);
    
    _titleView3.sd_layout
    .leftSpaceToView(_iconView3,margin)
    .rightSpaceToView(_bgview, UIScreenW/2-15*MYWIDTH)
    .centerYEqualToView(_iconView3)
    .heightIs(20*MYWIDTH);
    
    _titleView4.sd_layout
    .leftSpaceToView(_iconView4,margin)
    .rightEqualToView(_bgview)
    .centerYEqualToView(_iconView4)
    .heightIs(40*MYWIDTH);
    
//    _titleView5.sd_layout
//    .leftSpaceToView(_iconView5,margin)
//    .rightSpaceToView(_bgview, _bgview.width/2)
//    .centerYEqualToView(_iconView5)
//    .heightIs(20*MYWIDTH);
    
    _titleView6.sd_layout
    .leftSpaceToView(_iconView6,margin)
    .rightEqualToView(_bgview)
    .centerYEqualToView(_iconView6)
    .heightIs(40*MYWIDTH);
    
    _xianview1.sd_layout
    .leftSpaceToView(_bgview,0)
    .topSpaceToView(_titleView3, margin)
    .rightSpaceToView(_bgview, 0)
    .heightIs(1);
    
    _beizhuview.sd_layout
    .leftSpaceToView(_bgview, margin)
    .topSpaceToView(_xianview1, margin)
    .rightSpaceToView(_bgview, margin)
    .bottomSpaceToView(_bgview, margin);
    
    _titleView.text = [NSString stringWithFormat:@"%@",_data.cartype];
    _titleView1.text = [NSString stringWithFormat:@"限乘人数:%@人",_data.maxpeople];
    _titleView2.text = [NSString stringWithFormat:@"续航里程:%@公里",_data.maxway];
    _titleView3.text = [NSString stringWithFormat:@"电机最大功率:%@kw",_data.power];
    _titleView4.text = [NSString stringWithFormat:@"最高车速:%@公里/小时",_data.maxspeed];
    //_titleView5.text = [NSString stringWithFormat:@"电池容量:%@kwh",_data.engine];
    _titleView6.text = [NSString stringWithFormat:@"发动机型号:%@",_data.engine];
    _beizhuview.text = [NSString stringWithFormat:@"备注:%@",_data.note];
    [self changeTextColor:_titleView1 Txt:_titleView1.text changeTxt:[NSString stringWithFormat:@"%@",_data.maxpeople]];
    [self changeTextColor:_titleView2 Txt:_titleView2.text changeTxt:[NSString stringWithFormat:@"%@",_data.maxway]];
    [self changeTextColor:_titleView3 Txt:_titleView3.text changeTxt:[NSString stringWithFormat:@"%@",_data.power]];
    [self changeTextColor:_titleView4 Txt:_titleView4.text changeTxt:[NSString stringWithFormat:@"%@",_data.maxspeed]];
    
}
//改变某字符串的颜色
- (void)changeTextColor:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变颜色
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff354c"] range:NSMakeRange(location, length)];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
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
        [self xianview];
        [self iconView1];[self iconView2];[self iconView3];[self iconView4];
        //[self iconView5];
        [self iconView6];
        [self titleView1];[self titleView2];[self titleView3];[self titleView4];
        //[self titleView5];
        [self titleView6];
        [self xianview1];
        [self beizhuview];
        
    }
    return self;
}


- (UIView *)bgview
{
    if(_bgview ==nil)
    {
        _bgview =[[UIView alloc]init];
        _bgview.backgroundColor = [UIColor whiteColor];
        _bgview.clipsToBounds=YES;
        _bgview.layer.cornerRadius=5;
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
        _iconView.image = [UIImage imageNamed:@"汽车"];
        [_bgview addSubview:_iconView];
    }
    
    return _iconView;
}
- (UILabel *)titleView
{
    if(_titleView ==nil)
    {
        _titleView =[[UILabel alloc]init];
        _titleView.font = [UIFont systemFontOfSize:13];
        _titleView.textColor = UIColorFromRGB(0x333333);
        [_bgview addSubview: _titleView];
    }
    return _titleView;
}
- (UIView *)xianview
{
    if(_xianview ==nil)
    {
        _xianview =[[UIView alloc]init];
        _xianview.backgroundColor = UIColorFromRGB(MYColor);
        [_bgview addSubview:_xianview];
    }
    
    return _xianview;
}
- (UIImageView *)iconView1
{
    if(_iconView1 ==nil)
    {
        _iconView1 =[[UIImageView alloc]init];
        _iconView1.image = [UIImage imageNamed:@"人数限制"];
        [_bgview addSubview:_iconView1];
    }
    return _iconView1;
}
- (UIImageView *)iconView2
{
    if(_iconView2 ==nil)
    {
        _iconView2 =[[UIImageView alloc]init];
        _iconView2.image = [UIImage imageNamed:@"行驶里程"];
        [_bgview addSubview:_iconView2];
    }
    return _iconView2;
}- (UIImageView *)iconView3
{
    if(_iconView3 ==nil)
    {
        _iconView3 =[[UIImageView alloc]init];
        _iconView3.image = [UIImage imageNamed:@"功率"];
        [_bgview addSubview:_iconView3];
    }
    return _iconView3;
}- (UIImageView *)iconView4
{
    if(_iconView4 ==nil)
    {
        _iconView4 =[[UIImageView alloc]init];
        _iconView4.image = [UIImage imageNamed:@"速度"];
        [_bgview addSubview:_iconView4];
    }
    return _iconView4;
}
//- (UIImageView *)iconView5
//{
//    if(_iconView5 ==nil)
//    {
//        _iconView5 =[[UIImageView alloc]init];
//        _iconView5.image = [UIImage imageNamed:@"电池"];
//        [_bgview addSubview:_iconView5];
//    }
//    return _iconView5;
//}
- (UIImageView *)iconView6
{
    if(_iconView6 ==nil)
    {
        _iconView6 =[[UIImageView alloc]init];
        _iconView6.image = [UIImage imageNamed:@"产品型号"];
        [_bgview addSubview:_iconView6];
    }
    return _iconView6;
}
- (UILabel *)titleView1
{
    if(_titleView1 ==nil)
    {
        _titleView1 =[[UILabel alloc]init];
        _titleView1.font = [UIFont systemFontOfSize:12];
        _titleView1.textColor = UIColorFromRGB(0x666666);
        [_bgview addSubview: _titleView1];
    }
    return _titleView1;
}- (UILabel *)titleView2
{
    if(_titleView2 ==nil)
    {
        _titleView2 =[[UILabel alloc]init];
        _titleView2.font = [UIFont systemFontOfSize:12];
        _titleView2.textColor = UIColorFromRGB(0x666666);
        [_bgview addSubview: _titleView2];
    }
    return _titleView2;
}- (UILabel *)titleView3
{
    if(_titleView3 ==nil)
    {
        _titleView3 =[[UILabel alloc]init];
        _titleView3.font = [UIFont systemFontOfSize:12];
        _titleView3.textColor = UIColorFromRGB(0x666666);
        [_bgview addSubview: _titleView3];
    }
    return _titleView3;
}- (UILabel *)titleView4
{
    if(_titleView4 ==nil)
    {
        _titleView4 =[[UILabel alloc]init];
        _titleView4.font = [UIFont systemFontOfSize:12];
        _titleView4.textColor = UIColorFromRGB(0x666666);
        _titleView4.numberOfLines = 2;
        [_bgview addSubview: _titleView4];
    }
    return _titleView4;
}
//- (UILabel *)titleView5
//{
//    if(_titleView5 ==nil)
//    {
//        _titleView5 =[[UILabel alloc]init];
//        _titleView5.font = [UIFont systemFontOfSize:12];
//        _titleView5.textColor = UIColorFromRGB(0x666666);
//        [_bgview addSubview: _titleView5];
//    }
//    return _titleView5;
//}
- (UILabel *)titleView6
{
    if(_titleView6 ==nil)
    {
        _titleView6 =[[UILabel alloc]init];
        _titleView6.font = [UIFont systemFontOfSize:12];
        _titleView6.textColor = UIColorFromRGB(0x666666);
        _titleView6.numberOfLines = 2;
        [_bgview addSubview: _titleView6];
    }
    return _titleView6;
}
- (UIView *)xianview1
{
    if(_xianview1 ==nil)
    {
        _xianview1 =[[UIView alloc]init];
        _xianview1.backgroundColor = UIColorFromRGB(MYLine);
        [_bgview addSubview:_xianview1];
    }
    
    return _xianview1;
}
- (UILabel *)beizhuview
{
    if(_beizhuview ==nil)
    {
        _beizhuview =[[UILabel alloc]init];
        _beizhuview.font = [UIFont systemFontOfSize:13];
        _beizhuview.textColor = UIColorFromRGB(0x666666);
        [_bgview addSubview: _beizhuview];
    }
    return _beizhuview;
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
