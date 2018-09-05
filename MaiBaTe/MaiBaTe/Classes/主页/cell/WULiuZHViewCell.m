//
//  WULiuZHViewCell.m
//  MaiBaTe
//
//  Created by LONG on 2018/1/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WULiuZHViewCell.h"
#import "WuLiuZHDetailsViewController.h"
#import "CarTypeZHDetailsViewController.h"
#import "CarTypeZHViewController.h"
#import "WULiuZHViewController.h"

@interface WULiuZHViewCell()

@property(nonatomic,strong) UIView *bgview;//背景
@property(nonatomic,strong) UIImageView *iconView;//头像
@property(nonatomic,strong) UILabel *titleView;//标题
@property(nonatomic,strong) UILabel *timeView;//时间
@property(nonatomic,strong) UIView *xianView;//线
@property(nonatomic,strong) UIButton *phoneView;//电话
@property(nonatomic,strong) UIButton *bigphoneView;//电话
@property(nonatomic,strong) UIView *xianView1;//线

@property(nonatomic,strong) UIImageView *qiView;//起点
@property(nonatomic,strong) UILabel *qiLab;//
@property(nonatomic,strong) UIImageView *xuxianView;//虚线
@property(nonatomic,strong) UIImageView *zhongView;//终点
@property(nonatomic,strong) UILabel *zhongLab;//
@property(nonatomic,strong) UIView *xianView2;//线

@property(nonatomic,strong) UIView *xianView3;//竖线
@property(nonatomic,strong) UILabel *chexiangView;//车型
@property(nonatomic,strong) UILabel *CarTypeView;//
@property(nonatomic,strong) UILabel *choulaoView;//酬劳
@property(nonatomic,strong) UILabel *priceView;//
@property(nonatomic,strong) UIView *xianView4;//线

@property(nonatomic,strong) UIImageView *juliView;//距离
@property(nonatomic,strong) UILabel *juliLab;

@property(nonatomic,strong) UIButton *xiangqingBut;//查看详情


@end

