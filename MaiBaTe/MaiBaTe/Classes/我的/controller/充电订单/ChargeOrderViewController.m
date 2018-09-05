//
//  ChargeOrderViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ChargeOrderViewController.h"
#import "ChargingViewTableViewCell.h"
#import "ChargingModel.h"
#import "ChargeDetailsViewController.h"
#import "MBTTabBarController.h"
#import "CarNumerModel.h"
#import "ChargeSouSuoViewController.h"
@interface ChargeOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *_createtime;
    NSString *_endtime;
}
@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *totalArr;


@end

@implementation ChargeOrderViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"NarBg"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}
//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}


- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 35*MYWIDTH, UIScreenW, UIScreenH-35*MYWIDTH)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_tableview];
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 15)];
        _tableview.tableHeaderView = head;
        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 20)];
        _tableview.tableFooterView = food;
        [_tableview registerNib:[UINib nibWithNibName:@"ChargingViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChargingViewTableViewCell"];
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

    }
    return _tableview;
    
}
//下拉刷新
- (void)loadNewData{

    [self loadNew];
    [self dataCarCharge];
    [_tableview.mj_header endRefreshing];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArr = [[NSMutableArray alloc]init];
    _totalArr = [[NSMutableArray alloc]init];

//    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
//
//    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"账单Nar.png"]];
//    titleImage.frame = CGRectMake(5, 3, 17, 19);
//    [titleView addSubview:titleImage];
//
//    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 75, 25)];
//    titleLab.text = @"充电订单";
//    titleLab.textColor = [UIColor whiteColor];
//    titleLab.font = [UIFont systemFontOfSize:17];
//    titleLab.textAlignment = NSTextAlignmentCenter;
//    [titleView addSubview:titleLab];
    
    self.navigationItem.title = @"充电订单";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"搜索"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarViewController:)];
    [self.navigationItem.rightBarButtonItem setTintColor:NavBarItemColor];
    
    [self tableview];
    [self loadNew];
    [self dataCarCharge];
}
- (void)setChargeOrderHeaderView{
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, NavBarHeight-2, UIScreenW, 35*MYWIDTH)];
    bgview.backgroundColor = UIColorFromRGB(0x999999);
    [self.view addSubview:bgview];
    
    UILabel *totalcount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, UIScreenW/2, 35*MYWIDTH)];
    totalcount.text = @"总度数:0°";
    totalcount.font = [UIFont systemFontOfSize:13];
    totalcount.textColor = [UIColor whiteColor];
    totalcount.textAlignment = NSTextAlignmentCenter;
    [bgview addSubview:totalcount];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(UIScreenW/2, 4, 1, 35*MYWIDTH-8)];
    xian.backgroundColor = [UIColor whiteColor];
    [bgview addSubview:xian];
    
    UILabel *totalrealmoney = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW/2+1, 0, UIScreenW/2, 35*MYWIDTH)];
    totalrealmoney.text = @"总金额:0元";
    totalrealmoney.font = [UIFont systemFontOfSize:13];
    totalrealmoney.textColor = [UIColor whiteColor];
    totalrealmoney.textAlignment = NSTextAlignmentCenter;
    [bgview addSubview:totalrealmoney];

    if (_totalArr.count) {
        CarNumerModel *model = _totalArr[0];
        NSLog(@">>>>%@",model.totalcount);
        totalcount.text = [NSString stringWithFormat:@"总度数:%@°",model.totalcount];
        totalrealmoney.text = [NSString stringWithFormat:@"总金额:%.2f元",[model.totalrealmoney floatValue]];
        if ([[NSString stringWithFormat:@"%@",model.totalcount] isEqualToString:@"(null)"]) {
            totalcount.text = @"总度数:0°";
        }
        if ([[NSString stringWithFormat:@"%@",model.totalrealmoney] isEqualToString:@"(null)"]) {
            totalrealmoney.text = @"总金额:0元";
        }
    }
}
#pragma 在这里面请求数据
- (void)loadNew
{

    [_dataArr removeAllObjects];
    // 获得网络管理单例对象
    NSDictionary* data = nil;
    if (_createtime!=nil) {
        data = @{@"params":[NSString stringWithFormat:@"{\"createtimeGE\":\"%@\",\"createtimeLE\":\"\"}",_createtime]};
    }
    if (_endtime!=nil) {
        data = @{@"params":[NSString stringWithFormat:@"{\"createtimeGE\":\"\",\"createtimeLE\":\"%@\"}",_endtime]};
        if (_createtime!=nil) {
            data = @{@"params":[NSString stringWithFormat:@"{\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\"}",_createtime,_endtime]};
        }
    }
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSString *URLStr = @"/mbtwz/wxorder?action=getOrderList";
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:data success:^(id response) {
        [SVProgressHUD dismiss];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"我的订单%@",arr);
        //建立模型
        for (NSDictionary*dic in arr ) {
            ChargingModel *model=[[ChargingModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            //追加数据
            [self.dataArr addObject:model];
        }
        if (self.dataArr.count>0) {
            [self.tableview dismissNoView];
            [self.tableview reloadData];
            
        }else{
            [self.tableview reloadData];
            [self.tableview showNoView:nil image:nil certer:CGPointZero];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
- (void)dataCarCharge{
    [_totalArr removeAllObjects];

    //充电总度数
    NSDictionary* data = @{@"data":@"{\"createtimeGE\":\"\",\"createtimeLE\":\"\"}"};
    if (_createtime!=nil) {
        data = @{@"data":[NSString stringWithFormat:@"{\"createtimeGE\":\"%@\",\"createtimeLE\":\"\"}",_createtime]};
    }
    if (_endtime!=nil) {
        data = @{@"data":[NSString stringWithFormat:@"{\"createtimeGE\":\"\",\"createtimeLE\":\"%@\"}",_endtime]};
        if (_createtime!=nil) {
            data = @{@"data":[NSString stringWithFormat:@"{\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\"}",_createtime,_endtime]};
        }
    }
    NSString *URLStrNum = @"/mbtwz/wxorder?action=getSumzongdianliangandjine";
    [HTNetWorking postWithUrl:URLStrNum refreshCache:YES params:data success:^(id response) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if (dic!=nil) {
            CarNumerModel *model=[[CarNumerModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            //追加数据
            [_totalArr addObject:model];
            [self setChargeOrderHeaderView];
        }
        
        
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ChargingViewTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ChargingViewTableViewCell"];
    if (!cell) {
        cell=[[ChargingViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChargingViewTableViewCell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count>0) {
        ChargingModel*model=self.dataArr[indexPath.row];
        cell.data = model;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChargeDetailsViewController *charDVC = [[ChargeDetailsViewController alloc]init];
    charDVC.model = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:charDVC animated:YES];
    
    NSLog(@"%ld",indexPath.row);
}

- (void)backToLastViewController:(UIButton *)button{
    if (_type==2) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        kKeyWindow.rootViewController = nil;
        kKeyWindow.rootViewController =[[MBTTabBarController alloc]init];
        [kKeyWindow makeKeyAndVisible];
    }
}
- (void)rightBarViewController:(UIButton *)but{
    ChargeSouSuoViewController *sousuo = [[ChargeSouSuoViewController alloc]init];
    void(^aBlock)(NSString *createtime,NSString *endtime) = ^(NSString *createtime,NSString *endtime){
        _createtime = createtime;
        _endtime = endtime;
        [self dataCarCharge];
        [self loadNew];
    };
    sousuo.block = aBlock;
    [self.navigationController pushViewController:sousuo animated:YES];
}

@end
