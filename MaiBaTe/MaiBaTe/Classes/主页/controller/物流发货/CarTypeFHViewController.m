//
//  CarTypeFHViewController.m
//  MaiBaTe
//
//  Created by LONG on 2018/4/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CarTypeFHViewController.h"
#import "WLMapViewController.h"
#import "MKComposePhotosView.h"
#import "MKMessagePhotoView.h"
#import "SDImageCache.h"
#import "Paydetail.h"
#import "AllWuliuOrderListVC.h"
#import "CarTypeSFBZViewController.h"

@interface CarTypeFHViewController ()<MKMessagePhotoViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    UIView *bgview2;
    UIView *_bgview3;
    
    UIButton *_typeBut;
    UIButton *_heftBut;
    UIButton *_yujiTimeBut;
    
    UITextField *_firstField;
    UITextField *_secondField;
    UITextField *_threeField;
    UITextField *_fourField;
    
    UILabel *_youhuiNumer;
    
    CLLocationCoordinate2D _Qlocation;//起点
    CLLocationCoordinate2D _Zlocation;//终点
    
    UIView *_goodsalicteView;
    UITextField *_goodsField;
    
    NSString *_zongprice;
    NSString *_weightID;
    UIView *bgview;
    NSString *_PayUUid;
    NSString *_ZhiFuPassword;


    // TextView的输入框
    UITextField * jkTextField;
    // 黑色的背景
    UIButton * backBtn;
    // 整个弹出框
    UIView *applyInputView;
    
    //图片数量
    NSUInteger imageInteger;
}
@property(nonatomic,strong) UIScrollView *ScrollView;
@property(nonatomic,strong) NSArray *carGoTypeArr;//货物类型
@property(nonatomic,strong) NSArray *VolMoneysArr;//体积
@property (nonatomic, strong) MKMessagePhotoView *photosView;

@end

