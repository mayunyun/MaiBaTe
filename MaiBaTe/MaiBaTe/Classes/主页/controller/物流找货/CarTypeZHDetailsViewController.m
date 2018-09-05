//
//  CarTypeZHDetailsViewController.m
//  MaiBaTe
//
//  Created by LONG on 2018/4/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CarTypeZHDetailsViewController.h"
#import "AllWuliuOrderListVC.h"

@interface CarTypeZHDetailsViewController ()<UIScrollViewDelegate,AMapSearchDelegate>
@property(nonatomic,strong) UIScrollView *ScrollView;
@property(nonatomic,strong) NSMutableDictionary *Dictionary;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong)UILabel *qiJuLiLab1;
@end

@implementation CarTypeZHDetailsViewController

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
    //self.navigationController.navigationBar.translucent = NO;
    
}

//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //self.navigationController.navigationBar.translucent = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Dictionary = [[NSMutableDictionary alloc]init];
    // Do any additional setup after loading the view.
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"物流找货.png"]];
    titleImage.frame = CGRectMake(5, 3, 17, 19);
    [titleView addSubview:titleImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 75, 25)];
    titleLab.text = @"物流找货";
    titleLab.textColor = UIColorFromRGB(0x333333);
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    [self loadData];
    
}
#pragma 在这里面请求数据
- (void)loadData
{
    //
    NSString *URLStr = @"/mbtwz/find?action=selectLogisticsOrderDetail";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"id\":\"%@\"}",self.idstr]};
    NSSLog(@"参数==%@",params);
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
        
        NSArray* arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        NSSLog(@"zulin%@",arr);
        if (arr.count) {
            self.Dictionary = [[NSMutableDictionary alloc]initWithDictionary:arr[0]];
            
            NSString *URLStr1 = @"/mbtwz/find?action=selectLogisticsOrderDetailServ";
            [HTNetWorking postWithUrl:URLStr1 refreshCache:YES params:params success:^(id response) {
                
                NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                [self.Dictionary setObject:array forKey:@"service"];
                NSSLog(@"zulin%@",array);
                [self setUIBGWithView];
                [self configLocationManager:[[_Dictionary objectForKey:@"latitude"] doubleValue] longitude:[[_Dictionary objectForKey:@"longitude"] doubleValue]];
                
                
            } fail:^(NSError *error) {
                
            }];
        }
        
        
    } fail:^(NSError *error) {
        
    }];
    
    //
    
}

