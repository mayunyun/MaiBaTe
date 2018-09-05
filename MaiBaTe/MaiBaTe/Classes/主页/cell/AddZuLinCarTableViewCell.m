//
//  AddZuLinCarTableViewCell.m
//  MaiBaTe
//
//  Created by LONG on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AddZuLinCarTableViewCell.h"

@interface AddZuLinCarTableViewCell()

@property(nonatomic,strong) UILabel *carLab;//
@property(nonatomic,strong) UIView *bgview;//背景
@property(nonatomic,strong) UILabel *titleView1;//标题
@property(nonatomic,strong) UILabel *titleView2;//标题
@property(nonatomic,strong) UILabel *titleView3;//标题
@property(nonatomic,strong) UILabel *titleView4;//标题
@property(nonatomic,strong) UILabel *xianView1;//线
@property(nonatomic,strong) UILabel *xianView2;//线
@property(nonatomic,strong) UILabel *xianView3;//线
@property(nonatomic,strong) UIImageView *youView1;//
@property(nonatomic,strong) UIImageView *youView2;//

@property(nonatomic,strong) UIButton *carBut;//
@property(nonatomic,strong) UIButton *upBut;//加
@property(nonatomic,strong) UIButton *BigupBut;//加
@property(nonatomic,strong) UILabel *contView;//数量
@property(nonatomic,strong) UIButton *downBut;//减
@property(nonatomic,strong) UIButton *BigdownBut;//减
@property(nonatomic,strong) UILabel *titleView31;//副标题
@property(nonatomic,strong) UIButton *changBut;//长租
@property(nonatomic,strong) UIButton *duanBut;//短租
@property(nonatomic,strong) UIButton *timeBut;//


@end


