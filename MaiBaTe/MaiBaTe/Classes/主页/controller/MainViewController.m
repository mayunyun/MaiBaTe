//
//  MainViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MainViewController.h"
#import "CollectionHeadView.h"
#import "MainTitleTableViewCell.h"
#import "MainTableViewCell.h"
#import "NewAllViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "MyPurseViewController.h"
#import "CarZLViewController.h"
#import "NewXWViewController.h"
#import "AllWuLiuFHViewController.h"
#import "AllWuLiuZHViewController.h"
#import "LoginViewController.h"
#import "YHJlingquViewController.h"
#import "ProvinceViewController.h"
#import "WuLiuSJRZViewController.h"
#import "WuLiuSjrzIngViewController.h"
#import "Reachability.h"
#import "MingXiViewController.h"
#import "NewCarViewController.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,CollectionHeadDelegate>{
    UIButton * _locationBut;
    UIView *statusBarView;
    NSString *_versionUrl;
}
@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)NSMutableArray *dataArr;

@property(nonatomic,strong)AMapLocationManager *locationManager;

@property(nonatomic,strong)CollectionHeadView *collectionView;
@end

@implementation MainViewController
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 20-64, UIScreenW, UIScreenH-20+64)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);

        [self.view addSubview:_tableview];
        
        _collectionView = [[CollectionHeadView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 340*MYWIDTH)];
        _collectionView.delegate = self;
        _collectionView.viewController = self;
        _tableview.tableHeaderView = _collectionView;
        
        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 45)];
        food.backgroundColor = UIColorFromRGB(0xEEEEEE);

        UIView *foodbgview =[[UIView alloc]init];
        foodbgview.backgroundColor = [UIColor whiteColor];
        [food addSubview:foodbgview];
        foodbgview.frame = CGRectMake(10, 0, UIScreenW-20, 15);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:foodbgview.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = foodbgview.bounds;
        maskLayer.path = maskPath.CGPath;
        foodbgview.layer.mask = maskLayer;
        _tableview.tableFooterView = food;
        
        [_tableview registerClass:[MainTitleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MainTitleTableViewCell class])];
        [_tableview registerClass:[MainTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MainTableViewCell class])];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    }
    return _tableview;
    
}
//下拉刷新
- (void)loadNewData{
    [self ajaxCallbak];

    [_collectionView dataHeadView];
    
    [self loadNew];
    [_tableview.mj_header endRefreshing];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setTranslucent:YES];
    self.navigationItem.title = @"";
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIImage *image = [UIImage imageNamed:@"iconfont-touming"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
    self.navigationController.navigationBar.translucent = YES;

    [self setStatusBarBackgroundColor:UIColorFromRGB(0x333333)];
    [self ajaxCallbak];
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [statusBarView removeFromSuperview];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataCity:) name:@"city" object:nil];
    //通知中心注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate =(id)self;
    self.view.backgroundColor = UIColorFromRGB(0xEEEEEE);
    self.navigationItem.leftBarButtonItem = nil;
    [self versionRequest];

    _collectionView = [[CollectionHeadView alloc]initWithFrame:CGRectMake(0, 20, UIScreenW, UIScreenH-20)];
    if (statusbarHeight>20) {
        _collectionView.frame = CGRectMake(0, 44, UIScreenW, UIScreenH-44);
    }
    _collectionView.delegate = self;
    _collectionView.viewController = self;
    [self.view addSubview:_collectionView];
    
    _dataArr = [[NSMutableArray alloc]init];
    [self amapLocationSharedServices];

    //[self tableview];
    //[self loadNew];
    [self navbarBGView];

}
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status==ReachableViaWiFi||status==ReachableViaWWAN) {
        [self amapLocationSharedServices];
        //[self loadNew];

        
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}
- (void)navbarBGView{
    UIImageView *navbar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, UIScreenW, 44)];
    if (statusbarHeight>20) {
        navbar.frame = CGRectMake(0, 44, UIScreenW, 44);
    }
    navbar.userInteractionEnabled = YES;
    navbar.image = [UIImage imageNamed:@"navbarBG"];
    [self.view addSubview:navbar];
    
    UIImage *image = [UIImage imageNamed:@"形状-12"];
    _locationBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locationBut addTarget:self action:@selector(leftToLastViewController) forControlEvents:UIControlEventTouchUpInside];
    [_locationBut setFrame:CGRectMake(0, 0, 120, 40)];
    [_locationBut setTitle:@"济南市" forState:UIControlStateNormal];
    _locationBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [_locationBut setImage:image forState:UIControlStateNormal];
    CGSize size = [_locationBut.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize size1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
    _locationBut.frame = CGRectMake(0, 0, size1.width+25, size1.height);
    [_locationBut setImageEdgeInsets:UIEdgeInsetsMake(0, size1.width+10, 0, 0)];
    [_locationBut setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 10)];

   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBut];

}
- (void)leftToLastViewController{
    ProvinceViewController *provc = [[ProvinceViewController alloc]init];
    [self.navigationController pushViewController:provc animated:YES];
}
- (void)rightToLastViewController{
    [Command isloginRequest:^(bool str) {
        if (str) {
            YHJlingquViewController *lingqu = [[YHJlingquViewController alloc]init];
            [self.navigationController pushViewController:lingqu animated:YES];
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginViewController* vc = [[LoginViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }
    }];
    
}
#pragma 刷新(在这里面发送请求，刷新数据)
- (void)loadNew
{
    
    [self.dataArr removeAllObjects];
    
    //最新动态
    NSString *XWURLStr = @"/mbtwz/index?action=getNews";
    
    [HTNetWorking postWithUrl:XWURLStr refreshCache:YES params:nil success:^(id response) {
        NSArray *Arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];

        NSLog(@">>%@",Arr);
       // NSSLog(@"最新动态%@",Arr[0]);
        if (Arr) {
            [_locationBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            //建立模型
            for (NSDictionary*dic in Arr ) {
                MainModel *model=[[MainModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count>0) {
                [self.tableview dismissNoView];
                
            }else{
                [self.tableview showNoView:nil image:nil certer:CGPointZero];
            }
            [self.tableview reloadData];

        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
    
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArr.count < 8) {
        return _dataArr.count + 1;
    }
    return 8+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 50;
    }
    return 75*MYWIDTH+30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        Class MainTitleClass = [MainTitleTableViewCell class];
        MainTitleTableViewCell *cell = nil;
        
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainTitleClass)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setdata];
        
        return cell;
    }
    Class MainClass = [MainTableViewCell class];
    MainTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainClass)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArr.count) {
        MainModel*model = self.dataArr[indexPath.row-1];
        cell.data = model;
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 0) {
        NewXWViewController *newXW = [[NewXWViewController alloc]init];
        newXW.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newXW animated:YES];
    }else{
        NewAllViewController *newAll = [[NewAllViewController alloc]init];
        newAll.hidesBottomBarWhenPushed = YES;
        newAll.model = self.dataArr[indexPath.row-1];
        newAll.type = 1;
        [self.navigationController pushViewController:newAll animated:YES];
    }
    //NSLog(@"%ld",indexPath.row);
}
- (void)amapLocationSharedServices{
    
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
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode.city);
            [_locationBut setTitle:regeocode.city forState:UIControlStateNormal];
            CGSize size = [_locationBut.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
            // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
            CGSize size1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
            _locationBut.frame = CGRectMake(0, 0, size1.width+25, size1.height);
            [_locationBut setImageEdgeInsets:UIEdgeInsetsMake(0, size1.width+10, 0, 0)];
            [_locationBut setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 10)];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBut];

        }
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ((_tableview.contentOffset.y > 120*MYWIDTH)||_dataArr.count==0) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        [_locationBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [_locationBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

-(void)CollectionHeadBtnHaveString:(NSInteger *)resultString{
    NSLog(@"点击，，，，%li",(long)resultString);
    if (resultString == 0) {
        NewCarViewController *newcar = [[NewCarViewController alloc]init];
        newcar.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newcar animated:YES];
//        [Command isloginRequest:^(bool str) {
//            if (str) {
//                MyPurseViewController *MyPurse = [[MyPurseViewController alloc]init];
//                MyPurse.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:MyPurse animated:YES];
//            }else{
//                jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
//
//                }, @"前往", ^(NSInteger buttonIndex) {
//                    LoginViewController* vc = [[LoginViewController alloc]init];
//                    [self presentViewController:vc animated:YES completion:nil];
//                });
//            }
//        }];
        
    }else if ((int)resultString == 1){
        CarZLViewController *CarZLV = [[CarZLViewController alloc]init];
        CarZLV.city = _locationBut.titleLabel.text;
        CarZLV.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:CarZLV animated:YES];
    }else if ((int)resultString == 2){
        [Command isloginRequest:^(bool str) {
            if (str) {
                AllWuLiuFHViewController *FHVC = [[AllWuLiuFHViewController alloc]init];
                FHVC.city = _locationBut.titleLabel.text;
                FHVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:FHVC animated:YES];
            }else{
                jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                    
                }, @"前往", ^(NSInteger buttonIndex) {
                    LoginViewController* vc = [[LoginViewController alloc]init];
                    [self presentViewController:vc animated:YES completion:nil];
                });
            }
        }];
        
    }else if ((int)resultString == 3){
        
        [Command isloginRequest:^(bool str) {
            if (str) {
                [HTNetWorking postWithUrl:@"/mbtwz/drivercertification?action=checkDriverSPStatus" refreshCache:YES params:nil success:^(id response) {
                    [SVProgressHUD dismiss];
                    
                    NSString* str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                    NSLog(@"%@",str);
                    if (str.length<10) {
                        WuLiuSJRZViewController*ZHVC = [[WuLiuSJRZViewController alloc]init];
                        ZHVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:ZHVC animated:YES];
                    }else if ([str rangeOfString:@"司机已被停用"].location!=NSNotFound){
                        NSString * string = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                        jxt_showAlertOneButton(@"提示", string, @"取消", ^(NSInteger buttonIndex) {
                            
                        });
                    }else{
                        NSArray *Arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                        if ([[Arr[0] objectForKey:@"driver_info_status"] intValue]==0) {//审核中
                            WuLiuSjrzIngViewController*ZHVC = [[WuLiuSjrzIngViewController alloc]init];
                            ZHVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:ZHVC animated:YES];
                        }else if ([[Arr[0] objectForKey:@"driver_info_status"] intValue]==1){//审核通过
                            AllWuLiuZHViewController*ZHVC = [[AllWuLiuZHViewController alloc]init];
                            ZHVC.hidesBottomBarWhenPushed = YES;
                            ZHVC.city = _locationBut.titleLabel.text;
                            [self.navigationController pushViewController:ZHVC animated:YES];
                        }else if ([[Arr[0] objectForKey:@"driver_info_status"] intValue]==2){//审核拒绝
                            WuLiuSjrzIngViewController*ZHVC = [[WuLiuSjrzIngViewController alloc]init];
                            ZHVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:ZHVC animated:YES];
                        }

                    }
                    NSLog(@">>%@",str);
                    
                    
                } fail:^(NSError *error) {
                    [SVProgressHUD dismiss];
                    
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
}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    statusBarView = [[UIView alloc]initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
    if (statusbarHeight>20) {
        statusBarView.frame = CGRectMake(0, -44,    self.view.bounds.size.width, 44);
    }
    statusBarView.backgroundColor = color;
    [self.navigationController.navigationBar addSubview:statusBarView];
}

- (void)ajaxCallbak{
    [Command isloginRequest:^(bool str) {
        if (str) {
            //判断充电状态
            
            NSString *URLStr = @"/mbtwz/wxorder?action=zhengzaichongdian";
            
            [HTNetWorking postWithUrl:[NSString stringWithFormat:@"%@%@",DATA_ADDRESS,URLStr] refreshCache:YES params:nil success:^(id response) {
                [SVProgressHUD dismiss];
                NSString *str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                NSLog(@"充电状态:%@",str);
                
                NSDictionary *dict = @{@"chongdian":[NSString stringWithFormat:@"%@",str]};
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"chongdianzhuangtai" object:nil userInfo:dict];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
            } fail:^(NSError *error) {
                [SVProgressHUD dismiss];
                
            }];
            
            
            //判断有无优惠券
            NSString *youhuiURLStr = @"/mbtwz/WxCoupon?action=getCoupon";
            [HTNetWorking postWithUrl:[NSString stringWithFormat:@"%@%@",DATA_ADDRESS,youhuiURLStr] refreshCache:YES params:nil success:^(id response) {
                [SVProgressHUD dismiss];
                NSArray *Arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"优惠状态:%@",Arr);
                if (Arr.count) {
                    
                    
                    UIButton *TastoVersamento = [UIButton buttonWithType:UIButtonTypeCustom];
                    [TastoVersamento setImage:[UIImage imageNamed:@"WechatIMG440"] forState:UIControlStateNormal];
                    [TastoVersamento addTarget:self action:@selector(rightToLastViewController) forControlEvents:UIControlEventTouchUpInside];
                    [TastoVersamento setFrame:CGRectMake(0, -5, 40, 40)];
                    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:TastoVersamento];
                    
                }else{
                    self.navigationItem.rightBarButtonItem = nil;
                }
    
            } fail:^(NSError *error) {
                [SVProgressHUD dismiss];
                
            }];
            
            //判断有无司机到账
            NSString *daozhangURLStr = @"/mbtwz/wallet?action=checkBeViewed";
            [HTNetWorking postWithUrl:[NSString stringWithFormat:@"%@%@",DATA_ADDRESS,daozhangURLStr] refreshCache:YES params:nil success:^(id response) {
                [SVProgressHUD dismiss];
                NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
                
                if ([str rangeOfString:@"true"].location!=NSNotFound) {
                    [self paySuccess];
                }
                
            } fail:^(NSError *error) {
                [SVProgressHUD dismiss];
                
            }];
        }else{
            self.navigationItem.rightBarButtonItem = nil;

        }
    }];
}
- (void)getLoadDataCity:(NSNotification *)notifiation{
    NSLog(@"%@",notifiation.userInfo);
    [_locationBut setTitle:[NSString stringWithFormat:@"%@",notifiation.userInfo] forState:UIControlStateNormal];
    CGSize size = [_locationBut.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize size1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
    _locationBut.frame = CGRectMake(0, 0, size1.width+25, size1.height);
    [_locationBut setImageEdgeInsets:UIEdgeInsetsMake(0, size1.width+10, 0, 0)];
    [_locationBut setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBut];

}
- (void)paySuccess{
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(50*MYWIDTH, 0, UIScreenW-100*MYWIDTH, 200*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.width/2-44.8*MYWIDTH, 20*MYWIDTH, 89.6*MYWIDTH, 80.6*MYWIDTH)];
    imageview.image = [UIImage imageNamed:@"收款到账"];
    [bgview addSubview:imageview];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview.bottom+10*MYWIDTH, bgview.width, 30*MYWIDTH)];
    lab.text = @"您有一笔收款到账";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = UIColorFromRGB(0x333333);
    [bgview addSubview:lab];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, lab.bottom+5*MYWIDTH, bgview.width, 30*MYWIDTH)];
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"前往我的钱包查看"];
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    //此时如果设置字体颜色要这样
    [tncString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(MYColor)  range:NSMakeRange(0,[tncString length])];
    
    //设置下划线颜色...
    [tncString addAttribute:NSUnderlineColorAttributeName value:UIColorFromRGB(MYColor) range:(NSRange){0,[tncString length]}];
    [but setAttributedTitle:tncString forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:16];
    [but addTarget:self action:@selector(fahuodanButClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:but];
    
    [SMAlert showCustomView:bgview];
}
- (void)fahuodanButClicked:(UIButton *)but{
    [SMAlert hide:NO];
    MingXiViewController *mingxi = [[MingXiViewController alloc]init];
    mingxi.controller = @"mingxi";
    [self.navigationController pushViewController:mingxi animated:YES];
}
#pragma mark -－－－－－－－－－－－－－－ 版本更新－－－－－－－－－－－－－－－－－－－－－－－－－－
//版本更新
- (void)versionRequest{
    /*lxpub/app/version?
     
     action=getVersionInfo
     project=lx
     联祥           applelianxiang
     。。。
     */
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    NSLog(@"app名字%@",appName);
    NSString *urlStr = [NSString stringWithFormat:@"%@:8004/lxpub/app/version?action=getVersionInfo&project=applembt",Ver_Address];
    NSDictionary *parameters = @{@"action":@"getVersionInfo",@"project":[NSString stringWithFormat:@"%@",@"applembt"]};
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:parameters success:^(id response) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSSLog(@"版本信息:%@",dic);
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDic));
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSSLog(@"当前版本号%@",appVersion);
        NSString *version = dic[@"app_version"];
        NSString *nessary = dic[@"app_necessary"];
        _versionUrl = dic[@"app_url"];
        if ([version isEqualToString:appVersion]) {
            //当前版本
        }else if(![version isEqualToString:appVersion]){
            if ([nessary isEqualToString:@"0"]) {
                //不强制更新
                [self showAlert];
            }else if([nessary isEqualToString:@"1"]){
                //强制更新
                [self showAlert1];
            }
        }
        
        
    } fail:^(NSError *error) {
        
    }];
    
}
//选择更新
- (void)showAlert{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                    message:@"发现新版本，是否马上更新？"
                                                   delegate:self
                                          cancelButtonTitle:@"以后再说"
                                          otherButtonTitles:@"下载", nil];
    alert.tag = 10001;
    [alert show];
    
}
//强制更新
- (void)showAlert1{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                    message:@"发现新版本，是否马上更新？"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"下载", nil];
    alert.tag = 10002;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    if (alertView.tag==10001) {
        
        if (buttonIndex==1) {
            NSString *str = [NSString stringWithFormat:@"%@%@",@"itms-services://?action=download-manifest&url=",_versionUrl];
            NSURL *url = [NSURL URLWithString:str];
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }else if (alertView.tag == 10002){
        
        if (buttonIndex == 0) {
            
            NSString *str = [NSString stringWithFormat:@"%@%@",@"itms-services://?action=download-manifest&url=",_versionUrl];
            NSURL *url = [NSURL URLWithString:str];
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }
    
}
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"city" object:nil];
}
@end
