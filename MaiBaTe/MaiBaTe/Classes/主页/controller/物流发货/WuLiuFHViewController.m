//
//  WuLiuFHViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/11/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "WuLiuFHViewController.h"
#import "WLMapViewController.h"
#import "WLPriceMXViewController.h"
#import "WLQROrderViewController.h"
#import "ProvinceViewController.h"
#import "WuLiuFHModel.h"
#import "AllWuliuOrderListVC.h"

@interface WuLiuFHViewController ()<UIScrollViewDelegate,AMapSearchDelegate,UINavigationControllerDelegate>
@property(nonatomic,weak) UIButton *selectedBtn;
@property(nonatomic,strong) NSMutableArray *btns;
@property(nonatomic,strong) UIScrollView *nameScrollView;
@property(nonatomic,strong) UIScrollView *ImageScrollView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property(nonatomic,assign) BOOL up;

@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation WuLiuFHViewController{
    UILabel *_zaizhongNumer;
    UILabel *_chicunNumer;
    UILabel *_tijiNumer;
    UIImageView *_baiNar;
    UILabel *_youhuiNumer;
    CLLocationCoordinate2D _Qlocation;//起点
    CLLocationCoordinate2D _Zlocation;//终点
    //CLLocationCoordinate2D _location;//上个点
    NSString *_QZmileage;//两点之间的距离
}
-(void)hiddenWindow:(NSNotification *)notice{
    UIButton *qiBut = [self.view viewWithTag:3368];
    UIButton *zhongBut = [self.view viewWithTag:3369];
    if ([[notice.userInfo objectForKey:@"hidden"]isEqualToString:@"1"]) {
        [qiBut setTitle:@"按此输入起点" forState:UIControlStateNormal];
        [zhongBut setTitle:@"按此输入目的地" forState:UIControlStateNormal];
        _baiNar.hidden = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

     self.navigationController.delegate=self;
    
    UIImage *image = [UIImage imageNamed:@"baiNat"];
    if (statusbarHeight>20) {
        image = [UIImage imageNamed:@"baiNat_X"];
    }
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0x333333)];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenWindow:) name:@"hiddenWindow" object:nil];
    UIButton *qiBut = [self.view viewWithTag:3368];
    UIButton *zhongBut = [self.view viewWithTag:3369];
    if ([qiBut.titleLabel.text isEqualToString:zhongBut.titleLabel.text]){
        _baiNar.hidden = YES;
    }
    else if ((![qiBut.titleLabel.text isEqualToString:@"按此输入起点"])&&(![zhongBut.titleLabel.text isEqualToString:@"按此输入目的地"])) {
        NSLog(@"起点：%f，%f  终点：%f，%f",_Qlocation.latitude,_Qlocation.longitude,_Zlocation.latitude,_Zlocation.longitude);
        AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];

        navi.requireExtension = YES;
        navi.strategy = 0;
        /* 出发点. */
        navi.origin = [AMapGeoPoint locationWithLatitude:_Qlocation.latitude
                                               longitude:_Qlocation.longitude];
        /* 目的地. */
        navi.destination = [AMapGeoPoint locationWithLatitude:_Zlocation.latitude
                                                    longitude:_Zlocation.longitude];
        [self.search AMapDrivingRouteSearch:navi];

    }else{
        _baiNar.hidden = YES;
    }
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
        _QZmileage = [NSString stringWithFormat:@"%f",distance/1000];
        _baiNar.hidden = NO;
        for (int i=0; i<_btns.count; i++) {
            if (self.selectedBtn==_btns[i]) {
                WuLiuFHModel *model = self.dataArr[i];
                if ([_QZmileage floatValue]>[model.starting_mileage floatValue]) {
                    float mieagePrice = ([_QZmileage floatValue]-[model.starting_mileage floatValue])*[model.mileage_price floatValue];
                    _youhuiNumer.text = [NSString stringWithFormat:@"优惠价 ￥%.2f",[model.starting_price floatValue]+mieagePrice];
                    
                }else{
                    _youhuiNumer.text = [NSString stringWithFormat:@"优惠价 ￥%.2f",[model.starting_price floatValue]];
                    
                }
                [self changeTextColor:_youhuiNumer Txt:_youhuiNumer.text changeTxt:@"优惠价 ￥"];
            }
        }
    }else{
        jxt_showToastTitle(@"路线计算错误，请重新选点", 1);
    }
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

    //_location = CLLocationCoordinate2DMake(0, 0);
    _Qlocation = CLLocationCoordinate2DMake(0, 0);
    _Zlocation = CLLocationCoordinate2DMake(0, 0);

    self.dataArr = [[NSMutableArray alloc]init];
    
    [self loadNew];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataCity:) name:@"city" object:nil];
}
- (void)getLoadDataCity:(NSNotification *)notifiation{
    NSLog(@"%@",notifiation.userInfo);
    self.city = [NSString stringWithFormat:@"%@",notifiation.userInfo];
    [self loadNew];
    
}
#pragma 刷新(在这里面发送请求，刷新数据)
- (void)loadNew
{
    
    [self.dataArr removeAllObjects];
    
    //
    NSString *XWURLStr = @"/mbtwz/logisticssendwz?action=searchCarType";
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"cityname\":\"%@\"}",self.city]};
    [SVProgressHUD showWithStatus:@"正在加载..."];

    [HTNetWorking postWithUrl:XWURLStr refreshCache:YES params:params success:^(id response) {
        [SVProgressHUD dismiss];

        NSArray *Arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@">>%@",Arr);
        if (Arr.count) {
            
            //建立模型
            for (NSDictionary*dic in Arr ) {
                WuLiuFHModel *model=[[WuLiuFHModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [self.dataArr addObject:model];
            }
            [self setWithUIview];

        }else{
            jxt_showAlertOneButton(@"提示", @"该城市暂无发货车辆信息请重新选择城市", @"确定", ^(NSInteger buttonIndex) {
                ProvinceViewController *provc = [[ProvinceViewController alloc]init];
                provc.oneStr = @"5";
                [self.navigationController pushViewController:provc animated:YES];
            });
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
    
    
}


- (void)setWithUIview{
    
    _nameScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, UIScreenW, 60*MYWIDTH)];
    if (statusbarHeight>20) {
        _nameScrollView.frame = CGRectMake(0, 88, UIScreenW, 60*MYWIDTH);
    }
    _nameScrollView.backgroundColor = [UIColor whiteColor];
    _nameScrollView.showsHorizontalScrollIndicator = NO;
    _nameScrollView.showsVerticalScrollIndicator = NO;
//    nameScrollView.pagingEnabled = YES;
    _nameScrollView.contentSize = CGSizeMake((UIScreenW/4)*self.dataArr.count, 0);
    //nameScrollView.bounces = NO;
    [self.view addSubview:_nameScrollView];

    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, _nameScrollView.bottom, UIScreenW, 0.5)];
    xian.backgroundColor = UIColorFromRGB(MYColor);
    [self.view addSubview:xian];
    
    self.ImageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, xian.bottom, UIScreenW, 130*MYWIDTH)];
    self.ImageScrollView.backgroundColor = [UIColor whiteColor];
    self.ImageScrollView.showsHorizontalScrollIndicator = NO;
    self.ImageScrollView.showsVerticalScrollIndicator = NO;
    self.ImageScrollView.pagingEnabled = YES;
    self.ImageScrollView.contentSize = CGSizeMake(UIScreenW*self.dataArr.count, 130*MYWIDTH);
    self.ImageScrollView.bounces = NO;
    self.ImageScrollView.delegate = self;
    [self.view addSubview:self.ImageScrollView];
    
    for (int i = 0; i<self.dataArr.count; i++) {
        WuLiuFHModel *model = self.dataArr[i];
        
        UIButton *carName = [[UIButton alloc]initWithFrame:CGRectMake((UIScreenW/4)*i, 15*MYWIDTH, UIScreenW/4, 45*MYWIDTH)];
        [carName setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [carName setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [carName setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateSelected];
        [carName setTitle:model.car_type forState:UIControlStateNormal];
        [carName setTitle:model.car_type forState:UIControlStateSelected];
        carName.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
        carName.tag = i;
        [carName addTarget:self action:@selector(carNameButClick:) forControlEvents:UIControlEventTouchUpInside];
        if(self.btns.count==0)
        {
            [self carNameButClick:carName];
        }
        [self.btns addObject:carName];
        [_nameScrollView addSubview:carName];
        
        UIImageView * carimage = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW/2-120*MYWIDTH+UIScreenW*i, 10*MYWIDTH, 240*MYWIDTH, 110*MYWIDTH)];
        NSString *imageStr = [NSString stringWithFormat:@"%@/%@%@",PHOTO_ADDRESS,model.folder,model.autoname];
        [carimage sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"icon_noting_face"]];
        [self.ImageScrollView addSubview:carimage];
        
    }

    UIButton *zuoBut = [[UIButton alloc]initWithFrame:CGRectMake(20*MYWIDTH, xian.bottom+50*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
    [zuoBut setImage:[UIImage imageNamed:@"zuojiantou_1"] forState:UIControlStateNormal];
    zuoBut.tag = 1101;
    //zuoBut.hidden = YES;
    [zuoBut addTarget:self action:@selector(zuoButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zuoBut];
    
    UIButton *youBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW - 50*MYWIDTH, xian.bottom+50*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
    [youBut setImage:[UIImage imageNamed:@"youjiantou_1"] forState:UIControlStateNormal];
    youBut.tag = 1102;
    if (self.dataArr.count==1) {
        youBut.hidden = YES;
    }
    [youBut addTarget:self action:@selector(youButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:youBut];
    //
    UIView *bgview1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.ImageScrollView.bottom, UIScreenW, 90*MYWIDTH)];
    bgview1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview1];
    
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(UIScreenW/3-20*MYWIDTH, 0, 1, 60*MYWIDTH)];
    xian1.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgview1 addSubview:xian1];
    
    UILabel *zaizhong = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian1.top, xian1.left-15*MYWIDTH, 20*MYWIDTH)];
    zaizhong.text = @"载重";
    zaizhong.textAlignment = NSTextAlignmentCenter;
    zaizhong.textColor = UIColorFromRGB(0x888888);
    zaizhong.font = [UIFont systemFontOfSize:12];
    [bgview1 addSubview:zaizhong];
    
    WuLiuFHModel *model = self.dataArr[0];

    _zaizhongNumer = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, zaizhong.bottom+10*MYWIDTH, xian1.left-15*MYWIDTH, 30*MYWIDTH)];
    _zaizhongNumer.text = [NSString stringWithFormat:@"%@",model.car_load];
    _zaizhongNumer.textAlignment = NSTextAlignmentCenter;
    _zaizhongNumer.textColor = UIColorFromRGB(0x333333);
    _zaizhongNumer.font = [UIFont systemFontOfSize:16];
    [bgview1 addSubview:_zaizhongNumer];
    
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(UIScreenW*2/3+20*MYWIDTH, 0, 1, 60*MYWIDTH)];
    xian2.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgview1 addSubview:xian2];
    
    UILabel *chicun = [[UILabel alloc]initWithFrame:CGRectMake(xian1.right, xian1.top, xian2.left-xian1.right, 20*MYWIDTH)];
    chicun.text = @"长*宽*高";
    chicun.textAlignment = NSTextAlignmentCenter;
    chicun.textColor = UIColorFromRGB(0x888888);
    chicun.font = [UIFont systemFontOfSize:12];
    [bgview1 addSubview:chicun];
    
    _chicunNumer = [[UILabel alloc]initWithFrame:CGRectMake(xian1.right, _zaizhongNumer.top, xian2.left-xian1.right, _zaizhongNumer.height)];
    _chicunNumer.textAlignment = NSTextAlignmentCenter;
    _chicunNumer.text = [NSString stringWithFormat:@"%@",model.car_size];
    _chicunNumer.textColor = UIColorFromRGB(0x333333);
    _chicunNumer.font = [UIFont systemFontOfSize:16];
    [bgview1 addSubview:_chicunNumer];
    
    UILabel *tiji = [[UILabel alloc]initWithFrame:CGRectMake(xian2.right, xian1.top, UIScreenW-15*MYWIDTH-xian2.right, 20*MYWIDTH)];
    tiji.text = @"载货体积";
    tiji.textAlignment = NSTextAlignmentCenter;
    tiji.textColor = UIColorFromRGB(0x888888);
    tiji.font = [UIFont systemFontOfSize:12];
    [bgview1 addSubview:tiji];
    
    _tijiNumer = [[UILabel alloc]initWithFrame:CGRectMake(xian2.right, _zaizhongNumer.top, UIScreenW-15*MYWIDTH - xian2.right, _zaizhongNumer.height)];
    _tijiNumer.text = [NSString stringWithFormat:@"%@",model.car_volume];
    _tijiNumer.textAlignment = NSTextAlignmentCenter;
    _tijiNumer.textColor = UIColorFromRGB(0x333333);
    _tijiNumer.font = [UIFont systemFontOfSize:16];
    [bgview1 addSubview:_tijiNumer];
    //
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, bgview1.bottom+15*MYWIDTH, UIScreenW-30*MYWIDTH, 120*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.layer.cornerRadius = 10;
    [self.view addSubview:bgview];
    
    UIImageView * xianimage = [[UIImageView alloc]initWithFrame:CGRectMake(29*MYWIDTH, 40*MYWIDTH, 2, 40*MYWIDTH)];
    xianimage.image = [UIImage imageNamed:@"竖虚线"];
    [bgview addSubview:xianimage];
    
    UIImageView * greenimage = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH, 25*MYWIDTH)];
    greenimage.image = [UIImage imageNamed:@"定位绿"];
    [bgview addSubview:greenimage];
    
    UIImageView * redimage = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, 80*MYWIDTH, 20*MYWIDTH, 25*MYWIDTH)];
    redimage.image = [UIImage imageNamed:@"定位红"];
    [bgview addSubview:redimage];

    UIView *xian3 = [[UIView alloc]initWithFrame:CGRectMake(60*MYWIDTH, 60*MYWIDTH, bgview.width-80*MYWIDTH, 1)];
    xian3.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgview addSubview:xian3];
    
    UIButton *qidainBut = [[UIButton alloc]initWithFrame:CGRectMake(xian3.left, 0, xian3.width, 60*MYWIDTH)];
    [qidainBut setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [qidainBut setTitle:@"按此输入起点" forState:UIControlStateNormal];
    qidainBut.titleLabel.lineBreakMode = 0;
    qidainBut.tag = 3368;
    qidainBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [qidainBut addTarget:self action:@selector(qidainButClick:) forControlEvents:UIControlEventTouchUpInside];
    qidainBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [bgview addSubview:qidainBut];
    
    UIButton *zhongdainBut = [[UIButton alloc]initWithFrame:CGRectMake(xian3.left, xian3.bottom, xian3.width, 60*MYWIDTH)];
    [zhongdainBut setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [zhongdainBut setTitle:@"按此输入目的地" forState:UIControlStateNormal];
    zhongdainBut.titleLabel.lineBreakMode = 0;
    zhongdainBut.tag = 3369;
    zhongdainBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [zhongdainBut addTarget:self action:@selector(zhongdainButClick:) forControlEvents:UIControlEventTouchUpInside];
    zhongdainBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [bgview addSubview:zhongdainBut];
    
    UIButton *newBut = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bottom-55*MYWIDTH, UIScreenW*2/3, 55*MYWIDTH)];
    newBut.backgroundColor = UIColorFromRGB(MYColor);
    [newBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newBut setTitle:@"现在用车" forState:UIControlStateNormal];
    newBut.titleLabel.font = [UIFont systemFontOfSize:20];
    [newBut addTarget:self action:@selector(newButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newBut];
    
    UIButton *timeBut = [[UIButton alloc]initWithFrame:CGRectMake(newBut.right, self.view.bottom-55*MYWIDTH, UIScreenW/3, 55*MYWIDTH)];
    timeBut.backgroundColor = UIColorFromRGB(0xEB6100);
    [timeBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [timeBut setTitle:@"预约" forState:UIControlStateNormal];
    [timeBut setImage:[UIImage imageNamed:@"预约表"] forState:UIControlStateNormal];
    timeBut.titleLabel.font = [UIFont systemFontOfSize:20];
    [timeBut addTarget:self action:@selector(timeButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timeBut];
    
    _baiNar = [[UIImageView alloc]initWithFrame:CGRectMake(0, newBut.top-60*MYWIDTH, UIScreenW, 60*MYWIDTH)];
    _baiNar.image = [UIImage imageNamed:@"白Bar"];
    _baiNar.userInteractionEnabled = YES;
    [self.view addSubview:_baiNar];
    
    _youhuiNumer = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 60*MYWIDTH)];
    _youhuiNumer.textColor = UIColorFromRGB(0x333333);
    _youhuiNumer.font = [UIFont systemFontOfSize:18];
    _youhuiNumer.textAlignment = NSTextAlignmentCenter;
    _youhuiNumer.text = @"优惠价 ￥0";
    [self changeTextColor:_youhuiNumer Txt:_youhuiNumer.text changeTxt:@"优惠价 ￥"];
    [_baiNar addSubview:_youhuiNumer];
    
    UIButton *mingxiBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW-90*MYWIDTH, 17.5*MYWIDTH, 80*MYWIDTH, 25*MYWIDTH)];
    mingxiBut.backgroundColor = [UIColor whiteColor];
    [mingxiBut setTitleColor:UIColorFromRGB(MYColor) forState:UIControlStateNormal];
    [mingxiBut setTitle:@"价格明细" forState:UIControlStateNormal];
    mingxiBut.titleLabel.font = [UIFont systemFontOfSize:12];
    [mingxiBut addTarget:self action:@selector(mingxiButClick) forControlEvents:UIControlEventTouchUpInside];
    mingxiBut.layer.cornerRadius = mingxiBut.height*0.5;
    mingxiBut.layer.borderColor = UIColorFromRGB(MYColor).CGColor;//设置边框颜色
    mingxiBut.layer.borderWidth = 1.0f;//设置边框颜色
    [_baiNar addSubview:mingxiBut];
    _baiNar.hidden = YES;

}
//改变某字符串的颜色
- (void)changeTextColor:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
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
-(void)mingxiButClick{
    WLPriceMXViewController *price = [[WLPriceMXViewController alloc]init];
    price.city = self.city;
    price.dataArr = self.dataArr;
    price.zongMileage = [NSString stringWithFormat:@"%.2f",[_QZmileage floatValue]];
    for (int i=0; i<_btns.count; i++) {
        if (self.selectedBtn==_btns[i]) {
            price.model = self.dataArr[i];
            if ([_QZmileage floatValue]>[price.model.starting_mileage floatValue]) {
                float mieagePrice = ([_QZmileage floatValue]-[price.model.starting_mileage floatValue])*[price.model.mileage_price floatValue];
                price.zongPrice = [NSString stringWithFormat:@"%.2f",[price.model.starting_price floatValue]+mieagePrice];
                
            }else{
                price.zongPrice = [NSString stringWithFormat:@"%@",price.model.starting_price];
                
            }
        }
    }
    [self.navigationController pushViewController:price animated:YES];
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
- (void)newButClick:(UIButton *)but{
    [Command isloginRequest:^(bool str) {
        if (str) {
            UIButton *qiBut = [self.view viewWithTag:3368];
            UIButton *zhongBut = [self.view viewWithTag:3369];
            if ([qiBut.titleLabel.text isEqualToString:@"按此输入起点"]) {
                jxt_showToastTitle(@"请选择起点", 1);
            }
            else if ([zhongBut.titleLabel.text isEqualToString:@"按此输入目的地"]){
                jxt_showToastTitle(@"请选择目的地", 1);
            }
            else if ([qiBut.titleLabel.text isEqualToString:zhongBut.titleLabel.text]){
                jxt_showToastTitle(@"起点和目的地选择不能一致", 1);
            }
            else{
                WLQROrderViewController *qrOrder = [[WLQROrderViewController alloc]init];
                qrOrder.city = self.city;
                qrOrder.qiAddress = qiBut.titleLabel.text;
                qrOrder.zhongAddress = zhongBut.titleLabel.text;
                qrOrder.Qlocation = _Qlocation;
                qrOrder.Zlocation = _Zlocation;
                qrOrder.zongMileage = [NSString stringWithFormat:@"%.2f",[_QZmileage floatValue]];
                qrOrder.dataArr = self.dataArr;
                for (int i=0; i<_btns.count; i++) {
                    if (self.selectedBtn==_btns[i]) {
                        qrOrder.model = self.dataArr[i];
                        if ([_QZmileage floatValue]>[qrOrder.model.starting_mileage floatValue]) {
                            float mieagePrice = ([_QZmileage floatValue]-[qrOrder.model.starting_mileage floatValue])*[qrOrder.model.mileage_price floatValue];
                            qrOrder.zongPrice = [NSString stringWithFormat:@"%.2f",[qrOrder.model.starting_price floatValue]+mieagePrice];
                            
                        }else{
                            qrOrder.zongPrice = [NSString stringWithFormat:@"%@",qrOrder.model.starting_price];
                            
                        }
                    }
                }
                [self.navigationController pushViewController:qrOrder animated:YES];
            }
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginViewController* vc = [[LoginViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }
    }];
    
    
    
}
- (void)timeButClick:(UIButton *)but{
    [Command isloginRequest:^(bool str) {
        if (str) {
            UIButton *qiBut = [self.view viewWithTag:3368];
            UIButton *zhongBut = [self.view viewWithTag:3369];
            if ([qiBut.titleLabel.text isEqualToString:@"按此输入起点"]) {
                jxt_showToastTitle(@"请选择起点", 1);
                return;
            }else if ([zhongBut.titleLabel.text isEqualToString:@"按此输入目的地"]){
                jxt_showToastTitle(@"请选择目的地", 1);
                return;
            }
            else if ([qiBut.titleLabel.text isEqualToString:zhongBut.titleLabel.text]){
                jxt_showToastTitle(@"起点和目的地选择不能一致", 1);
                return;
            }
            __weak typeof(self) weakSelf = self;
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *now = [NSDate date];
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
            NSDate *startDate = [calendar dateFromComponents:components];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            
            NSMutableArray *year = [[NSMutableArray alloc]init];
            for (int i=0; i<30; i++) {
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
                WLQROrderViewController *qrOrder = [[WLQROrderViewController alloc]init];
                NSString *hourstr = selectValue[1];
                hourstr = [hourstr substringToIndex:hourstr.length-1];
                if ([hourstr intValue]<10) {
                    hourstr = [NSString stringWithFormat:@"0%@",hourstr];
                }else{
                    hourstr = [NSString stringWithFormat:@"%@",hourstr];
                }
                
                NSString *minstr = selectValue[2];
                minstr = [minstr substringToIndex:minstr.length-1];
                
                qrOrder.time = [NSString stringWithFormat:@"%@ %@:%@",selectValue[0],hourstr,minstr];
                
                qrOrder.city = self.city;
                qrOrder.qiAddress = qiBut.titleLabel.text;
                qrOrder.zhongAddress = zhongBut.titleLabel.text;
                qrOrder.Qlocation = _Qlocation;
                qrOrder.Zlocation = _Zlocation;
                qrOrder.zongMileage = [NSString stringWithFormat:@"%.2f",[_QZmileage floatValue]];
                qrOrder.dataArr = self.dataArr;
                for (int i=0; i<_btns.count; i++) {
                    if (self.selectedBtn==_btns[i]) {
                        qrOrder.model = self.dataArr[i];
                        if ([_QZmileage floatValue]>[qrOrder.model.starting_mileage floatValue]) {
                            float mieagePrice = ([_QZmileage floatValue]-[qrOrder.model.starting_mileage floatValue])*[qrOrder.model.mileage_price floatValue];
                            qrOrder.zongPrice = [NSString stringWithFormat:@"%.2f",[qrOrder.model.starting_price floatValue]+mieagePrice];
                            
                        }else{
                            qrOrder.zongPrice = [NSString stringWithFormat:@"%@",qrOrder.model.starting_price];
                            
                        }
                    }
                }
                [self.navigationController pushViewController:qrOrder animated:YES];
            }];
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginViewController* vc = [[LoginViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }
    }];
    
    
}
- (void)carNameButClick:(UIButton *)but{
    WuLiuFHModel *model = self.dataArr[but.tag];
    _zaizhongNumer.text = [NSString stringWithFormat:@"%@",model.car_load];
    _chicunNumer.text = [NSString stringWithFormat:@"%@",model.car_size];
    _tijiNumer.text = [NSString stringWithFormat:@"%@",model.car_volume];

    if ([_QZmileage floatValue]>[model.starting_mileage floatValue]) {
        float mieagePrice = ([_QZmileage floatValue]-[model.starting_mileage floatValue])*[model.mileage_price floatValue];
        _youhuiNumer.text = [NSString stringWithFormat:@"优惠价 ￥%.2f",[model.starting_price floatValue]+mieagePrice];
        
    }else{
        _youhuiNumer.text = [NSString stringWithFormat:@"优惠价 ￥%.2f",[model.starting_price floatValue]];
        
    }
    if (_youhuiNumer) {
        [self changeTextColor:_youhuiNumer Txt:_youhuiNumer.text changeTxt:@"优惠价 ￥"];
    }
    

    self.selectedBtn.selected = NO;
    self.selectedBtn.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    
    but.selected = YES;
    but.titleLabel.font = [UIFont systemFontOfSize:15*MYWIDTH];
    self.selectedBtn = but;
    [self.ImageScrollView setContentOffset:CGPointMake(but.tag * UIScreenW, 0) animated:YES];
    _up = NO;

    if (self.dataArr.count>4) {
        if (self.dataArr.count - but.tag == 1){
            [_nameScrollView setContentOffset:CGPointMake(UIScreenW/4*(but.tag-3), 0) animated:YES];
            
        }else if (but.tag>2) {
            [_nameScrollView setContentOffset:CGPointMake(UIScreenW/4*(but.tag-2), 0) animated:YES];
            
        }else{
            [_nameScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }else{
        [_nameScrollView setContentOffset:CGPointMake(0, 0) animated:YES];

    }
    
//    UIButton *zuoBut = [self.view viewWithTag:1101];
//    UIButton *youBut = [self.view viewWithTag:1102];
//
//    if (but.tag==0) {
//        zuoBut.hidden = YES;
//    }else if (but.tag==self.dataArr.count-1){
//        youBut.hidden = YES;
//    }else{
//        zuoBut.hidden = NO;
//        youBut.hidden = NO;
//    }
}
- (void)zuoButClick:(UIButton *)but{
    NSInteger integer = self.ImageScrollView.contentOffset.x / UIScreenW;
    NSLog(@"%zd",integer);
    if (integer>0) {
        _up = YES;
        [self.ImageScrollView setContentOffset:CGPointMake((integer-1) * UIScreenW, 0) animated:YES];
    }
}
- (void)youButClick:(UIButton *)but{
    NSInteger integer = self.ImageScrollView.contentOffset.x / UIScreenW;
    NSLog(@"%zd",integer);
    if (integer<self.dataArr.count-1) {
        _up = YES;
        [self.ImageScrollView setContentOffset:CGPointMake((integer+1) * UIScreenW, 0) animated:YES];
    }
}
//开始拖拽视图

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;

{
    
    _up = YES;

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.view endEditing:YES];
    
    
    if(scrollView==self.ImageScrollView)
    {
        if (_up) {
            NSInteger integer = self.ImageScrollView.contentOffset.x / UIScreenW;

            WuLiuFHModel *model = self.dataArr[integer];
            _zaizhongNumer.text = [NSString stringWithFormat:@"%@",model.car_load];
            _chicunNumer.text = [NSString stringWithFormat:@"%@",model.car_size];
            _tijiNumer.text = [NSString stringWithFormat:@"%@",model.car_volume];
            
            if ([_QZmileage floatValue]>[model.starting_mileage floatValue]) {
                float mieagePrice = ([_QZmileage floatValue]-[model.starting_mileage floatValue])*[model.mileage_price floatValue];
                _youhuiNumer.text = [NSString stringWithFormat:@"优惠价 ￥%.2f",[model.starting_price floatValue]+mieagePrice];
                
            }else{
                _youhuiNumer.text = [NSString stringWithFormat:@"优惠价 ￥%.2f",[model.starting_price floatValue]];
                
            }
            [self changeTextColor:_youhuiNumer Txt:_youhuiNumer.text changeTxt:@"优惠价 ￥"];

            self.selectedBtn.selected = NO;
            self.selectedBtn.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
            UIButton *btn = self.btns[integer];
            btn.selected = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:15*MYWIDTH];
            self.selectedBtn = btn;
            if (self.dataArr.count>4) {
                if (_dataArr.count - integer == 1){
                    [_nameScrollView setContentOffset:CGPointMake(UIScreenW/4*(integer-3), 0) animated:YES];
                    
                }else if (integer>2) {
                    [_nameScrollView setContentOffset:CGPointMake(UIScreenW/4*(integer-2), 0) animated:YES];
                    
                }else{
                    [_nameScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                }
            }else{
                [_nameScrollView setContentOffset:CGPointMake(0, 0) animated:YES];

            }
//            UIButton *zuoBut = [self.view viewWithTag:1101];
//            UIButton *youBut = [self.view viewWithTag:1102];
//
//            if (integer==0) {
//                zuoBut.hidden = YES;
//            }else if (integer==self.dataArr.count-1){
//                youBut.hidden = YES;
//            }else{
//                zuoBut.hidden = NO;
//                youBut.hidden = NO;
//            }
        }
        
        
    }
}
- (NSMutableArray *)btns
{
    if(_btns==nil)
    {
        _btns =[NSMutableArray array];
    }
    return _btns;
}
- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated{
    if ([[viewController class] isSubclassOfClass:[AllWuliuOrderListVC class]]) {
        UIButton *qiBut = [self.view viewWithTag:3368];
        UIButton *zhongBut = [self.view viewWithTag:3369];
        [qiBut setTitle:@"按此输入起点" forState:UIControlStateNormal];
        [zhongBut setTitle:@"按此输入目的地" forState:UIControlStateNormal];
    }
    if (![[viewController class]isSubclassOfClass:[self class]]) {
        
    }
    
}

@end