@implementation CarTypeFHViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"baiNat"];
    if (statusbarHeight>20) {
        image = [UIImage imageNamed:@"baiNat_X"];
    }
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0x333333)];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imageInteger  = 0;
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"物流发货.png"]];
    titleImage.frame = CGRectMake(5, 3, 17, 19);
    [titleView addSubview:titleImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 75, 25)];
    titleLab.text = @"物流发货";
    titleLab.textColor = UIColorFromRGB(0x333333);
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBaseAliPayTrue:) name:AliPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBaseWXPayTrue:) name:WXPayTrue object:nil];
    
    [self loadNewselectCargotypenames];
    [self loadNewselectVolMoneys];
    [self setWithUIview];
}
- (void)setWithUIview{
    
    self.ScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavBarHeight, UIScreenW, UIScreenH-NavBarHeight-115*MYWIDTH)];
    self.ScrollView.backgroundColor = UIColorFromRGB(0xEEEEEE);
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    self.ScrollView.showsVerticalScrollIndicator = NO;
    self.ScrollView.contentSize = CGSizeMake(0, UIScreenH);
    self.ScrollView.bounces = NO;
    self.ScrollView.delegate = self;
    [self.view addSubview:self.ScrollView];
    
    UIView *bgview1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10*MYWIDTH, UIScreenW, 254*MYWIDTH)];
    bgview1.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgview1];
    
    //起点
    UIImageView * greenimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH,  15*MYWIDTH, 16*MYWIDTH, 20*MYWIDTH)];
    greenimage.image = [UIImage imageNamed:@"定位绿"];
    [bgview1 addSubview:greenimage];
    
    UIImageView * youimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(bgview1.right-23*MYWIDTH, 17.5*MYWIDTH, 13*MYWIDTH, 15*MYWIDTH)];
    youimage1.image = [UIImage imageNamed:@"youjiantou"];
    [bgview1 addSubview:youimage1];
    
    UIButton *qidainBut = [[UIButton alloc]initWithFrame:CGRectMake(greenimage.right+15*MYWIDTH, 0, youimage1.left-greenimage.right-15*MYWIDTH, 50*MYWIDTH)];
    [qidainBut setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [qidainBut setTitle:@"请选择起点" forState:UIControlStateNormal];
    qidainBut.titleLabel.lineBreakMode = 0;
    qidainBut.tag = 3388;
    qidainBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [qidainBut addTarget:self action:@selector(qidainButClick:) forControlEvents:UIControlEventTouchUpInside];
    qidainBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [bgview1 addSubview:qidainBut];
    
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, qidainBut.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian1.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgview1 addSubview:xian1];
    
    UIImageView * youimage2 = [[UIImageView alloc]initWithFrame:CGRectMake(bgview1.right-23*MYWIDTH, xian1.bottom + 17.5*MYWIDTH, 13*MYWIDTH, 15*MYWIDTH)];
    youimage2.image = [UIImage imageNamed:@"youjiantou"];
    [bgview1 addSubview:youimage2];
    //终点
    UIImageView * redimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian1.bottom + 15*MYWIDTH, 16*MYWIDTH, 20*MYWIDTH)];
    redimage.image = [UIImage imageNamed:@"定位红"];
    [bgview1 addSubview:redimage];
    
    UIButton *zhongdainBut = [[UIButton alloc]initWithFrame:CGRectMake(qidainBut.left, xian1.bottom, qidainBut.width, 50*MYWIDTH)];
    [zhongdainBut setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [zhongdainBut setTitle:@"请选择终点" forState:UIControlStateNormal];
    zhongdainBut.titleLabel.lineBreakMode = 0;
    zhongdainBut.tag = 3399;
    zhongdainBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [zhongdainBut addTarget:self action:@selector(zhongdainButClick:) forControlEvents:UIControlEventTouchUpInside];
    zhongdainBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [bgview1 addSubview:zhongdainBut];
    
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, zhongdainBut.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian2.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgview1 addSubview:xian2];
    
    //货物类型
    UIImageView * timeimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian2.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    timeimage.image = [UIImage imageNamed:@"hwlx"];
    [bgview1 addSubview:timeimage];
    
    UILabel *titleLab1 = [[UILabel alloc]initWithFrame:CGRectMake(timeimage.right+10*MYWIDTH, timeimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab1.text = @"货物类型";
    titleLab1.textColor = UIColorFromRGB(0x333333);
    titleLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview1 addSubview:titleLab1];
    
    UIImageView * youimage3 = [[UIImageView alloc]initWithFrame:CGRectMake(bgview1.right-23*MYWIDTH, xian2.bottom + 17.5*MYWIDTH, 13*MYWIDTH, 15*MYWIDTH)];
    youimage3.image = [UIImage imageNamed:@"youjiantou"];
    [bgview1 addSubview:youimage3];
    
    _typeBut = [[UIButton alloc]initWithFrame:CGRectMake(titleLab1.right, xian2.bottom, youimage3.left-titleLab1.right, 50*MYWIDTH)];
    [_typeBut setTitle:@"请选择" forState:UIControlStateNormal];
    _typeBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_typeBut setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    _typeBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [_typeBut addTarget:self action:@selector(goodsTypeButClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview1 addSubview:_typeBut];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _typeBut.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgview1 addSubview:xian];
    
    //体积
    UIImageView * heftimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    heftimage.image = [UIImage imageNamed:@"hwtj"];
    [bgview1 addSubview:heftimage];
    
    UIImageView * youimage4 = [[UIImageView alloc]initWithFrame:CGRectMake(bgview1.right-23*MYWIDTH, xian.bottom + 17.5*MYWIDTH, 13*MYWIDTH, 15*MYWIDTH)];
    youimage4.image = [UIImage imageNamed:@"youjiantou"];
    [bgview1 addSubview:youimage4];
    
    UILabel *titleLab2 = [[UILabel alloc]initWithFrame:CGRectMake(heftimage.right+10*MYWIDTH, heftimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab2.text = @"体积";
    titleLab2.textColor = UIColorFromRGB(0x333333);
    titleLab2.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview1 addSubview:titleLab2];
    
    _heftBut = [[UIButton alloc]initWithFrame:CGRectMake(titleLab2.right, xian.bottom, _typeBut.width, 50*MYWIDTH)];
    [_heftBut setTitle:@"请选择" forState:UIControlStateNormal];
    _heftBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_heftBut setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    _heftBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [_heftBut addTarget:self action:@selector(heftButClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgview1 addSubview:_heftBut];
    
    UIView *xian3 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _heftBut.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian3.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgview1 addSubview:xian3];
    
    
    //预计时间
    UIImageView * yujiTimeimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian3.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    yujiTimeimage.image = [UIImage imageNamed:@"sj"];
    [bgview1 addSubview:yujiTimeimage];
    
    UILabel *titleLab3 = [[UILabel alloc]initWithFrame:CGRectMake(yujiTimeimage.right+10*MYWIDTH, yujiTimeimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab3.text = @"预计时间";
    titleLab3.textColor = UIColorFromRGB(0x333333);
    titleLab3.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview1 addSubview:titleLab3];
    
    _yujiTimeBut = [[UIButton alloc]initWithFrame:CGRectMake(titleLab3.right, xian3.bottom, _heftBut.width, 50*MYWIDTH)];
    [_yujiTimeBut setTitle:@"请选择" forState:UIControlStateNormal];
    _yujiTimeBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_yujiTimeBut setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    _yujiTimeBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [_yujiTimeBut addTarget:self action:@selector(YujitimeButClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgview1 addSubview:_yujiTimeBut];
    
    UIImageView * youimage5 = [[UIImageView alloc]initWithFrame:CGRectMake(bgview1.right-23*MYWIDTH, xian3.bottom + 17.5*MYWIDTH, 13*MYWIDTH, 15*MYWIDTH)];
    youimage5.image = [UIImage imageNamed:@"youjiantou"];
    [bgview1 addSubview:youimage5];
    ////////////////////////////////
    bgview2 = [[UIView alloc]initWithFrame:CGRectMake(0, bgview1.bottom + 10*MYWIDTH, UIScreenW, 152*MYWIDTH)];
    bgview2.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgview2];
    
    UIImageView * shouhuoimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    shouhuoimage.image = [UIImage imageNamed:@"yh"];
    [bgview2 addSubview:shouhuoimage];
    
    UILabel *titleLab4 = [[UILabel alloc]initWithFrame:CGRectMake(timeimage.right+10*MYWIDTH, shouhuoimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab4.text = @"联系人";
    titleLab4.textColor = UIColorFromRGB(0x333333);
    titleLab4.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview2 addSubview:titleLab4];
    
    
    _firstField = [[UITextField alloc]initWithFrame:CGRectMake(qidainBut.left, 0, qidainBut.width, 50*MYWIDTH)];
    _firstField.delegate = self;
    _firstField.placeholder = @"必填";
    _firstField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _firstField.textAlignment = NSTextAlignmentRight;
    _firstField.textColor = UIColorFromRGB(0x333333);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:USENAME]) {
        _firstField.text = [user objectForKey:USENAME];
    }
    [bgview2 addSubview:_firstField];
    [Command placeholderColor:_firstField str:_firstField.placeholder color:UIColorFromRGB(MYColor)];
    
    UIView *xian4 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _firstField.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian4.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgview2 addSubview:xian4];
    
    UIImageView * phoneimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian4.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    phoneimage.image = [UIImage imageNamed:@"dh"];
    [bgview2 addSubview:phoneimage];
    
    UILabel *titleLab5 = [[UILabel alloc]initWithFrame:CGRectMake(timeimage.right+10*MYWIDTH, phoneimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab5.text = @"联系人电话";
    titleLab5.textColor = UIColorFromRGB(0x333333);
    titleLab5.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview2 addSubview:titleLab5];
    
    _secondField = [[UITextField alloc]initWithFrame:CGRectMake(qidainBut.left, xian4.bottom, qidainBut.width, 50*MYWIDTH)];
    _secondField.delegate = self;
    _secondField.placeholder = @"必填";
    _secondField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _secondField.keyboardType = UIKeyboardTypeNumberPad;
    _secondField.textAlignment = NSTextAlignmentRight;
    _secondField.textColor = UIColorFromRGB(0x333333);
    if ([user objectForKey:USERPHONE]) {
        _secondField.text = [user objectForKey:USERPHONE];
    }
    [bgview2 addSubview:_secondField];
    [Command placeholderColor:_secondField str:_secondField.placeholder color:UIColorFromRGB(MYColor)];
    //
    UIView *xian5 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, _secondField.bottom, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
    xian5.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgview2 addSubview:xian5];
    
    UIImageView * loucengimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian5.bottom + 16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    loucengimage.image = [UIImage imageNamed:@"lc"];
    [bgview2 addSubview:loucengimage];
    
    UILabel *titleLab6 = [[UILabel alloc]initWithFrame:CGRectMake(timeimage.right+10*MYWIDTH, loucengimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab6.text = @"楼层及门牌号";
    titleLab6.textColor = UIColorFromRGB(0x333333);
    titleLab6.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [bgview2 addSubview:titleLab6];
    
    _threeField = [[UITextField alloc]initWithFrame:CGRectMake(qidainBut.left, xian5.bottom, qidainBut.width, 50*MYWIDTH)];
    _threeField.delegate = self;
    _threeField.placeholder = @"选填";
    _threeField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _threeField.textAlignment = NSTextAlignmentRight;
    _threeField.textColor = UIColorFromRGB(0x333333);
    [bgview2 addSubview:_threeField];
    [Command placeholderColor:_threeField str:_threeField.placeholder color:UIColorFromRGB(MYColor)];
    
    ////////////////////////////////
    _bgview3 = [[UIView alloc]initWithFrame:CGRectMake(0, bgview2.bottom + 10*MYWIDTH, UIScreenW, 101*MYWIDTH)];
    _bgview3.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:_bgview3];
    
    
    
//    UIView *xian6 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 50*MYWIDTH, bgview1.width-30*MYWIDTH, 1*MYWIDTH)];
//    xian6.backgroundColor = UIColorFromRGBValueValue(0xEEEEEE);
//    [bgview3 addSubview:xian6];
    
    UIImageView * beizhuimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH,  16*MYWIDTH, 18*MYWIDTH, 18*MYWIDTH)];
    beizhuimage.image = [UIImage imageNamed:@"ts.png"];
    [_bgview3 addSubview:beizhuimage];
    
    UILabel *titleLab8 = [[UILabel alloc]initWithFrame:CGRectMake(timeimage.right+10*MYWIDTH, beizhuimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab8.text = @"备注";
    titleLab8.textColor = UIColorFromRGB(0x333333);
    titleLab8.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [_bgview3 addSubview:titleLab8];
    
    _fourField = [[UITextField alloc]initWithFrame:CGRectMake(qidainBut.left, 0, qidainBut.width, 50*MYWIDTH)];
    _fourField.delegate = self;
    _fourField.placeholder = @"点击输入";
    _fourField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _fourField.textAlignment = NSTextAlignmentRight;
    _fourField.textColor = UIColorFromRGB(0x666666);
    [_bgview3 addSubview:_fourField];
    [Command placeholderColor:_fourField str:_fourField.placeholder color:UIColorFromRGB(0x999999)];
    
    UIImageView * huowuimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH,  _fourField.bottom+16*MYWIDTH,18*MYWIDTH, 18*MYWIDTH)];
    huowuimage.image = [UIImage imageNamed:@"tp.png"];
    [_bgview3 addSubview:huowuimage];
    
    UILabel *titleLab9 = [[UILabel alloc]initWithFrame:CGRectMake(timeimage.right+10*MYWIDTH, huowuimage.top, 120*MYWIDTH, 20*MYWIDTH)];
    titleLab9.text = @"上传货物图片";
    titleLab9.textColor = UIColorFromRGB(0x333333);
    titleLab9.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [_bgview3 addSubview:titleLab9];
    
    UIButton *huowuSCBut = [[UIButton alloc]initWithFrame:CGRectMake(titleLab9.right, _fourField.bottom, _heftBut.width, 50*MYWIDTH)];
    [huowuSCBut setTitle:@"添加图片" forState:UIControlStateNormal];
    huowuSCBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [huowuSCBut setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    huowuSCBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [huowuSCBut addTarget:self action:@selector(huowuSCButClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgview3 addSubview:huowuSCBut];
    
    self.ScrollView.contentSize = CGSizeMake(0, _bgview3.bottom+10*MYWIDTH);
    
    ////////////////////////////////////
    UIButton *newBut = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bottom-55*MYWIDTH, UIScreenW, 55*MYWIDTH)];
    newBut.backgroundColor = UIColorFromRGB(MYColor);
    [newBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newBut setTitle:@"现在用车" forState:UIControlStateNormal];
    newBut.titleLabel.font = [UIFont systemFontOfSize:20];
    [newBut addTarget:self action:@selector(newButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newBut];
    
    UIImageView *baiNar = [[UIImageView alloc]initWithFrame:CGRectMake(0, newBut.top-60*MYWIDTH, UIScreenW, 60*MYWIDTH)];
    baiNar.image = [UIImage imageNamed:@"白Bar"];
    baiNar.userInteractionEnabled = YES;
    [self.view addSubview:baiNar];
    
    _youhuiNumer = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 60*MYWIDTH)];
    _youhuiNumer.textColor = UIColorFromRGB(0x333333);
    _youhuiNumer.font = [UIFont systemFontOfSize:18];
    _youhuiNumer.text = [NSString stringWithFormat:@"优惠价 ￥%@",@"0"];
    _youhuiNumer.textAlignment = NSTextAlignmentCenter;
    
    [self changeTextfont:_youhuiNumer Txt:_youhuiNumer.text changeTxt:@"优惠价 ￥"];
    [baiNar addSubview:_youhuiNumer];
    
    UIButton *mingxiBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW-90*MYWIDTH, 17.5*MYWIDTH, 80*MYWIDTH, 25*MYWIDTH)];
    mingxiBut.backgroundColor = [UIColor whiteColor];
    [mingxiBut setTitleColor:UIColorFromRGB(MYColor) forState:UIControlStateNormal];
    [mingxiBut setTitle:@"价格明细" forState:UIControlStateNormal];
    mingxiBut.titleLabel.font = [UIFont systemFontOfSize:12];
    [mingxiBut addTarget:self action:@selector(mingxiButClick) forControlEvents:UIControlEventTouchUpInside];
    mingxiBut.layer.cornerRadius = mingxiBut.height*0.5;
    mingxiBut.layer.borderColor = UIColorFromRGB(MYColor).CGColor;//设置边框颜色
    mingxiBut.layer.borderWidth = 1.0f;//设置边框颜色
    [baiNar addSubview:mingxiBut];
}
- (void)mingxiButClick{
    CarTypeSFBZViewController *mingxi = [[CarTypeSFBZViewController alloc]init];
    [self.navigationController pushViewController:mingxi animated:YES];
}
- (void)newButClick:(UIButton *)but{
    UIButton *qiBut = [self.view viewWithTag:3388];
    UIButton *zhongBut = [self.view viewWithTag:3399];
    if ([qiBut.titleLabel.text isEqualToString:@"请选择起点"]) {
        jxt_showToastTitle(@"请选择起点", 1);
        return;
    }
    if ([zhongBut.titleLabel.text isEqualToString:@"请选择终点"]){
        jxt_showToastTitle(@"请选择终点", 1);
        return;
    }
    if ([qiBut.titleLabel.text isEqualToString:zhongBut.titleLabel.text]){
        jxt_showToastTitle(@"起点和目的地选择不能一致", 1);
        return;
    }
    if ([_typeBut.titleLabel.text isEqualToString:@"请选择"]||[[_typeBut.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        jxt_showToastTitle(@"请选择货物类型", 1);
        return;
    }
    
    if ([_heftBut.titleLabel.text isEqualToString:@"请选择"]){
        jxt_showToastTitle(@"请选择体积", 1);
        return;
    }
    if ([_yujiTimeBut.titleLabel.text isEqualToString:@"请选择"]){
        jxt_showToastTitle(@"请选择预计时间", 1);
        return;
    }
    
    if ([[Command convertNull:_firstField.text] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写联系人姓名", 1);
        return;
    }
    if (_firstField.text.length>30) {
        jxt_showToastTitle(@"联系人姓名最多30字符", 1);
        return;
    }
    if ([[Command convertNull:_secondField.text] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写联系人电话", 1);
        return;
    }
    if (![Command isMobileNumber:[Command convertNull:_secondField.text]]) {
        jxt_showToastTitle(@"请填写正确的联系电话", 1);
        return;
    }
    if (_threeField.text.length>50) {
        jxt_showToastTitle(@"楼层及门牌号最多50字符", 1);
        return;
    }
    if (_fourField.text.length>50) {
        jxt_showToastTitle(@"备注最多50字符", 1);
        return;
    }
    if (imageInteger==0) {
        jxt_showToastTitle(@"请选择货物图片,至少一张", 1);
        return;
    }
    
    NSString *XWURLStr = @"/mbtwz/logisticsgoods?action=addLogisticsGoodsOrder";
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:[NSString stringWithFormat:@"%f,%f",_Qlocation.longitude,_Qlocation.latitude] forKey:@"sposition"];
    [param setValue:[NSString stringWithFormat:@"%f",_Qlocation.longitude] forKey:@"startlongitude"];
    [param setValue:[NSString stringWithFormat:@"%f",_Qlocation.latitude] forKey:@"startlatitude"];
    [param setValue:[NSString stringWithFormat:@"%@",qiBut.titleLabel.text] forKey:@"startaddress"];
    [param setValue:[NSString stringWithFormat:@"%@",zhongBut.titleLabel.text] forKey:@"endaddress"];
    [param setValue:[NSString stringWithFormat:@"%f,%f",_Zlocation.longitude,_Zlocation.latitude] forKey:@"eposition"];
    [param setValue:[NSString stringWithFormat:@"%f",_Zlocation.longitude] forKey:@"endlongitude"];
    [param setValue:[NSString stringWithFormat:@"%f",_Zlocation.latitude] forKey:@"endlatitude"];
    [param setValue:@"" forKey:@"total_mileage"];
    [param setValue:[NSString stringWithFormat:@"%@",_typeBut.titleLabel.text] forKey:@"cargotypenames"];
    [param setValue:[NSString stringWithFormat:@"%@",_weightID] forKey:@"volume"];
    [param setValue:[NSString stringWithFormat:@"%@",_yujiTimeBut.titleLabel.text] forKey:@"appointmenttime"];
    [param setValue:[NSString stringWithFormat:@"%@",_firstField.text] forKey:@"contactname"];
    [param setValue:[NSString stringWithFormat:@"%@",_secondField.text] forKey:@"contactphone"];
    [param setValue:[NSString stringWithFormat:@"%@",_threeField.text] forKey:@"floorhousenumber"];
    [param setValue:[NSString stringWithFormat:@"%@",_fourField.text] forKey:@"remarks"];
    
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:param]};//
    
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    [HTNetWorking postWithUrl:XWURLStr refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];

        if ([[dic objectForKey:@"flag"] intValue]!=200) {
            jxt_showAlertOneButton(@"提示", @"订单提交失败", @"确定", ^(NSInteger buttonIndex) {
            });
        }else{
            
            if ([[dic objectForKey:@"response"] count]>0) {
                _PayUUid = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"response"][0] objectForKey:@"uuid"]];
                NSDictionary *dict = @{@"uuid":[NSString stringWithFormat:@"%@",[[dic objectForKey:@"response"][0] objectForKey:@"uuid"]]};
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"upImageWithData" object:nil userInfo:dict];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [self setSMAlertWithView];
            }
            
        }
        NSLog(@">>%@",dic);
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
    
}
- (void)huowuSCButClick:(UIButton *)but{
    if (!self.photosView)
    {
        //设置图片展示区域
        self.photosView = [[MKMessagePhotoView alloc]initWithFrame:CGRectMake(10*MYWIDTH,101*MYWIDTH,UIScreenW-20*MYWIDTH, 130*MYWIDTH)];
        [_bgview3 addSubview:self.photosView];
        self.photosView.backgroundColor = [UIColor whiteColor];
        self.photosView.delegate = self;
        
        _bgview3.frame = CGRectMake(0, bgview2.bottom + 10*MYWIDTH, UIScreenW, 101*MYWIDTH+130*MYWIDTH+10*MYWIDTH);
        self.ScrollView.contentSize = CGSizeMake(0, _bgview3.bottom+10*MYWIDTH);

    }
    [self.photosView clickAddPhotos:nil];
    
}
- (void)qidainButClick:(UIButton *)but{
    WLMapViewController *map = [[WLMapViewController alloc]init];
    map.type = @"0";
    map.location = _Qlocation;
    [map setQidianBlock:^(NSString *strQD,CLLocationCoordinate2D location) {
        [but setTitle:strQD forState:UIControlStateNormal];
        _Qlocation = location;
        //_location = location;
    }];
    [self.navigationController pushViewController:map animated:YES];
}
- (void)zhongdainButClick:(UIButton *)but{
    WLMapViewController *map = [[WLMapViewController alloc]init];
    map.type = @"1";
    map.location = _Zlocation;
    [map setZhongdianBlock:^(NSString *strZD,CLLocationCoordinate2D location) {
        [but setTitle:strZD forState:UIControlStateNormal];
        _Zlocation = location;
        //_location = location;
    }];
    [self.navigationController pushViewController:map animated:YES];
}
//货物类型弹框
- (void)goodsTypeButClick{
    _goodsalicteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
    _goodsalicteView.backgroundColor = [UIColor clearColor];
    [kKeyWindow addSubview:_goodsalicteView];
    
    UIView *baiBgView = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenH, UIScreenW, 0)];
    baiBgView.backgroundColor = [UIColor whiteColor];
    [_goodsalicteView addSubview:baiBgView];
    
    UIButton *cencleBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60*MYWIDTH, 50*MYWIDTH)];
    [cencleBut setTitle:@"取消" forState:UIControlStateNormal];
    [cencleBut setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    cencleBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [cencleBut addTarget:self action:@selector(goodsCencelClick) forControlEvents:UIControlEventTouchUpInside];
    [baiBgView addSubview:cencleBut];
    
    UIButton *quedingBut = [[UIButton alloc]initWithFrame:CGRectMake(baiBgView.width-60*MYWIDTH, 0, 60*MYWIDTH, 50*MYWIDTH)];
    [quedingBut setTitle:@"确定" forState:UIControlStateNormal];
    [quedingBut setTitleColor:UIColorFromRGB(MYColor) forState:UIControlStateNormal];
    quedingBut.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [quedingBut addTarget:self action:@selector(CargoodsTypeClick) forControlEvents:UIControlEventTouchUpInside];
    [baiBgView addSubview:quedingBut];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 50*MYWIDTH)];
    titleLab.text = @"货物类型";
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:15*MYWIDTH];
    [baiBgView addSubview:titleLab];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 50*MYWIDTH, UIScreenW, 1)];
    xian.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [baiBgView addSubview:xian];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in _carGoTypeArr) {
        [arr addObject:[dic objectForKey:@"cargotypename"]];
    }
    
    float w = (UIScreenW-75*MYWIDTH)/4;
    float dowe = 0;
    for (int i=0; i<arr.count; i++) {
        UIButton *But = [[UIButton alloc]initWithFrame:CGRectMake(15*MYWIDTH+i%4*(w+15*MYWIDTH), xian.bottom + 30*MYWIDTH+i/4*75*MYWIDTH, w, 45*MYWIDTH)];
        [But setTitle:arr[i] forState:UIControlStateNormal];
        [But setTitle:arr[i] forState:UIControlStateSelected];
        [But setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [But setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [But setBackgroundColor:[UIColor whiteColor]];
        But.titleLabel.font = [UIFont systemFontOfSize:15*MYWIDTH];
        But.layer.cornerRadius = 3.0;
        But.layer.borderColor = UIColorFromRGB(0x888888).CGColor;//设置边框颜色
        But.layer.borderWidth = 0.5f;//设置边框颜色
        But.tag = 1255+i;
        [But addTarget:self action:@selector(goodsButClick:) forControlEvents:UIControlEventTouchUpInside];
        [baiBgView addSubview:But];
        
        if (i==arr.count-1) {
            dowe = But.bottom;
        }
    }
    
    UILabel *titleLab1 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, dowe, 80*MYWIDTH, 70*MYWIDTH)];
    titleLab1.text = @"其他类型:";
    titleLab1.textColor = UIColorFromRGB(0x000000);
    titleLab1.textAlignment = NSTextAlignmentLeft;
    titleLab1.font = [UIFont systemFontOfSize:15*MYWIDTH];
    [baiBgView addSubview:titleLab1];
    
    _goodsField = [[UITextField alloc]initWithFrame:CGRectMake(titleLab1.right, dowe+10*MYWIDTH, baiBgView.width-15*MYWIDTH-titleLab1.right, 50*MYWIDTH)];
    _goodsField.delegate = self;
    _goodsField.placeholder = @"最多输入四个字";
    _goodsField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*MYWIDTH];
    _goodsField.textAlignment = NSTextAlignmentRight;
    _goodsField.textColor = UIColorFromRGB(0x000000);
    [baiBgView addSubview:_goodsField];
    [Command placeholderColor:_goodsField str:_goodsField.placeholder color:UIColorFromRGB(0x666666)];
    
    baiBgView.frame = CGRectMake(0, UIScreenH-titleLab1.bottom, UIScreenW, titleLab1.bottom);
    
    UIButton *toumingBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH-baiBgView.height)];
    [toumingBut addTarget:self action:@selector(goodsCencelClick) forControlEvents:UIControlEventTouchUpInside];
    [toumingBut setBackgroundColor:[UIColor blackColor]];
    toumingBut.alpha = 0.5;
    [_goodsalicteView addSubview:toumingBut];
}
- (void)CargoodsTypeClick{
    [_goodsalicteView removeFromSuperview];
    NSString *str = [_goodsField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length>4) {
        jxt_showAlertTitle(@"最多输入四个字");
        return;
    }
    
    NSMutableString *carTypeStr;
    for (int i=0 ; i<_carGoTypeArr.count; i++) {
        UIButton *but = [_goodsalicteView viewWithTag:1255+i];
        if (but.selected) {
            carTypeStr = [NSMutableString stringWithFormat:@"%@,%@",carTypeStr,[_carGoTypeArr[i] objectForKey:@"cargotypename"]];
        }
    }
    [carTypeStr deleteCharactersInRange:NSMakeRange(0, 7)];
    if(![str isEqualToString:@""]){
        carTypeStr = [NSMutableString stringWithFormat:@"%@,%@",carTypeStr,str];
    }
    [_typeBut setTitle:carTypeStr forState:UIControlStateNormal];
}
- (void)goodsButClick:(UIButton *)but{
    
    but.selected = !but.selected;
    if (but.selected) {
        [but setBackgroundColor:UIColorFromRGB(MYColor)];
        but.layer.borderColor = UIColorFromRGB(MYColor).CGColor;//设置边框颜色
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

    }else{
        [but setBackgroundColor:[UIColor whiteColor]];
        but.layer.borderColor = UIColorFromRGB(0x888888).CGColor;//设置边框颜色
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

    }
}
- (void)goodsCencelClick{
    [_goodsalicteView removeFromSuperview];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
- (void)heftButClick:(UIButton *)but{
    //    // 自定义多列字符串
    NSMutableArray *dataSources = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in _VolMoneysArr) {
        [dataSources addObject:[NSString stringWithFormat:@"%@(m³)",[dic objectForKey:@"weightrange"]]];
    }
    __weak typeof(self) weakSelf = self;
    
    [BRStringPickerView showStringPickerWithTitle:@"" dataSource:dataSources defaultSelValue:weakSelf isAutoSelect:NO resultBlock:^(id selectValue) {
        
        NSString *timeStr = [NSString stringWithFormat:@"%@",selectValue];
        [but setTitle:timeStr forState:UIControlStateNormal];
        
        for (NSDictionary *dic in _VolMoneysArr) {
            if ([[NSString stringWithFormat:@"%@(m³)",[dic objectForKey:@"weightrange"]] isEqualToString:selectValue]) {
                _weightID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                _zongprice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"money"]];

                _youhuiNumer.text = [NSString stringWithFormat:@"优惠价 ￥%.2f",[[dic objectForKey:@"money"] floatValue]];
                [self changeTextfont:_youhuiNumer Txt:_youhuiNumer.text changeTxt:@"优惠价 ￥"];
            }
        }
        
        
        
        
    }];
}
- (void)YujitimeButClick:(UIButton *)but{
    __weak typeof(self) weakSelf = self;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDate *startDate = [calendar dateFromComponents:components];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSMutableArray *year = [[NSMutableArray alloc]init];
    [year addObject:[NSString stringWithFormat:@"%@",[formatter stringFromDate:startDate]]];
    
    for (int i=0; i<29; i++) {
        NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
        
        [year addObject:[NSString stringWithFormat:@"%@",[formatter stringFromDate:endDate]]];
        startDate = [formatter dateFromString:[formatter stringFromDate:endDate]];
    }
    NSLog(@"%@",year);
    
    NSMutableArray *day = [[NSMutableArray alloc]init];
    NSString *dayStr;
    for (int i=0; i<24; i++) {
        dayStr = [NSString stringWithFormat:@"%d点",i];
        [day addObject:dayStr];
    }
    
    NSMutableArray *hour = [[NSMutableArray alloc]init];
    NSString *hourStr;
    for (int i=0; i<6; i++) {
        hourStr = [NSString stringWithFormat:@"%d0分",i];
        [hour addObject:hourStr];
    }
    
    //    // 自定义多列字符串
    NSArray *dataSources = @[year,day,hour];
    [BRStringPickerView showStringPickerWithTitle:@"" dataSource:dataSources defaultSelValue:weakSelf isAutoSelect:NO resultBlock:^(id selectValue) {
        
        NSString *hourstr = selectValue[1];
        hourstr = [hourstr substringToIndex:hourstr.length-1];
        if ([hourstr intValue]<10) {
            hourstr = [NSString stringWithFormat:@"0%@",hourstr];
        }else{
            hourstr = [NSString stringWithFormat:@"%@",hourstr];
        }
        
        NSString *minstr = selectValue[2];
        minstr = [minstr substringToIndex:minstr.length-1];
        
        NSString *timeStr = [NSString stringWithFormat:@"%@ %@:%@",selectValue[0],hourstr,minstr];
        
        //当前时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateTime = [formatter stringFromDate:[NSDate date]];
        if ([self dateTimeDifferenceWithStartTime:dateTime endTime:timeStr]==0) {
            jxt_showAlertTitle(@"选择的时间需大于当前时间");
        }else{
            [but setTitle:timeStr forState:UIControlStateNormal];
        }
    }];
}
/**
 * 开始到结束的时间差
 */
