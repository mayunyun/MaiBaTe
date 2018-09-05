//
//  CarTypeOrderViewController.m
//  MaiBaTe
//
//  Created by LONG on 2018/4/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CarTypeOrderViewController.h"
#import "WuliuFaHuoCell.h"
#import "GetCarInfoView.h"
#import "HomeTableHeaderView.h"
#import "CarTypeWuliuOrderDetail.h"
#import "DriverGetOrderCell.h"
#import "CarTypeDriverOrderDetailVC.h"
#import "WuliuOrderModel.h"
#import "CarTapeAllWuliuOrderListVC.h"
@interface CarTypeOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * needArray;
@property (nonatomic,strong)GetCarInfoView * gHeadView;
@property (nonatomic,strong)HomeTableHeaderView * HeadView;
@property (nonatomic,strong)NSString * isPost;

@end

@implementation CarTypeOrderViewController

{
    int _isClick;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNewData];
    
}
//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isClick = 0;
    
    
    
    
    _dataArr = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    
    [self tableview];
}

//下拉刷新
- (void)loadNewData{
    [_dataArr removeAllObjects];
    [_dataArray removeAllObjects];
    
    
    [self searchDriverWuliuOrderData];
    
    [_tableview.mj_header endRefreshing];
    
}

-(void)searchDriverWuliuOrderData{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticssendwz?action=searchfindorder"];
    NSDictionary * dic = @{@"orderno":@"",@"createtime":@"",@"owner_link_name":@"",@"owner_link_phone":@""};
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"司机物流订单的列表的%@",arr);
        [_dataArray removeAllObjects];
        for (NSDictionary *dic in arr) {
            WuliuOrderModel *model=[[WuliuOrderModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            
            [_dataArray addObject:model];
        }
        [self searchWuliuOrderData];
        [_tableview reloadData];
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)searchWuliuOrderData{
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticssendwz?action=searchsendorder"];
    NSDictionary * dic = @{@"orderno":@"",@"createtime":@"",@"owner_link_name":@"",@"owner_link_phone":@""};
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"物流订单的列表的%@",arr);
        [_dataArr removeAllObjects];
        for (NSDictionary *dic in arr) {
            WuliuOrderModel *model=[[WuliuOrderModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            
            [_dataArr addObject:model];
        }
        [_tableview reloadData];
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_dataArray.count<=3&&_dataArr.count<=3) {
        if (section == 0) {
            return _dataArray.count;
        }else{
            return _dataArr.count;
        }
    }else if (_dataArray.count<=3&&_dataArr.count>3){
        if (section == 0) {
            return _dataArray.count;
        }else{
            return 3;
        }
    }else if (_dataArray.count>3&&_dataArr.count<=3){
        if (section == 0) {
            return 3;
        }else{
            return _dataArr.count;
        }
    }else{
        if (section == 0) {
            return 3;
        }else{
            return 3;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 320;
    }else{
        return 220;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_dataArray.count<=3&&_dataArr.count<=3) {
        if (section == 0) {
            return 2;
        }else{
            return 10;
        }
    }else if (_dataArray.count<=3&&_dataArr.count>3){
        if (section == 0) {
            return 2;
        }else{
            return 80;
        }
    }else if (_dataArray.count>3&&_dataArr.count<=3){
        if (section == 0) {
            return 60;
        }else{
            return 2;
        }
    }else{
        if (section == 0) {
            return 60;
        }else{
            return 80;
        }
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    __weak typeof(self) wself = self;
    if (_dataArray.count<=3&&_dataArr.count<=3) {
        if (section == 0) {
            return nil;
        }else{
            return nil;
        }
    }else if (_dataArray.count<=3&&_dataArr.count>3){
        if (section == 0) {
            return nil;
        }else{
            _gHeadView = [GetCarInfoView headerViewWithTableView:tableView];
            [_gHeadView setMoreBtnBlock:^{
                CarTapeAllWuliuOrderListVC * vc = [[CarTapeAllWuliuOrderListVC alloc]init];
                vc.type = @"1";
                [wself.navigationController pushViewController:vc animated:YES];
            }];
            return _gHeadView;
        }
    }else if (_dataArray.count>3&&_dataArr.count<=3){
        if (section == 0) {
            _gHeadView = [GetCarInfoView headerViewWithTableView:tableView];
            [_gHeadView setMoreBtnBlock:^{
                CarTapeAllWuliuOrderListVC * vc = [[CarTapeAllWuliuOrderListVC alloc]init];
                vc.type = @"2";
                [wself.navigationController pushViewController:vc animated:YES];
            }];
            return _gHeadView;
        }else{
            return nil;
        }
    }else{
        if (section == 0) {
            _gHeadView = [GetCarInfoView headerViewWithTableView:tableView];
            [_gHeadView setMoreBtnBlock:^{
                CarTapeAllWuliuOrderListVC * vc = [[CarTapeAllWuliuOrderListVC alloc]init];
                vc.type = @"2";
                [wself.navigationController pushViewController:vc animated:YES];
            }];
            return _gHeadView;
        }else{
            _gHeadView = [GetCarInfoView headerViewWithTableView:tableView];
            [_gHeadView setMoreBtnBlock:^{
                CarTapeAllWuliuOrderListVC * vc = [[CarTapeAllWuliuOrderListVC alloc]init];
                vc.type = @"1";
                [wself.navigationController pushViewController:vc animated:YES];
            }];
            return _gHeadView;
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{//头视图
    if (_dataArray.count==0&&_dataArr.count==0) {
        return 10;
    }else if (_dataArray.count == 0 && _dataArr.count!=0){
        if (section == 0) {
            return 0;
        }else{
            return 40;
        }
    }else if (_dataArray.count != 0 && _dataArr.count == 0){
        if (section == 0) {
            return 40;
        }else{
            return 0;
        }
    }else{
        if (section == 0) {
            return 40;
        }else{
            return 40;
        }
    }
}
//头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_dataArray.count == 0) {//没有司机接货订单时
        
        if (_dataArr.count != 0) {//有物流发货订单时
            _HeadView = [HomeTableHeaderView headerViewWithTableView:tableView];
            _HeadView.wuliu = @"物流发货单";
            return _HeadView;
        }else{
            return nil;
        }
    }
    else{//有司机接货订单时
        if (_dataArr.count == 0) {//没有物流发货订单时
            _HeadView = [HomeTableHeaderView headerViewWithTableView:tableView];
            _HeadView.wuliu = @"司机接货单";
            return _HeadView;
        }else{//有物流发货订单
            if (section == 0) {
                _HeadView = [HomeTableHeaderView headerViewWithTableView:tableView];
                _HeadView.wuliu = @"司机接货单";
                return _HeadView;
            }else{
                _HeadView = [HomeTableHeaderView headerViewWithTableView:tableView];
                _HeadView.wuliu = @"物流发货单";
                return _HeadView;
            }
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * stringCell = @"DriverGetOrderCell";
        DriverGetOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        if (_dataArray.count != 0) {
            
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
        
    }else{
        static NSString * stringCell = @"WuliuFaHuoCell";
        WuliuFaHuoCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        if (_dataArr.count != 0) {
            cell.model = _dataArr[indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bgView.layer.cornerRadius = 8.f;
        cell.bgView.layer.masksToBounds = YES;
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //            jxt_showToastTitle(@"积极建设中...", 2);
        //            //            return;
        WuliuOrderModel * model = _dataArray[indexPath.row];
        CarTypeDriverOrderDetailVC * vc = [[CarTypeDriverOrderDetailVC alloc]init];
        //            vc.status = model.driver_orderstatus;
        vc.model = model;
        vc.needDic = _needArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        WuliuOrderModel * model = _dataArr[indexPath.row];
        CarTypeWuliuOrderDetail * vc = [[CarTypeWuliuOrderDetail alloc]init];
        //            vc.custstatus = model.cust_orderstatus;
        //            vc.driverstatus =model.driver_orderstatus;
        vc.model = model;
        vc.needDic = _needArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH-40-NavBarHeight) style:UITableViewStyleGrouped];
        
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