@implementation AddZuLinCarTableViewCell
- (void)setdata:(NSInteger)count{
    UIView *contentView = self.contentView;
    CGFloat margin = 10*MYWIDTH;
    
    //设置各控件的frame以及data
    _carLab.sd_layout
    .leftSpaceToView(contentView, 3*margin)
    .topEqualToView(contentView)
    .widthIs(200)
    .heightIs(40*MYWIDTH);
    
    _deleteBut.sd_layout
    .rightSpaceToView(contentView, 3*margin)
    .topSpaceToView(contentView, margin)
    .widthIs(15*MYWIDTH)
    .heightIs(18*MYWIDTH);
    //背景
    _bgview.sd_layout
    .leftSpaceToView(contentView, 1.5*margin)
    .topSpaceToView(_carLab, 0)
    .rightSpaceToView(contentView, 1.5*margin)
    .bottomSpaceToView(contentView, 0);
    
    //标题
    _titleView1.sd_layout
    .leftSpaceToView(_bgview, 1.5*margin)
    .topEqualToView(_bgview)
    .widthIs(100)
    .heightIs(50*MYWIDTH);
    
    _youView1.sd_layout
    .rightSpaceToView(_bgview, 1.6*margin)
    .topSpaceToView(_bgview, 1.8*margin)
    .widthIs(7*MYWIDTH)
    .heightIs(13*MYWIDTH);
    
    _carBut.sd_layout
    .leftEqualToView(_titleView1)
    .topEqualToView(_bgview)
    .rightSpaceToView(_youView1, margin)
    .heightIs(50*MYWIDTH);
    
    _xianView1.sd_layout
    .leftEqualToView(_bgview)
    .topSpaceToView(_titleView1, 0)
    .rightEqualToView(_bgview)
    .heightIs(1);
    
    _titleView2.sd_layout
    .leftSpaceToView(_bgview, 1.5*margin)
    .topEqualToView(_xianView1)
    .widthIs(100)
    .heightIs(50*MYWIDTH);
    
    _upBut.sd_layout
    .rightSpaceToView(_bgview, 2*margin)
    .topSpaceToView(_xianView1, 1.7*margin)
    .widthIs(1.5*margin)
    .heightIs(1.5*margin);
    
    _BigupBut.sd_layout
    .leftEqualToView(_upBut)
    .topSpaceToView(_xianView1, 0)
    .widthIs(4*margin)
    .heightIs(5*margin);
    
    _contView.sd_layout
    .rightSpaceToView(_upBut, margin)
    .topSpaceToView(_xianView1, 1.7*margin)
    .widthIs(3*margin)
    .heightIs(1.5*margin);
    
    _downBut.sd_layout
    .rightSpaceToView(_contView, margin)
    .topSpaceToView(_xianView1, 1.7*margin)
    .widthIs(1.5*margin)
    .heightIs(1.5*margin);
    
    _BigdownBut.sd_layout
    .rightEqualToView(_downBut)
    .topSpaceToView(_xianView1, 0)
    .widthIs(4*margin)
    .heightIs(5*margin);
    
    _xianView2.sd_layout
    .leftEqualToView(_bgview)
    .topSpaceToView(_titleView2, 0)
    .rightEqualToView(_bgview)
    .heightIs(1);
    
    _titleView3.sd_layout
    .leftSpaceToView(_bgview, 1.5*margin)
    .topEqualToView(_xianView2)
    .widthIs(60)
    .heightIs(50*MYWIDTH);
    
    _titleView31.sd_layout
    .leftSpaceToView(_titleView3, 0.5*margin)
    .topSpaceToView(_xianView2, margin)
    .widthIs(80)
    .heightIs(33*MYWIDTH);
    
    _changBut.sd_layout
    .rightSpaceToView(_bgview, 1.5*margin)
    .topSpaceToView(_xianView2, 1.2*margin)
    .widthIs(60*MYWIDTH)
    .heightIs(26*MYWIDTH);
    
//    _duanBut.sd_layout
//    .rightSpaceToView(_changBut, 1.5*margin)
//    .topSpaceToView(_xianView2, 1.2*margin)
//    .widthIs(60*MYWIDTH)
//    .heightIs(26*MYWIDTH);
    
    _xianView3.sd_layout
    .leftEqualToView(_bgview)
    .topSpaceToView(_titleView3, 0)
    .rightEqualToView(_bgview)
    .heightIs(1);
    
    _titleView4.sd_layout
    .leftSpaceToView(_bgview, 1.5*margin)
    .topEqualToView(_xianView3)
    .widthIs(100)
    .heightIs(50*MYWIDTH);
    
    _youView2.sd_layout
    .rightSpaceToView(_bgview, 1.6*margin)
    .topSpaceToView(_xianView3, 1.8*margin)
    .widthIs(7*MYWIDTH)
    .heightIs(13*MYWIDTH);
    
    _timeBut.sd_layout
    .leftEqualToView(_titleView4)
    .topEqualToView(_xianView3)
    .rightSpaceToView(_youView2, margin)
    .heightIs(50*MYWIDTH);
    
    _titleView1.text = @"车辆型号";
    _titleView2.text = @"需求数量";
    _titleView3.text = @"租车类型";
    _titleView4.text = @"租车时长";
    _carLab.text = [NSString stringWithFormat:@"车型需求(%zd)",count+1];
    
    [_carBut setTitle:self.model.carname forState:UIControlStateNormal];
    _contView.text = [NSString stringWithFormat:@"%zd",self.model.count];
    [_timeBut setTitle:self.model.time forState:UIControlStateNormal];
    if (count==0) {
        _deleteBut.hidden = YES;
    }else{
        _deleteBut.hidden = NO;
    }
    
}
- (void)carButClick:(UIButton*)sender{
    if (_NameArr.count==0) {
        jxt_showToastTitle(@"该城市没有车辆", 1);
        return;
    }
    __weak typeof(UIButton*) weakBtn = sender;
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in _NameArr) {
        [arr addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"car_name"]]];
    }
    
    [BRStringPickerView showStringPickerWithTitle:@"车辆型号" dataSource:arr defaultSelValue:weakSelf isAutoSelect:YES resultBlock:^(id selectValue) {
        [weakBtn setTitle:selectValue forState:UIControlStateNormal];
        for (NSDictionary *dic in _NameArr) {
            if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"car_name"]] isEqualToString:selectValue]) {
                self.model.carname = [NSString stringWithFormat:@"%@",[dic objectForKey:@"car_name"]];
                self.model.model_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            }
        }
    }];
}
- (void)timeButClick:(UIButton*)sender{
    
    __weak typeof(UIButton*) weakBtn = sender;
    __weak typeof(self) weakSelf = self;

    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (_changBut.selected==YES) {
        for (NSDictionary *dic in _CArr) {
            [arr addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"timename"]]];
        }
    }else{
        for (NSDictionary *dic in _DArr) {
            [arr addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"timename"]]];
        }
    }
    [BRStringPickerView showStringPickerWithTitle:@"租车时长" dataSource:arr defaultSelValue:weakSelf isAutoSelect:YES resultBlock:^(id selectValue) {
        [weakBtn setTitle:selectValue forState:UIControlStateNormal];
        self.model.time = selectValue;
        if (_changBut.selected==YES) {
            for (NSDictionary *dic in _CArr) {
                if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"timename"]] isEqualToString:selectValue]) {
                    self.model.during_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"during_time"]];
                }
            }
        }else{
            for (NSDictionary *dic in _DArr) {
                if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"timename"]] isEqualToString:selectValue]) {
                    self.model.during_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"during_time"]];
                }
            }
        }
    }];
}
-(void)changButClick{
    if (_changBut.selected == NO) {
        _changBut.selected = YES;
        _duanBut.selected = NO;
        [_timeBut setTitle:@"请选择" forState:UIControlStateNormal];
        self.model.order_type = @"1";
    }
}
-(void)duanButClick{
    if (_duanBut.selected == NO) {
        _duanBut.selected = YES;
        _changBut.selected = NO;
        [_timeBut setTitle:@"请选择" forState:UIControlStateNormal];
        self.model.order_type = @"0";
    }
}
- (void)upButClick{
    self.model.count++;
    
    _contView.text = [NSString stringWithFormat:@"%zd",self.model.count];
    self.downBut.enabled = YES;
    self.BigdownBut.enabled = YES;
}
- (void)downButClick{
    if (self.model.count <= 1) {
        self.BigdownBut.enabled = NO;
        self.downBut.enabled = NO;
        _contView.text = [NSString stringWithFormat:@"%d",1];
    }else{
        self.model.count--;
        _contView.text = [NSString stringWithFormat:@"%zd",self.model.count];
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self carLab];
        [self deleteBut];
        [self bgview];
        [self titleView1];
        [self titleView2];
        [self titleView3];
        [self titleView4];
        [self xianView1];
        [self xianView2];
        [self xianView3];
        [self youView1];
        [self carBut];
        [self upBut];
        [self BigupBut];
        [self contView];
        [self downBut];
        [self BigdownBut];
        [self titleView31];
        [self changBut];
        //[self duanBut];
        [self youView2];
        [self timeBut];
    }
    return self;
}
- (UILabel *)carLab{
    if (_carLab == nil) {
        _carLab =[[UILabel alloc]init];
        _carLab.font = [UIFont systemFontOfSize:14];
        _carLab.textColor = UIColorFromRGB(0x888888);
        [self.contentView addSubview: _carLab];
    }
    return _carLab;
}
- (UIButton *)deleteBut{
    if (_deleteBut == nil) {
        _deleteBut = [[UIButton alloc]init];
        [_deleteBut setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        [self.contentView addSubview:_deleteBut];
    }
    return _deleteBut;
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

- (UILabel *)titleView1
{
    if(_titleView1 ==nil)
    {
        _titleView1 =[[UILabel alloc]init];
        _titleView1.font = [UIFont systemFontOfSize:14];
        _titleView1.textColor = UIColorFromRGB(0x222222);
        [_bgview addSubview: _titleView1];
    }
    return _titleView1;
}
- (UILabel *)titleView2
{
    if(_titleView2 ==nil)
    {
        _titleView2 =[[UILabel alloc]init];
        _titleView2.font = [UIFont systemFontOfSize:14];
        _titleView2.textColor = UIColorFromRGB(0x222222);
        [_bgview addSubview: _titleView2];
    }
    return _titleView2;
}
- (UILabel *)titleView3
{
    if(_titleView3 ==nil)
    {
        _titleView3 =[[UILabel alloc]init];
        _titleView3.font = [UIFont systemFontOfSize:14];
        _titleView3.textColor = UIColorFromRGB(0x222222);
        [_bgview addSubview: _titleView3];
    }
    return _titleView3;
}
- (UILabel *)titleView4
{
    if(_titleView4 ==nil)
    {
        _titleView4 =[[UILabel alloc]init];
        _titleView4.font = [UIFont systemFontOfSize:14];
        _titleView4.textColor = UIColorFromRGB(0x222222);
        [_bgview addSubview: _titleView4];
    }
    return _titleView4;
}
- (UILabel *)xianView1
{
    if(_xianView1 ==nil)
    {
        _xianView1 =[[UILabel alloc]init];
        _xianView1.backgroundColor = UIColorFromRGB(MYLine);
        [_bgview addSubview: _xianView1];
    }
    return _xianView1;
}
- (UILabel *)xianView2
{
    if(_xianView2 ==nil)
    {
        _xianView2 =[[UILabel alloc]init];
        _xianView2.backgroundColor = UIColorFromRGB(MYLine);
        [_bgview addSubview: _xianView2];
    }
    return _xianView2;
}
- (UILabel *)xianView3
{
    if(_xianView3 ==nil)
    {
        _xianView3 =[[UILabel alloc]init];
        _xianView3.backgroundColor = UIColorFromRGB(MYLine);
        [_bgview addSubview: _xianView3];
    }
    return _xianView3;
}
- (UIImageView *)youView1{
    if (_youView1 == nil) {
        _youView1 = [[UIImageView alloc]init];
        _youView1.image = [UIImage imageNamed:@"chargeback"];
        [_bgview addSubview:_youView1];
    }
    return _youView1;
}
- (UIButton *)carBut{
    if (_carBut == nil) {
        _carBut = [[UIButton alloc]init];
        [_carBut setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        _carBut.titleLabel.font = [UIFont systemFontOfSize:14];
        _carBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_carBut addTarget:self action:@selector(carButClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgview addSubview:_carBut];
    }
    return _carBut;
}
- (UIButton *)upBut{
    if (_upBut == nil) {
        _upBut = [[UIButton alloc]init];
        [_upBut setImage:[UIImage imageNamed:@"增加"] forState:UIControlStateNormal];
        [_bgview addSubview:_upBut];
    }
    return _upBut;
}
- (UILabel *)contView
{
    if(_contView ==nil)
    {
        _contView =[[UILabel alloc]init];
        _contView.textColor = UIColorFromRGB(0x555555);
        _contView.textAlignment = NSTextAlignmentCenter;
        _contView.font = [UIFont systemFontOfSize:14];
        [_bgview addSubview: _contView];
    }
    return _contView;
}
- (UIButton *)downBut{
    if (_downBut == nil) {
        _downBut = [[UIButton alloc]init];
        [_downBut setImage:[UIImage imageNamed:@"图层-2"] forState:UIControlStateNormal];
        [_bgview addSubview:_downBut];
    }
    return _downBut;
}
- (UIButton *)BigupBut{
    if (_BigupBut == nil) {
        _BigupBut = [[UIButton alloc]init];
        [_BigupBut addTarget:self action:@selector(upButClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgview addSubview:_BigupBut];
    }
    return _BigupBut;
}
- (UIButton *)BigdownBut{
    if (_BigdownBut == nil) {
        _BigdownBut = [[UIButton alloc]init];
        [_BigdownBut addTarget:self action:@selector(downButClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgview addSubview:_BigdownBut];
    }
    return _BigdownBut;
}
- (UILabel *)titleView31
{
    if(_titleView31 ==nil)
    {
        _titleView31 =[[UILabel alloc]init];
        _titleView31.text = @"选择长租有优惠";
        _titleView31.textColor = UIColorFromRGB(MYColor);
        _titleView31.font = [UIFont systemFontOfSize:11];
        [_bgview addSubview: _titleView31];
    }
    return _titleView31;
}
- (UIButton *)changBut{
    if (_changBut == nil) {
        _changBut = [[UIButton alloc]init];
        [_changBut setTitle:@"长租" forState:UIControlStateNormal];
        [_changBut setTitle:@"长租" forState:UIControlStateSelected];
        [_changBut setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateSelected];
        [_changBut setBackgroundImage:[UIImage imageNamed:@"灰框"] forState:UIControlStateNormal];
        [_changBut setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_changBut setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        _changBut.titleLabel.font = [UIFont systemFontOfSize:14];
        _changBut.selected = YES;
        [_changBut addTarget:self action:@selector(changButClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgview addSubview:_changBut];
    }
    return _changBut;
}
- (UIButton *)duanBut{
    if (_duanBut == nil) {
        _duanBut = [[UIButton alloc]init];
        [_duanBut setTitle:@"短租" forState:UIControlStateNormal];
        [_duanBut setTitle:@"短租" forState:UIControlStateSelected];
        [_duanBut setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateSelected];
        [_duanBut setBackgroundImage:[UIImage imageNamed:@"灰框"] forState:UIControlStateNormal];
        [_duanBut setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_duanBut setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        _duanBut.titleLabel.font = [UIFont systemFontOfSize:14];
        _duanBut.selected = NO;
        [_duanBut addTarget:self action:@selector(duanButClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgview addSubview:_duanBut];
    }
    return _duanBut;
}
- (UIImageView *)youView2{
    if (_youView2 == nil) {
        _youView2 = [[UIImageView alloc]init];
        _youView2.image = [UIImage imageNamed:@"chargeback"];
        [_bgview addSubview:_youView2];
    }
    return _youView2;
}
- (UIButton *)timeBut{
    if (_timeBut == nil) {
        _timeBut = [[UIButton alloc]init];
        [_timeBut setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        _timeBut.titleLabel.font = [UIFont systemFontOfSize:14];
        _timeBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_timeBut addTarget:self action:@selector(timeButClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgview addSubview:_timeBut];
    }
    return _timeBut;
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