- (float)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    if (value<0) {
        value = 0;
    }
    return value / 3600;
}
//改变某字符串
- (void)changeTextfont:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    //    NSString *str =  @"35";
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
        //[str1 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(MYOrange) range:NSMakeRange(location, length)];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(location, length)];
        
        //赋值
        label.attributedText = str1;
    }
}
- (void)loadNewselectCargotypenames{
    //
    NSString *XWURLStr = @"/mbtwz/logisticsgoods?action=selectCargotypenames";
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    [HTNetWorking postWithUrl:XWURLStr refreshCache:YES params:nil success:^(id response) {
        [SVProgressHUD dismiss];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@">>%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            if ([[dic objectForKey:@"response"] count]) {
                _carGoTypeArr = [[NSArray alloc]init];
                _carGoTypeArr = [dic objectForKey:@"response"];
            }
        }
        
    
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
- (void)loadNewselectVolMoneys{
    //
    NSString *XWURLStr = @"/mbtwz/logisticsgoods?action=selectVolMoneys";
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    [HTNetWorking postWithUrl:XWURLStr refreshCache:YES params:nil success:^(id response) {
        [SVProgressHUD dismiss];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@">>%@",dic);
        if ([[dic objectForKey:@"response"] count]) {
            _VolMoneysArr = [[NSArray alloc]init];
            _VolMoneysArr = [dic objectForKey:@"response"];
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
//支付方式弹框
- (void)setSMAlertWithView{
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];
    
    
    bgview = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 0, UIScreenW-60*MYWIDTH, 240*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    for (int i=0; i<2; i++) {
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 80*MYWIDTH+80*MYWIDTH*i, bgview.width-60*MYWIDTH, 1)];
        xian.backgroundColor = UIColorFromRGB(MYLine);
        [bgview addSubview:xian];
    }
    NSArray *imageArr = @[@"单选_选中",@"单选_未选中",@"单选_未选中"];
    for (int i=0; i<imageArr.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(45*MYWIDTH, 30*MYWIDTH+i*80*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
        imageview.image = [UIImage imageNamed:imageArr[i]];
        imageview.tag = 115+i;
        [bgview addSubview:imageview];
    }
    NSArray *imageArr1 = @[@"未标题-5.1",@"未标题-5.2",@"未标题-5.3"];
    for (int i=0; i<imageArr1.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.width/3, 25*MYWIDTH+i*80*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
        imageview.image = [UIImage imageNamed:imageArr1[i]];
        [bgview addSubview:imageview];
    }
    NSArray *titleArr = @[@"支付宝支付",@"微信支付",@"余额支付"];
    for (int i=0; i<titleArr.count; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(bgview.width/2-10, 25*MYWIDTH+i*80*MYWIDTH, 200, 30*MYWIDTH)];
        lab.text = titleArr[i];
        lab.font = [UIFont systemFontOfSize:15*MYWIDTH];
        lab.textColor = UIColorFromRGB(0x333333);
        [bgview addSubview:lab];
    }
    for (int i=0; i<3; i++) {
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, i*80*MYWIDTH, bgview.width, 80*MYWIDTH)];
        but.tag = 550+i;
        [but addTarget:self action:@selector(zhifuButClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:but];
    }
    [SMAlert showCustomView:bgview];
    [SMAlert hideCompletion:^{
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"uuid\":\"%@\"}",_PayUUid]};
        
        [HTNetWorking postWithUrl:@"/mbtwz/logisticsgoods?action=deleteNoPayOrder" refreshCache:YES params:params success:^(id response) {
            NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"取消订单%@",str);
            
            
        } fail:^(NSError *error) {
            
        }];
    }];
}
- (void)zhifuButClicked:(UIButton *)button{
    UIImageView *image = [bgview viewWithTag:115];
    image.image = [UIImage imageNamed:@"单选_未选中"];
    UIImageView *image1 = [bgview viewWithTag:116];
    image1.image = [UIImage imageNamed:@"单选_未选中"];
    UIImageView *image2 = [bgview viewWithTag:117];
    image2.image = [UIImage imageNamed:@"单选_未选中"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",_zongprice);
    if (button.tag == 550) {//支付宝
        UIImageView *image = [bgview viewWithTag:115];
        image.image = [UIImage imageNamed:@"单选_选中"];
        jxt_showAlertTwoButton(@"提示", @"您确定使用支付宝支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            
            //[Paydetail zhiFuBaoname:@"测试" titile:@"测试" price:@"0.1" orderId:[NSString stringWithFormat:@"%@_%@",_PayUUid,[user objectForKey:USERID]] notice:@"3"];
            
            [Paydetail zhiFuBaoname:@"测试" titile:@"测试" price:_zongprice orderId:[NSString stringWithFormat:@"%@_%@",_PayUUid,[user objectForKey:USERID]] notice:@"3"];

        });
        
        
    }else if (button.tag == 551){//微信支付
        UIImageView *image = [bgview viewWithTag:116];
        image.image = [UIImage imageNamed:@"单选_选中"];
        jxt_showAlertTwoButton(@"提示", @"您确定使用微信支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            //[Paydetail wxname:@"麦巴特充值" titile:@"麦巴特充值" price:@"0.1" orderId:[NSString stringWithFormat:@"%@_%@",_PayUUid,[user objectForKey:USERID]] notice:@"3"];
            [Paydetail wxname:@"麦巴特充值" titile:@"麦巴特充值" price:_zongprice orderId:[NSString stringWithFormat:@"%@_%@",_PayUUid,[user objectForKey:USERID]] notice:@"3"];

        });
        
        
    }else if (button.tag == 552){//余额支付
        UIImageView *image = [bgview viewWithTag:117];
        image.image = [UIImage imageNamed:@"单选_选中"];
        jxt_showAlertTwoButton(@"提示", @"您确定使用余额支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            //检查是否设置支付密码
            NSDictionary* password = @{@"data":[NSString stringWithFormat:@"{\"\":\"%@\"}",@""]};
            NSString *passwordURLStr = @"/mbtwz/logisticsgoods?action=checkZhiFuPassword";
            [HTNetWorking postWithUrl:passwordURLStr refreshCache:YES params:password success:^(id response) {
                [SVProgressHUD dismiss];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                
                if ([[dic objectForKey:@"flag"] intValue]==200) {
                    _ZhiFuPassword = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"response"][0] objectForKey:@"paypassword"]];
                    [self createUI];
                    [self pushApplyCase];
                }else{
                    jxt_showAlertOneButton(@"温馨提示", @"请到：个人中心-设置-安全中心-设置支付密码中进行设置", @"确定", ^(NSInteger buttonIndex) {
                        
                    });
                }
                
            } fail:^(NSError *error) {
                [SVProgressHUD dismiss];
            }];
            
            
        });
    }
    
}
-(void)backClicked{
    NSLog(@"终于点击到我了");
}
#pragma mark UI的设置
-(void)createUI{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0,0, UIScreenW,UIScreenH);
    backBtn.backgroundColor = [UIColor cyanColor];
    [backBtn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    backBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    backBtn.alpha = 0.2;
    [window addSubview:backBtn];
    
    
    applyInputView = [[UIView alloc]initWithFrame:CGRectMake(25*MYWIDTH, (UIScreenH-175*MYWIDTH)/2, UIScreenW-50*MYWIDTH, 175*MYWIDTH)];
    applyInputView.alpha = 0;
    applyInputView.backgroundColor = [UIColor whiteColor];
    applyInputView.layer.cornerRadius = 10.f;
    applyInputView.clipsToBounds = NO;
    [window addSubview:applyInputView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20*MYWIDTH, 10*MYWIDTH, UIScreenW-40, 18*MYWIDTH)];
    title.text = @"余额支付";
    title.font = [UIFont systemFontOfSize:16.f*MYWIDTH];
    [applyInputView addSubview:title];
    
    UILabel *lines = [[UILabel alloc]initWithFrame:CGRectMake(0, title.bottom+10*MYWIDTH, applyInputView.width, 1)];
    lines.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [applyInputView addSubview:lines];
    UILabel * tfLabel = [[UILabel alloc]initWithFrame:CGRectMake(24*MYWIDTH, lines.bottom+15*MYWIDTH, applyInputView.width-48*MYWIDTH, 42*MYWIDTH)];
    tfLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tfLabel.userInteractionEnabled = YES;
    [applyInputView addSubview:tfLabel];
    jkTextField = [[UITextField alloc]initWithFrame:CGRectMake(10*MYWIDTH, 8*MYWIDTH, tfLabel.width-20*MYWIDTH,30*MYWIDTH)];
    jkTextField.delegate = self;
    [jkTextField setBorderStyle:UITextBorderStyleNone];
    jkTextField.textColor = TitleBlackCOLOR;
    jkTextField.placeholder = @"输入支付密码";
    jkTextField.secureTextEntry = YES;
    jkTextField.textAlignment = NSTextAlignmentRight;
    jkTextField.font = [UIFont systemFontOfSize:14.f*MYWIDTH];
    [tfLabel addSubview:jkTextField];
    
    CGFloat btnWidth = (applyInputView.width-60*MYWIDTH)/2;
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(20*MYWIDTH, tfLabel.bottom+25*MYWIDTH, btnWidth, 35*MYWIDTH)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16.f*MYWIDTH];
    [sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setBackgroundColor:UIColorFromRGB(0xFFB400)];
    sureButton.layer.cornerRadius = 6.f;
    sureButton.clipsToBounds = YES;
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyInputView addSubview:sureButton];
    
    UIButton *canleButton = [[UIButton alloc]initWithFrame:CGRectMake(sureButton.right+20*MYWIDTH, tfLabel.bottom+25*MYWIDTH, btnWidth, 35*MYWIDTH)];
    [canleButton setTitle:@"取消" forState:UIControlStateNormal];
    [canleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [canleButton setBackgroundColor:UIColorFromRGB(0xCDCDCD)];
    canleButton.titleLabel.font = [UIFont systemFontOfSize:16.f*MYWIDTH];
    canleButton.layer.cornerRadius = 6.f;
    canleButton.clipsToBounds = YES;
    [canleButton addTarget:self action:@selector(canle) forControlEvents:UIControlEventTouchUpInside];
    [applyInputView addSubview:canleButton];
}
#pragma mark 取消
-(void)canle{
    [applyInputView removeFromSuperview];
    [backBtn removeFromSuperview];
}

