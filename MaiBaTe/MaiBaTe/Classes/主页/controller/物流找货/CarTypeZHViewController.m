//
//  CarTypeZHViewController.m
//  MaiBaTe
//
//  Created by LONG on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CarTypeZHViewController.h"
#import "WULiuZHViewCell.h"
#import "WuLiuZHModel.h"
@interface CarTypeZHViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign)CLLocationCoordinate2D locationStr;

@end

@implementation CarTypeZHViewController
{
    NSInteger _page;
    
}
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
    [self loadNewData];
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
    _dataArr = [[NSMutableArray alloc]init];
    
    [self tableview];
    
}
//下拉刷新
- (void)loadNewData{
    [self.dataArr removeAllObjects];
    _page = 1;
    [self configLocationManager];
    [self loadData];
    [_tableview.mj_header endRefreshing];
    
}
- (void)addUpData{
    _page++;
    [self loadData];
    [_tableview.mj_footer endRefreshing];
}
#pragma 在这里面请求数据
- (void)loadData
{
    //
    NSString *URLStr = @"/mbtwz/find?action=selectLogisticsOrderList";
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"8",@"params":[NSString stringWithFormat:@"{\"city\":\"%@\"}",self.city]};
    NSSLog(@"参数==%@",params);
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
        
        NSDictionary* diction = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        NSSLog(@"zulin%@",diction);
        if ([[diction objectForKey:@"rows"] count]) {
            for (NSDictionary *dic in [diction objectForKey:@"rows"]) {
                //建立模型
                WuLiuZHModel *model=[[WuLiuZHModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [self.dataArr addObject:model];
            }
        }
        if (self.dataArr.count>0) {
            [self.tableview dismissNoView];
        }else{
            [self.tableview showNoView:nil image:nil certer:CGPointZero];
        }
        [self.tableview reloadData];
        
        
    } fail:^(NSError *error) {
        
    }];
}

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH-40)];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 0, UIScreenW, UIScreenH-34-40);
            
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        //        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 40*MYWIDTH)];
        //        _tableview.tableFooterView = food;
        [_tableview registerClass:[WULiuZHViewCell class] forCellReuseIdentifier:NSStringFromClass([WULiuZHViewCell class])];
        
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 243*MYWIDTH;
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addUpData)];
    }
    return _tableview;
    
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 243*MYWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class ZuLinCarClass = [WULiuZHViewCell class];
    WULiuZHViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZuLinCarClass)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =[UIColor clearColor];
    cell.controller = self;
    if (_dataArr.count) {
        NSLog(@"%@",_dataArr);
        WuLiuZHModel *model = _dataArr[indexPath.row];
        [cell setwithDataModel:model locationStr:_locationStr];
    }
    
    return cell;
}
- (void)configLocationManager
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
            self.locationStr = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
            [_tableview reloadData];
        }
        
    }];
}

@end