-(void)setUIBGWithView{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in [_Dictionary objectForKey:@"service"]) {
        [arr addObject:[dic objectForKey:@"service_name"]];
        if ([[dic objectForKey:@"owner_service_price"] floatValue]==0) {
            [arr1 addObject:@"免费"];
        }else{
            [arr1 addObject:[NSString stringWithFormat:@"%.2f元",[[dic objectForKey:@"owner_service_price"] floatValue]]];
        }
    }
    //
    self.ScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
    self.ScrollView.backgroundColor = UIColorFromRGB(0xEEEEEE);
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    self.ScrollView.showsVerticalScrollIndicator = NO;
    self.ScrollView.pagingEnabled = YES;
    self.ScrollView.contentSize = CGSizeMake(UIScreenW, 654*MYWIDTH+arr.count*40*MYWIDTH);
    self.ScrollView.bounces = NO;
    self.ScrollView.delegate = self;
    [self.view addSubview:self.ScrollView];
    
    UIView *bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 20*MYWIDTH, UIScreenW, 310*MYWIDTH)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgView1];
    
    UIImageView *iconView =[[UIImageView alloc]initWithFrame:CGRectMake(13*MYWIDTH, 8*MYWIDTH, 24*MYWIDTH, 24*MYWIDTH)];
    iconView.layer.cornerRadius = 12*MYWIDTH;
    [iconView.layer setMasksToBounds:YES];
    NSString *image = [NSString stringWithFormat:@"%@/%@/%@",PHOTO_ADDRESS,[_Dictionary objectForKey:@"folder"],[_Dictionary objectForKey:@"autoname"]];
    [iconView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    [bgView1 addSubview:iconView];
    
    UILabel *titleView =[[UILabel alloc]initWithFrame:CGRectMake(iconView.right+5, 0, 150, 40*MYWIDTH)];
    titleView.font = [UIFont systemFontOfSize:15*MYWIDTH];
    titleView.textColor = UIColorFromRGB(0x333333);
    [titleView setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"owner_link_name"]]];
    [bgView1 addSubview: titleView];
    
    UIButton *phoneView = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW-28*MYWIDTH, 12*MYWIDTH, 16*MYWIDTH, 16*MYWIDTH)];
    phoneView.backgroundColor = [UIColor whiteColor];
    [phoneView setImage:[UIImage imageNamed:@"客服电话"] forState:UIControlStateNormal];
    [bgView1 addSubview:phoneView];
    
    UIButton *bigphoneView = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW-16*MYWIDTH, 0, 40*MYWIDTH, 40*MYWIDTH)];
    bigphoneView.backgroundColor = [UIColor clearColor];
    [bigphoneView addTarget:self action:@selector(phoneViewClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:bigphoneView];
    
    UIView *xianView1 =[[UIView alloc]initWithFrame:CGRectMake(0, 40*MYWIDTH, UIScreenW, 1)];
    xianView1.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView1];
    
    UIImageView *qiView =[[UIImageView alloc]initWithFrame:CGRectMake(18*MYWIDTH, xianView1.bottom+15*MYWIDTH, 14*MYWIDTH, 18*MYWIDTH)];
    qiView.image = [UIImage imageNamed:@"定位绿"];
    [bgView1 addSubview:qiView];
    
    UIImageView *xuxianView =[[UIImageView alloc]initWithFrame:CGRectMake(25*MYWIDTH, qiView.bottom, 1, 32*MYWIDTH)];
    xuxianView.image = [UIImage imageNamed:@"竖虚线"];
    [bgView1 addSubview:xuxianView];
    
    UIImageView *zhongView =[[UIImageView alloc]initWithFrame:CGRectMake(18*MYWIDTH, qiView.bottom+32*MYWIDTH, 14*MYWIDTH, 18*MYWIDTH)];
    zhongView.image = [UIImage imageNamed:@"定位红"];
    [bgView1 addSubview:zhongView];
    
    UILabel *qiLab =[[UILabel alloc]initWithFrame:CGRectMake(qiView.right+15*MYWIDTH, xianView1.bottom, UIScreenW-qiView.right-30*MYWIDTH, 50*MYWIDTH)];
    qiLab.font = [UIFont systemFontOfSize:15*MYWIDTH];
    qiLab.numberOfLines = 0;
    qiLab.textColor = UIColorFromRGB(0x333333);
    [qiLab setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"owner_address"]]];
    [bgView1 addSubview: qiLab];
    
    UILabel *zhongLab =[[UILabel alloc]initWithFrame:CGRectMake(qiView.right+15*MYWIDTH, qiLab.bottom, UIScreenW-qiView.right-30*MYWIDTH, 50*MYWIDTH)];
    zhongLab.font = [UIFont systemFontOfSize:15*MYWIDTH];
    zhongLab.numberOfLines = 0;
    zhongLab.textColor = UIColorFromRGB(0x333333);
    [zhongLab setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"owner_send_address"]]];
    [bgView1 addSubview: zhongLab];
    
    UIView *xianView2 =[[UIView alloc]initWithFrame:CGRectMake(0, zhongLab.bottom, UIScreenW, 1)];
    xianView2.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView2];
    
    UILabel *qiJuLiLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView2.bottom, 100, 40*MYWIDTH)];
    qiJuLiLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    qiJuLiLab.textColor = UIColorFromRGB(0x333333);
    [qiJuLiLab setText:@"货物起点距离"];
    [bgView1 addSubview: qiJuLiLab];
    
    self.qiJuLiLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView2.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
    _qiJuLiLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    _qiJuLiLab1.textColor = UIColorFromRGB(0x333333);
    _qiJuLiLab1.textAlignment = NSTextAlignmentRight;
    [bgView1 addSubview: _qiJuLiLab1];
    
    UIView *xianView3 =[[UIView alloc]initWithFrame:CGRectMake(0, qiJuLiLab.bottom, UIScreenW, 1)];
    xianView3.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView3];
    
    UILabel *typeLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView3.bottom, 100, 40*MYWIDTH)];
    typeLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    typeLab.textColor = UIColorFromRGB(0x333333);
    [typeLab setText:@"用车类型"];
    [bgView1 addSubview: typeLab];
    
    UILabel *typeLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView3.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
    typeLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    typeLab1.textColor = UIColorFromRGB(0x333333);
    typeLab1.textAlignment = NSTextAlignmentRight;
    [typeLab1 setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"car_type"]]];
    [bgView1 addSubview: typeLab1];
    
    UIView *xianView4 =[[UIView alloc]initWithFrame:CGRectMake(0, typeLab.bottom, UIScreenW, 1)];
    xianView4.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView4];
    
    UILabel *timeLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView4.bottom, 100, 40*MYWIDTH)];
    timeLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    timeLab.textColor = UIColorFromRGB(0x333333);
    [timeLab setText:@"用车时间"];
    [bgView1 addSubview: timeLab];
    
    UILabel *timeLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView4.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
    timeLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    timeLab1.textColor = UIColorFromRGB(0x333333);
    timeLab1.textAlignment = NSTextAlignmentRight;
    [timeLab1 setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"owner_sendtime"]]];
    [bgView1 addSubview: timeLab1];
    
    UIView *xianView5 =[[UIView alloc]initWithFrame:CGRectMake(0, timeLab.bottom, UIScreenW, 1)];
    xianView5.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgView1 addSubview: xianView5];
    
    UILabel *ordertimeLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView5.bottom, 100, 40*MYWIDTH)];
    ordertimeLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    ordertimeLab.textColor = UIColorFromRGB(0x333333);
    [ordertimeLab setText:@"订单发布时间"];
    [bgView1 addSubview: ordertimeLab];
    
    UILabel *ordertimeLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView5.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
    ordertimeLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    ordertimeLab1.textColor = UIColorFromRGB(0x333333);
    ordertimeLab1.textAlignment = NSTextAlignmentRight;
    [ordertimeLab1 setText:[NSString stringWithFormat:@"%@",[_Dictionary objectForKey:@"owner_createtime"]]];
    [bgView1 addSubview: ordertimeLab1];
    
    
    
    UIView *bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, bgView1.bottom+12*MYWIDTH, UIScreenW, 45*MYWIDTH+arr.count*40*MYWIDTH)];
    bgView2.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgView2];
    
    UILabel *xuqiuLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 0, 100, 45*MYWIDTH)];
    xuqiuLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    xuqiuLab.textColor = UIColorFromRGB(0x333333);
    [xuqiuLab setText:@"额外需求"];
    [bgView2 addSubview: xuqiuLab];
    
    for (int i=0; i<arr.count; i++) {
        UIView *xianView =[[UIView alloc]initWithFrame:CGRectMake(0, xuqiuLab.bottom+i*40*MYWIDTH, UIScreenW, 1)];
        xianView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [bgView2 addSubview: xianView];
        
        UILabel *Lab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xianView.bottom, 100, 40*MYWIDTH)];
        Lab.font = [UIFont systemFontOfSize:14*MYWIDTH];
        Lab.textColor = UIColorFromRGB(0x333333);
        [Lab setText:arr[i]];
        [bgView2 addSubview: Lab];
        
        UILabel *Lab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, xianView.bottom, UIScreenW-100-30*MYWIDTH, 40*MYWIDTH)];
        Lab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
        Lab1.textColor = UIColorFromRGB(0x333333);
        Lab1.textAlignment = NSTextAlignmentRight;
        [Lab1 setText:[NSString stringWithFormat:@"%@",arr1[i]]];
        [bgView2 addSubview: Lab1];
    }
    
    UIView *bgView3 = [[UIView alloc]initWithFrame:CGRectMake(0, bgView2.bottom+12*MYWIDTH, UIScreenW, 76*MYWIDTH)];
    bgView3.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:bgView3];
    
    UILabel *zongLab =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 0, 100, 76*MYWIDTH)];
    zongLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    zongLab.textColor = UIColorFromRGB(0x333333);
    [zongLab setText:@"总计"];
    [bgView3 addSubview: zongLab];
    
    UILabel *zongLab1 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, 2*MYWIDTH, UIScreenW-100-30*MYWIDTH, 35*MYWIDTH)];
    zongLab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    zongLab1.textColor = UIColorFromRGB(0x333333);
    zongLab1.textAlignment = NSTextAlignmentRight;
    [zongLab1 setText:[NSString stringWithFormat:@"%@公里",[_Dictionary objectForKey:@"total_mileage"]]];
    //[self changeLineSpaceForLabel:zongLab1 WithSpace:5.0];
    [bgView3 addSubview: zongLab1];
    
    UILabel *zongLab2 =[[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH+100, 37*MYWIDTH, UIScreenW-100-30*MYWIDTH, 35*MYWIDTH)];
    zongLab2.font = [UIFont systemFontOfSize:14*MYWIDTH];
    zongLab2.textColor = UIColorFromRGB(0x333333);
    zongLab2.textAlignment = NSTextAlignmentRight;
    [zongLab2 setText:[NSString stringWithFormat:@"%.2f元",[[_Dictionary objectForKey:@"siji_money"] floatValue]]];
    //[self changeLineSpaceForLabel:zongLab1 WithSpace:5.0];
    [bgView3 addSubview: zongLab2];
    
    UIButton *qiangdanBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/2-90*MYWIDTH, bgView3.bottom + 30*MYWIDTH, 180*MYWIDTH, 45*MYWIDTH)];
    qiangdanBut.backgroundColor = UIColorFromRGB(MYColor);
    [qiangdanBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qiangdanBut addTarget:self action:@selector(qiangdanButClick) forControlEvents:UIControlEventTouchUpInside];
    [qiangdanBut setTitle:@"抢单" forState:UIControlStateNormal];
    qiangdanBut.titleLabel.font = [UIFont systemFontOfSize:17*MYWIDTH];
    qiangdanBut.layer.cornerRadius = 5;
    [self.ScrollView addSubview:qiangdanBut];
}
//- (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
//
//    NSString *labelText = label.text;
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:space];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
//    label.attributedText = attributedString;
//    [label sizeToFit];
//
//}