#pragma mark 确定
-(void)sure{
    [jkTextField resignFirstResponder];
    
    if (![jkTextField.text isEqualToString:_ZhiFuPassword]) {
        jxt_showAlertOneButton(@"温馨提示", @"密码不匹配，请重新确认\n或\n您请到我的-设置-安全中心中进行设置", @"确定", ^(NSInteger buttonIndex) {
            
        });
    }else{
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"uuid\":\"%@\"}",_PayUUid]};
        
        NSLog(@"%@",params);
        [HTNetWorking postWithUrl:@"/mbtwz/logisticsgoods?action=logisticsGoodsPaydo" refreshCache:YES params:params success:^(id response) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            
            if ([[dic objectForKey:@"flag"] intValue]==200) {
                [SMAlert hide:NO];
                [backBtn removeFromSuperview];
                [applyInputView removeFromSuperview];
                [self paySuccess];
            }else{
                jxt_showAlertOneButton(@"提示", [dic objectForKey:@"msg"], @"确定", ^(NSInteger buttonIndex) {
                });
            }
            
            
        } fail:^(NSError *error) {
            
        }];
        
    }
}

#pragma mark 弹出申请框
-(void)pushApplyCase{
    
    [UIView animateWithDuration:0.36f animations:^{
        
        backBtn.alpha = 0.48;
        applyInputView.alpha = 1;
        
    }completion:^(BOOL finished) {
        
    }];
}