@implementation WULiuZHViewCell
- (void)setwithDataModel:(WuLiuZHModel *)dataModel locationStr:(CLLocationCoordinate2D)location
{
    self.dataModel = dataModel;
    UIView *contentView = self.contentView;
    CGFloat margin = 10*MYWIDTH;
    
    //设置各控件的frame以及data
    //背景
    _bgview.sd_layout
    .leftSpaceToView(contentView, 1.5*margin)
    .topSpaceToView(contentView, 0.8*margin)
    .rightSpaceToView(contentView, 1.5*margin)
    .bottomSpaceToView(contentView, 0.8*margin);
    
    _iconView.sd_layout
    .leftSpaceToView(_bgview, 1.3*margin)
    .topSpaceToView(_bgview, 0.8*margin)
    .widthIs(24*MYWIDTH)
    .heightIs(24*MYWIDTH);
    
    _titleView.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_bgview)
    .heightIs(40*MYWIDTH)
    .widthIs(100*MYWIDTH);
    
    _phoneView.sd_layout
    .topSpaceToView(_bgview, 1.2*margin)
    .rightSpaceToView(_bgview, 1.2*margin)
    .heightIs(16*MYWIDTH)
    .widthIs(16*MYWIDTH);
    
    _bigphoneView.sd_layout
    .topSpaceToView(_bgview, 0)
    .rightSpaceToView(_bgview, 0)
    .heightIs(40*MYWIDTH)
    .widthIs(40*MYWIDTH);
    
    _xianView.sd_layout
    .topSpaceToView(_bgview, 0.8*margin)
    .rightSpaceToView(_phoneView, 0.8*margin)
    .widthIs(1)
    .heightIs(24*MYWIDTH);
    
    _timeView.sd_layout
    .topEqualToView(_bgview)
    .rightSpaceToView(_xianView, 0.8*margin)
    .leftSpaceToView(_titleView, 0.8*margin)
    .heightIs(40*MYWIDTH);
    
    _xianView1.sd_layout
    .topSpaceToView(_titleView, 0)
    .rightSpaceToView(_bgview, 0)
    .leftSpaceToView(_bgview, 0)
    .heightIs(1);
    
    _qiView.sd_layout
    .leftSpaceToView(_bgview, 1.8*margin)
    .topSpaceToView(_xianView1, 1.5*margin)
    .widthIs(14*MYWIDTH)
    .heightIs(18*MYWIDTH);
    
    _zhongView.sd_layout
    .leftSpaceToView(_bgview, 1.8*margin)
    .topSpaceToView(_qiView, 3.2*margin)
    .widthIs(14*MYWIDTH)
    .heightIs(18*MYWIDTH);
    
    _xuxianView.sd_layout
    .leftSpaceToView(_bgview, 2.5*margin)
    .topSpaceToView(_qiView, 0)
    .widthIs(1)
    .heightIs(3.2*margin);
    
    _qiLab.sd_layout
    .leftSpaceToView(_qiView, 1.5*margin)
    .topEqualToView(_xianView1)
    .rightSpaceToView(_bgview, 1.5*margin)
    .heightIs(5*margin);
    
    _zhongLab.sd_layout
    .leftSpaceToView(_qiView, 1.5*margin)
    .topSpaceToView(_qiLab, 0)
    .rightSpaceToView(_bgview, 1.5*margin)
    .heightIs(5*margin);
    
    _xianView2.sd_layout
    .topSpaceToView(_zhongLab, 0)
    .rightSpaceToView(_bgview, 1.5*margin)
    .leftSpaceToView(_bgview, 1.5*margin)
    .heightIs(1);
    
    _xianView3.sd_layout
    .topSpaceToView(_xianView2, margin)
    .centerXEqualToView(_bgview)
    .heightIs(15*MYWIDTH)
    .widthIs(1);
    
    _chexiangView.sd_layout
    .topEqualToView(_xianView2)
    .leftSpaceToView(_bgview, 1.5*margin)
    .widthIs(7*margin)
    .heightIs(3.5*margin);
    
    _CarTypeView.sd_layout
    .topEqualToView(_xianView2)
    .leftSpaceToView(_chexiangView, 0.5*margin)
    .rightSpaceToView(_xianView3, 0.5*margin)
    .heightIs(3.5*margin);
    
    _choulaoView.sd_layout
    .topEqualToView(_xianView2)
    .leftSpaceToView(_xianView3, 0.5*margin)
    .widthIs(4*margin)
    .heightIs(3.5*margin);
    
    _priceView.sd_layout
    .topEqualToView(_xianView2)
    .leftSpaceToView(_choulaoView, 0.5*margin)
    .rightSpaceToView(_bgview, 1.5*margin)
    .heightIs(3.5*margin);
    
    _xianView4.sd_layout
    .topSpaceToView(_chexiangView, 0)
    .rightSpaceToView(_bgview, 1.5*margin)
    .leftSpaceToView(_bgview, 1.5*margin)
    .heightIs(1);
    
    _juliView.sd_layout
    .topSpaceToView(_xianView4, 1.7*margin)
    .leftSpaceToView(_bgview, 1.8*margin)
    .widthIs(1.3*margin)
    .heightIs(1.6*margin);
    
    _xiangqingBut.sd_layout
    .topSpaceToView(_xianView4, 1.3*margin)
    .rightSpaceToView(_bgview, 1.5*margin)
    .widthIs(91*MYWIDTH)
    .heightIs(24*MYWIDTH);
    
    _juliLab.sd_layout
    .leftSpaceToView(_juliView, 0.8*margin)
    .topSpaceToView(_xianView4, 0)
    .rightSpaceToView(_xiangqingBut, margin)
    .heightIs(5*margin);
    
    NSString *image = [NSString stringWithFormat:@"%@/%@/%@",PHOTO_ADDRESS,_dataModel.folder,_dataModel.autoname];
    //NSLog(@"%@",image);
    [_iconView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _iconView.layer.cornerRadius = 12*MYWIDTH;
    [_iconView.layer setMasksToBounds:YES];
    
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
    
    if ([self.controller isKindOfClass:[CarTypeZHViewController class]]) {
        [_titleView setText:[NSString stringWithFormat:@"%@",_dataModel.owner_link_name]];
        [_timeView setText:[NSString stringWithFormat:@"%@",_dataModel.owner_sendtime]];
        [_qiLab setText:[NSString stringWithFormat:@"%@",_dataModel.owner_address]];
        [_zhongLab setText:[NSString stringWithFormat:@"%@",_dataModel.owner_send_address]];
        [_CarTypeView setText:[NSString stringWithFormat:@"%@",_dataModel.car_type]];
        [_priceView setText:[NSString stringWithFormat:@"￥%.2f",[_dataModel.siji_money floatValue]]];
        
        latitude = [_dataModel.latitude doubleValue];
        longitude = [_dataModel.longitude doubleValue];
    }else{
        [_titleView setText:[NSString stringWithFormat:@"%@",_dataModel.contactname]];
        [_timeView setText:[NSString stringWithFormat:@"%@",_dataModel.appointmenttime]];
        [_qiLab setText:[NSString stringWithFormat:@"%@",_dataModel.startaddress]];
        [_zhongLab setText:[NSString stringWithFormat:@"%@",_dataModel.endaddress]];
        [_CarTypeView setText:[NSString stringWithFormat:@"%@",_dataModel.cargotypenames]];
        [_priceView setText:[NSString stringWithFormat:@"￥%.2f",[_dataModel.siji_money floatValue]]];
        latitude = [_dataModel.startlatitude doubleValue];
        longitude = [_dataModel.startlongitude doubleValue];
    }
    
//    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
//    //1.将两个经纬度点转成投影点
//    MAMapPoint point1 = MAMapPointForCoordinate(centerCoordinate);
//    MAMapPoint point2 = MAMapPointForCoordinate(location);
//    //2.计算距离
//    CLLocationDistance distances = MAMetersBetweenMapPoints(point1,point2);
//    [_juliLab setText:[NSString stringWithFormat:@"起点距您：%.2f公里",distances/1000]];

    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.strategy = 0;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:location.latitude
                                           longitude:location.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:latitude
                                                longitude:longitude];
    [self.search AMapDrivingRouteSearch:navi];
}
/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    if (response.route.paths.count) {
        NSLog(@">>>>>%zd",response.route.paths[0].distance);
        float distance = response.route.paths[0].distance;
        
        [_juliLab setText:[NSString stringWithFormat:@"起点距您：%.2f公里",distance/1000]];

    }else{
        //jxt_showToastTitle(@"路线计算错误，请重新选点", 1);
        [_juliLab setText:[NSString stringWithFormat:@"计算错误"]];
        
    }
}
- (void)phoneViewClick{
    NSString *phoneStr;
    if ([self.controller isKindOfClass:[CarTypeZHViewController class]]) {
        phoneStr = [NSString stringWithFormat:@"%@",self.dataModel.owner_link_phone];
    }else{
        phoneStr = [NSString stringWithFormat:@"%@",self.dataModel.contactphone];
    }

    NSString *phone = [NSString stringWithFormat:@"确定拨打电话：%@",phoneStr];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:phone preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneStr]]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self.controller presentViewController:alertController animated:YES completion:nil];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
        
        [self bgview];
        [self iconView];
        [self titleView];
        [self timeView];
        [self xianView];
        [self phoneView];
        [self bigphoneView];
        [self xianView1];
        
        [self qiView];
        [self qiLab];
        [self xuxianView];
        [self zhongView];
        [self zhongLab];
        [self xianView2];
        
        [self xianView3];
        [self chexiangView];
        [self CarTypeView];
        [self choulaoView];
        [self priceView];
        [self xianView4];
        
        [self juliView];
        [self juliLab];
        [self xiangqingBut];
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
//头像view
- (UIImageView *)iconView
{
    if(_iconView ==nil)
    {
        _iconView =[[UIImageView alloc]init];
        _iconView.layer.cornerRadius = 12*MYWIDTH;
        [_bgview addSubview:_iconView];
    }
    return _iconView;
}
- (UILabel *)titleView
{
    if(_titleView ==nil)
    {
        _titleView =[[UILabel alloc]init];
        _titleView.font = [UIFont systemFontOfSize:15*MYWIDTH];
        _titleView.textColor = UIColorFromRGB(0x333333);
        [_bgview addSubview: _titleView];
    }
    return _titleView;
}
- (UILabel *)timeView
{
    if(_timeView ==nil)
    {
        _timeView =[[UILabel alloc]init];
        _timeView.font = [UIFont systemFontOfSize:13*MYWIDTH];
        _timeView.textColor = UIColorFromRGB(0x333333);
        _timeView.textAlignment = NSTextAlignmentRight;
        [_bgview addSubview: _timeView];
    }
    return _timeView;
}
- (UIView *)xianView
{
    if(_xianView ==nil)
    {
        _xianView =[[UIView alloc]init];
        _xianView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [_bgview addSubview: _xianView];
    }
    return _xianView;
}
- (UIButton *)phoneView{
    if (_phoneView == nil) {
        _phoneView = [[UIButton alloc]init];
        _phoneView.backgroundColor = [UIColor whiteColor];
        [_phoneView setImage:[UIImage imageNamed:@"客服电话"] forState:UIControlStateNormal];
        [_bgview addSubview:_phoneView];
    }
    return _phoneView;
}
- (UIButton *)bigphoneView{
    if (_bigphoneView == nil) {
        _bigphoneView = [[UIButton alloc]init];
        _bigphoneView.backgroundColor = [UIColor clearColor];
        [_bigphoneView addTarget:self action:@selector(phoneViewClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgview addSubview:_bigphoneView];
    }
    return _bigphoneView;
}
- (UIView *)xianView1
{
    if(_xianView1 ==nil)
    {
        _xianView1 =[[UIView alloc]init];
        _xianView1.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [_bgview addSubview: _xianView1];
    }
    return _xianView1;
}

- (UIImageView *)qiView
{
    if(_qiView ==nil)
    {
        _qiView =[[UIImageView alloc]init];
        _qiView.image = [UIImage imageNamed:@"定位绿"];
        [_bgview addSubview:_qiView];
    }
    return _qiView;
}
- (UIImageView *)xuxianView
{
    if(_xuxianView ==nil)
    {
        _xuxianView =[[UIImageView alloc]init];
        _xuxianView.image = [UIImage imageNamed:@"竖虚线"];
        [_bgview addSubview:_xuxianView];
    }
    return _xuxianView;
}
- (UIImageView *)zhongView
{
    if(_zhongView ==nil)
    {
        _zhongView =[[UIImageView alloc]init];
        _zhongView.image = [UIImage imageNamed:@"定位红"];
        [_bgview addSubview:_zhongView];
    }
    return _zhongView;
}
- (UILabel *)qiLab
{
    if(_qiLab ==nil)
    {
        _qiLab =[[UILabel alloc]init];
        _qiLab.font = [UIFont systemFontOfSize:15*MYWIDTH];
        _qiLab.numberOfLines = 0;
        _qiLab.textColor = UIColorFromRGB(0x333333);
        [_bgview addSubview: _qiLab];
    }
    return _qiLab;
}
- (UILabel *)zhongLab
{
    if(_zhongLab ==nil)
    {
        _zhongLab =[[UILabel alloc]init];
        _zhongLab.font = [UIFont systemFontOfSize:15*MYWIDTH];
        _zhongLab.numberOfLines = 0;
        _zhongLab.textColor = UIColorFromRGB(0x333333);
        [_bgview addSubview: _zhongLab];
    }
    return _zhongLab;
}
- (UIView *)xianView2
{
    if(_xianView2 ==nil)
    {
        _xianView2 =[[UIView alloc]init];
        _xianView2.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [_bgview addSubview: _xianView2];
    }
    return _xianView2;
}

- (UIView *)xianView3
{
    if(_xianView3 ==nil)
    {
        _xianView3 =[[UIView alloc]init];
        _xianView3.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [_bgview addSubview: _xianView3];
    }
    return _xianView3;
}
- (UILabel *)chexiangView
{
    if(_chexiangView ==nil)
    {
        _chexiangView =[[UILabel alloc]init];
        _chexiangView.font = [UIFont systemFontOfSize:13*MYWIDTH];
        _chexiangView.textColor = UIColorFromRGB(0x333333);
        if ([self.controller isKindOfClass:[CarTypeZHViewController class]]) {
            _chexiangView.text = @"车型";
        }else{
            _chexiangView.text = @"货物类型";
        }
        [_bgview addSubview: _chexiangView];
    }
    return _chexiangView;
}
- (UILabel *)CarTypeView
{
    if(_CarTypeView ==nil)
    {
        _CarTypeView =[[UILabel alloc]init];
        _CarTypeView.font = [UIFont systemFontOfSize:13*MYWIDTH];
        _CarTypeView.textColor = UIColorFromRGB(0x333333);
        _CarTypeView.textAlignment = NSTextAlignmentRight;
        [_bgview addSubview: _CarTypeView];
    }
    return _CarTypeView;
}
- (UILabel *)choulaoView
{
    if(_choulaoView ==nil)
    {
        _choulaoView =[[UILabel alloc]init];
        _choulaoView.font = [UIFont systemFontOfSize:13*MYWIDTH];
        _choulaoView.textColor = UIColorFromRGB(0x333333);
        if ([self.controller isKindOfClass:[CarTypeZHViewController class]]) {
            _choulaoView.text = @"酬劳";
        }else{
            _choulaoView.text = @"金额";
        }
        [_bgview addSubview: _choulaoView];
    }
    return _choulaoView;
}
- (UILabel *)priceView
{
    if(_priceView ==nil)
    {
        _priceView =[[UILabel alloc]init];
        _priceView.font = [UIFont systemFontOfSize:13*MYWIDTH];
        _priceView.textColor = UIColorFromRGB(0xFFB400);
        _priceView.textAlignment = NSTextAlignmentRight;
        [_bgview addSubview: _priceView];
    }
    return _priceView;
}
- (UIView *)xianView4
{
    if(_xianView4 ==nil)
    {
        _xianView4 =[[UIView alloc]init];
        _xianView4.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [_bgview addSubview: _xianView4];
    }
    return _xianView4;
}

- (UIImageView *)juliView
{
    if(_juliView ==nil)
    {
        _juliView =[[UIImageView alloc]init];
        _juliView.image = [UIImage imageNamed:@"juliaddress"];
        [_bgview addSubview:_juliView];
    }
    return _juliView;
}
- (UILabel *)juliLab
{
    if(_juliLab ==nil)
    {
        _juliLab =[[UILabel alloc]init];
        _juliLab.font = [UIFont systemFontOfSize:13*MYWIDTH];
        _juliLab.textColor = UIColorFromRGB(0x333333);
        [_bgview addSubview: _juliLab];
    }
    return _juliLab;
}
- (UIButton *)xiangqingBut{
    if (_xiangqingBut == nil) {
        _xiangqingBut = [[UIButton alloc]init];
        _xiangqingBut.backgroundColor = UIColorFromRGB(MYColor);
        [_xiangqingBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_xiangqingBut addTarget:self action:@selector(xiangqingButClick) forControlEvents:UIControlEventTouchUpInside];
        [_xiangqingBut setTitle:@"查看详情" forState:UIControlStateNormal];
        _xiangqingBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
        _xiangqingBut.layer.cornerRadius = 5;
        [_bgview addSubview:_xiangqingBut];
    }
    return _xiangqingBut;
}
- (void)xiangqingButClick{
    if ([self.controller isKindOfClass:[CarTypeZHViewController class]]) {
        CarTypeZHDetailsViewController *carType = [[CarTypeZHDetailsViewController alloc]init];
        carType.idstr = _dataModel.id;
        [self.controller.navigationController pushViewController:carType animated:YES];
    }else{
        WuLiuZHDetailsViewController *detailsVC = [[WuLiuZHDetailsViewController alloc]init];
        detailsVC.idstr = _dataModel.id;
        [self.controller.navigationController pushViewController:detailsVC animated:YES];
    }
    
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
