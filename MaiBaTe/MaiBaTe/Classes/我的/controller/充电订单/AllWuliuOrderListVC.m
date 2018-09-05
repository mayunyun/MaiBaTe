//
//  AllWuliuOrderListVC.m
//  MaiBaTe
//
//  Created by 钱龙 on 2018/1/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AllWuliuOrderListVC.h"
#import "WuliuFaHuoCell.h"
#import "GetCarInfoView.h"
#import "HomeTableHeaderView.h"
#import "WuliuOrderDetail.h"
#import "SearchWuliuOrderVC.h"
#import "DriverGetOrderCell.h"
#import "DriverOrderDetailVC.h"
#import "WuliuOrderModel.h"
#import "AllWuLiuOrderViewController.h"
#import "CarTypeFHViewController.h"
#import "AllWuLiuZHViewController.h"

@interface AllWuliuOrderListVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)GetCarInfoView * gHeadView;
@property (nonatomic,strong)HomeTableHeaderView * HeadView;
@property (nonatomic,strong)NSString * isPost;
@end

@implementation AllWuliuOrderListVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
    if (![_isBack isEqualToString:@"1"]) {
        [self loadNewData];
    }else{
        [self changeData];
    }
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeData:) name:@"InfoNotification" object:nil];
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
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
}
-(void)changeData{
    
    if ([self.type isEqualToString:@"1"]) {
        [_dataArr removeAllObjects];
        for (NSDictionary *dic in self.arr) {
            WuliuOrderModel *model=[[WuliuOrderModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];

            [_dataArr addObject:model];
        }
        _dataArray = nil;
    }else{
        [_dataArray removeAllObjects];
        for (NSDictionary *dic in self.arr) {
            WuliuOrderModel *model=[[WuliuOrderModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];

            [_dataArray addObject:model];
        }
        _dataArr = nil;
    }
    [_tableview reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"物流订单Nar.png"]];
    titleImage.frame = CGRectMake(5, 3, 17, 19);
    [titleView addSubview:titleImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 75, 25)];
    titleLab.text = @"物流订单";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    self.navigationItem.titleView = titleView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"1.3"] style:UIBarButtonItemStylePlain target:self action:@selector(rightToLastViewController)];
    [self.navigationItem.rightBarButtonItem setTintColor:UIColorFromRGB(0xFFFFFF)];
    
    _dataArr = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    [self tableview];

}
//下拉刷新
- (void)loadNewData{
    
    
    if ([self.type isEqualToString:@"1"]) {
        [self searchWuliuOrderData];
    }else{
        [self searchDriverWuliuOrderData];
    }
    [_tableview.mj_header endRefreshing];
    
}
- (void)backToLastViewController:(UIButton *)button{
    if ([self.isBack isEqualToString:@"2"]) {
        NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
    }else if([self.isBack isEqualToString:@"1"]){
        for (UIViewController * controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[AllWuLiuOrderViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }else if ([controller isKindOfClass:[CarTypeFHViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)searchDriverWuliuOrderData{
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticsgoods?action=searchPersonOrderJH"];
    NSDictionary * dic = @{@"orderno":@"",@"createtime":@"",@"owner_link_name":@"",@"owner_link_phone":@""};
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};
    
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        [_dataArray removeAllObjects];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"司机物流订单的列表的%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            for (NSDictionary *dict in [dic objectForKey:@"response"]) {
                WuliuOrderModel *model=[[WuliuOrderModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                
                [_dataArray addObject:model];
            }
        }
        [_tableview reloadData];
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)searchWuliuOrderData{
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticsgoods?action=searchPersonOrderFH"];
    NSDictionary * dic = @{@"orderno":@"",@"createtime":@"",@"owner_link_name":@"",@"owner_link_phone":@""};
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        [_dataArr removeAllObjects];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"物流订单的列表的%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            for (NSDictionary *dict in [dic objectForKey:@"response"]) {
                WuliuOrderModel *model=[[WuliuOrderModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                
                [_dataArr addObject:model];
            }
        }
        [_tableview reloadData];
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.type isEqualToString:@"1"]) {
        return _dataArr.count;
    }else{
        return _dataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.type isEqualToString:@"1"]) {
        return 220;
    }else{
        return 320;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.type isEqualToString:@"1"]) {
        _HeadView = [HomeTableHeaderView headerViewWithTableView:tableView];
        _HeadView.wuliu = @"物流发货单";
        return _HeadView;
    }else{
        _HeadView = [HomeTableHeaderView headerViewWithTableView:tableView];
        _HeadView.wuliu = @"司机接货单";
        return _HeadView;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.type isEqualToString:@"1"]) {
        
        static NSString * stringCell = @"WuliuFaHuoCell";
        WuliuFaHuoCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        if (_dataArr.count) {
            cell.controller = self;
            cell.model = _dataArr[indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bgView.layer.cornerRadius = 8.f;
        cell.bgView.layer.masksToBounds = YES;
        return cell;
    }else{
        static NSString * stringCell = @"DriverGetOrderCell";
        DriverGetOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        if (_dataArray.count) {
            cell.controller = self;
            cell.model = _dataArray[indexPath.row];
        }
        __weak DriverGetOrderCell * weakCell = cell;
        [cell setPhoneCallBlcok:^{
            NSString *ph1 = [NSString stringWithFormat:@"tel:%@",weakCell.model.owner_link_phone];
            UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"拨号" message:weakCell.model.owner_link_phone preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                return ;
            }];
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ph1]];
            }];
            [alertControler addAction:noAction];
            [alertControler addAction:yesAction];
            [self presentViewController:alertControler animated:YES completion:nil];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bgview.layer.cornerRadius = 8.f;
        cell.bgview.layer.masksToBounds = YES;
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.type isEqualToString:@"1"]) {//物流发货端
        WuliuOrderModel * model = _dataArr[indexPath.row];
        WuliuOrderDetail * vc = [[WuliuOrderDetail alloc]init];
//        vc.custstatus = model.cust_orderstatus;
//        vc.driverstatus =model.driver_orderstatus;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else{//司机接货端
        WuliuOrderModel * model = _dataArray[indexPath.row];
        DriverOrderDetailVC * vc = [[DriverOrderDetailVC alloc]init];
//        vc.status = model.driver_orderstatus;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)rightToLastViewController{
    NSString * s;
    if ([self.type isEqualToString:@"1"]) {
        s = @"物流发货单";
    }else{
        s = @"司机接货单";
    }
    SearchWuliuOrderVC * vc = [[SearchWuliuOrderVC alloc]init];
    vc.orderTypeString = s;
    vc.carTypeint = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH) style:UITableViewStyleGrouped];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 0, UIScreenW, UIScreenH-34);
            
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [self.view addSubview:_tableview];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    }
    return _tableview;
    
}
@end
