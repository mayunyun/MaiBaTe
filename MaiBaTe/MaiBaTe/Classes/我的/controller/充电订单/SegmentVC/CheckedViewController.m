//
//  CheckedViewController.m
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CheckedViewController.h"
#import "UncheckedCell.h"
#import "OrderDetailPassVC.h"
@interface CheckedViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation CheckedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"InfoNotification" object:nil];
    _dataArr = [[NSMutableArray alloc]init];
    [self searchLeaseOrderData];
    
    [self tableview];
}
- (void)InfoNotificationAction:(NSNotification *)notification{
    NSLog(@"---接收到通知---%@",notification.userInfo);
    if (notification.userInfo) {
        _dataArr = notification.userInfo[@"data"];
        if ([_dataArr[0][@"orderstatus"] integerValue] == 1) {
            [_tableview reloadData];
        }
    }else{
        [_dataArr removeAllObjects];
        [self searchLeaseOrderData];
    }
    
}
-(void)searchLeaseOrderData{
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/leaseorderwz?action=searchLeaseOrder"];
    NSDictionary * dic = @{@"orderstatus":@"1"};
    NSDictionary* KCparams = @{@"params":[Command dictionaryToJson:dic]};//
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"搜索租车订单的列表%@",arr);
        [_dataArr addObjectsFromArray:arr];
        [_tableview reloadData];
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH-64) style:UITableViewStyleGrouped];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 0, UIScreenW, UIScreenH-64-34);
            
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    }
    return _tableview;
    
}
//下拉刷新
- (void)loadNewData{
    [_dataArr removeAllObjects];
    [self searchLeaseOrderData];
    [_tableview.mj_header endRefreshing];
    
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 260;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * stringCell = @"UncheckedCell";
    UncheckedCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataDic = _dataArr[indexPath.section];
    cell.bgView.layer.cornerRadius = 8.f;
    cell.bgView.layer.masksToBounds = YES;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderDetailPassVC * vc = [[OrderDetailPassVC alloc]init];
    vc.orderDic = _dataArr[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