- (void)qiangdanButClick{
    //
    //    jxt_showAlertTwoButton(@"提示", @"您确定进行抢单吗？", @"取消", ^(NSInteger buttonIndex) {
    //
    //    }, @"确定", ^(NSInteger buttonIndex) {
    NSString *URLStr = @"/mbtwz/find?action=updateLogisticsOrderGrabASingle";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"id\":\"%@\"}",self.idstr]};
    NSSLog(@"抢单参数==%@",params);
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
        
        NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
        
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [self paySuccess];
        }else if ([str rangeOfString:@"self"].location!=NSNotFound){
            jxt_showAlertOneButton(@"提示:抢单失败", @"自己不能抢自己的订单", @"确定", ^(NSInteger buttonIndex) {
            });
        }else if ([str rangeOfString:@"berobbed"].location!=NSNotFound){
            jxt_showAlertOneButton(@"提示:抢单失败", @"该订单已被抢", @"确定", ^(NSInteger buttonIndex) {
            });
        }else{
            jxt_showAlertOneButton(@"提示", @"抢单失败", @"确定", ^(NSInteger buttonIndex) {
            });
        }
        
    } fail:^(NSError *error) {
        
    }];
    //});
    
}
- (void)paySuccess{
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(40*MYWIDTH, 0, UIScreenW-80*MYWIDTH, 200*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.width/2-52.5*MYWIDTH, 20*MYWIDTH, 105*MYWIDTH, 70*MYWIDTH)];
    imageview.image = [UIImage imageNamed:@"支付成功"];
    [bgview addSubview:imageview];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview.bottom+18*MYWIDTH, bgview.width, 30*MYWIDTH)];
    lab.text = @"抢单成功";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = UIColorFromRGB(0x333333);
    [bgview addSubview:lab];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, lab.bottom+5*MYWIDTH, bgview.width, 30*MYWIDTH)];
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"点击查看司机接货单"];
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
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
-(void)fahuodanButClicked:(UIButton *)but{
    [SMAlert hide:NO];
    //
    AllWuliuOrderListVC *wuliuOrder = [[AllWuliuOrderListVC alloc]init];
    wuliuOrder.isBack = @"2";
    wuliuOrder.type = @"2";
    [self.navigationController pushViewController:wuliuOrder animated:YES];
    
}
-(void)phoneViewClick{
    NSString *phone = [NSString stringWithFormat:@"确定拨打电话：%@？",[_Dictionary objectForKey:@"owner_link_phone"]];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:phone preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[_Dictionary objectForKey:@"owner_link_phone"]]]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)configLocationManager:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        
        //有无逆地理信息，annotationView的标题显示的字段不一样
        if (regeocode)
        {
            //            CLLocationCoordinate2D locationStr = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
            //
            //            CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
            //            //1.将两个经纬度点转成投影点
            //            MAMapPoint point1 = MAMapPointForCoordinate(centerCoordinate);
            //            MAMapPoint point2 = MAMapPointForCoordinate(locationStr);
            //            //2.计算距离
            //            CLLocationDistance distances = MAMetersBetweenMapPoints(point1,point2);
            //            [_qiJuLiLab1 setText:[NSString stringWithFormat:@"%.2f公里",distances/1000]];
            
            AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
            
            navi.requireExtension = YES;
            navi.strategy = 0;
            /* 出发点. */
            navi.origin = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude
                                                   longitude:location.coordinate.longitude];
            /* 目的地. */
            navi.destination = [AMapGeoPoint locationWithLatitude:latitude
                                                        longitude:longitude];
            [self.search AMapDrivingRouteSearch:navi];
        }
        
    }];
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
        
        [_qiJuLiLab1 setText:[NSString stringWithFormat:@"%.2f公里",distance/1000]];
        
    }else{
        //jxt_showToastTitle(@"路线计算错误，请重新选点", 1);
        [_qiJuLiLab1 setText:[NSString stringWithFormat:@"计算错误"]];
        
    }
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