- (void)getLoadDataBaseAliPayTrue:(NSNotification *)notice{
    NSLog(@"支付结果》》》》%@",notice.userInfo);
    /*
     {
     result = "{"alipay_trade_app_pay_response":{"code":"10000","msg":"Success","app_id":"2016020201135575","auth_app_id":"2016020201135575","charset":"utf-8","timestamp":"2017-09-11 12:07:04","total_amount":"0.01","trade_no":"2017091121001004730285476459","seller_id":"2088911120626880","out_trade_no":"a259a638a2494216bdad-62"},"sign":"avQ9kA4WQR8XqkDbFUPtNgNtSDV79dKGYo4xfxNClRdXolGr5zvDaRS+3zpECgGK9bQIP1/kkTb/T27S3F7JUxd65aMkMarWECIlu31KYqUBso1HQoIInEh+zU/UzWlQWDQgqlI7bXbAmiSnR5mpXWhiT4k0TrqXoa8UH3WZwLI=","sign_type":"RSA"}";
     resultStatus = "9000";
     memo = ""
     }
     
     {
     result = "";
     resultStatus = "6001";
     memo = "用户中途取消"
     }
     */
    if (notice.userInfo) {
        if ([[notice.userInfo objectForKey:@"resultStatus"] intValue] == 9000 ) {
            [SMAlert hide:NO];
            [self paySuccess];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:[notice.userInfo objectForKey:@"memo"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
}
- (void)getLoadDataBaseWXPayTrue:(NSNotification *)notice{
    [SMAlert hide:NO];
    [self paySuccess];
}
-(void)fahuodanButClicked:(UIButton *)but{
    [SMAlert hide:NO];
    //
    AllWuliuOrderListVC *wuliuOrder = [[AllWuliuOrderListVC alloc]init];
    wuliuOrder.isBack = @"2";
    wuliuOrder.type = @"1";
    [self.navigationController pushViewController:wuliuOrder animated:YES];
}



- (void)paySuccess{
    [self.photosView removeAllObjectsImage];
    [self upDataviewP];
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(40*MYWIDTH, 0, UIScreenW-80*MYWIDTH, 200*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.width/2-52.5*MYWIDTH, 20*MYWIDTH, 105*MYWIDTH, 70*MYWIDTH)];
    imageview.image = [UIImage imageNamed:@"支付成功"];
    [bgview addSubview:imageview];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview.bottom+18*MYWIDTH, bgview.width, 30*MYWIDTH)];
    lab.text = @"支付成功";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = UIColorFromRGB(0x333333);
    [bgview addSubview:lab];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, lab.bottom+5*MYWIDTH, bgview.width, 30*MYWIDTH)];
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"点击查看物流发货单"];
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    //此时如果设置字体颜色要这样
    [tncString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(MYColor)  range:NSMakeRange(0,[tncString length])];
    
    //设置下划线颜色...
    [tncString addAttribute:NSUnderlineColorAttributeName value:UIColorFromRGB(MYColor) range:(NSRange){0,[tncString length]}];
    [but setAttributedTitle:tncString forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    [but addTarget:self action:@selector(fahuodanButClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:but];
    
    [SMAlert showCustomView:bgview];
    [SMAlert hideCompletion:^{
        
        
    }];
}
- (void)upDataviewP{
    UIButton *qiBut = [self.view viewWithTag:3388];
    UIButton *zhongBut = [self.view viewWithTag:3399];
    [qiBut setTitle:@"请选择起点" forState:UIControlStateNormal];
    [zhongBut setTitle:@"请选择终点" forState:UIControlStateNormal];
    [_typeBut setTitle:@"请选择" forState:UIControlStateNormal];
    [_heftBut setTitle:@"请选择" forState:UIControlStateNormal];
    [_yujiTimeBut setTitle:@"请选择" forState:UIControlStateNormal];
    [self.photosView removeFromSuperview];
    _bgview3.frame = CGRectMake(0, bgview2.bottom + 10*MYWIDTH, UIScreenW, 101*MYWIDTH);
    self.ScrollView.contentSize = CGSizeMake(0, _bgview3.bottom+10*MYWIDTH);
    _youhuiNumer.text = [NSString stringWithFormat:@"优惠价 ￥%@",@"0"];
    _zongprice = @"0";
    _weightID = @"";
    _PayUUid = @"";
    _Qlocation.latitude = 0.00;
    _Qlocation.longitude = 0.00;
    _Zlocation.latitude = 0.00;
    _Zlocation.longitude = 0.00;
}
//实现代理方法，相册
-(void)addPicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
}

//相机📷
-(void)addUIImagePicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
}
- (void)upDataUIImageArr:(NSInteger)integer{
    imageInteger = integer;
}


//以下两个代理方法可以防止键盘遮挡textview
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    [UIView animateWithDuration:0.5f animations:^{
        if (textField==_goodsField){
            
            kKeyWindow.frame = CGRectMake(0, -UIScreenH/3-70*MYWIDTH, UIScreenW, UIScreenH);
        }
        
    }];
    
}
//完成编辑的时候下移回来（只要把offset重新设为0就行了）
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3f animations:^{
        kKeyWindow.frame = CGRectMake(0, 0, UIScreenW, UIScreenH);
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
