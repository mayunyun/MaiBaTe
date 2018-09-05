//
//  CarTypeDriverOrderDetailVC.m
//  MaiBaTe
//
//  Created by LONG on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CarTypeDriverOrderDetailVC.h"
#import "CancleOrderView.h"
#import "DriverHeadDetailCell.h"
#import "ExNeedCell.h"
#import "TotalPriceCell.h"
#import "DriverRemarkVC.h"
@interface CarTypeDriverOrderDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * detailArr;
@property (nonatomic,strong)NSMutableArray * needArray;
@property (nonatomic,strong)NSMutableArray * needContentArray;
@property (nonatomic,strong)CancleOrderView * cancleView;
@property (nonatomic,strong)UIView * pcancelView;
@end

@implementation CarTypeDriverOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"司机接货单订单详情";
    _dataArr = [[NSMutableArray alloc]init];
    _needArray = [[NSMutableArray alloc]init];
    _needContentArray=[NSMutableArray array];
    _detailArr = [NSMutableArray array];
    [self searchNeedData];
    [self requestDetail];
    [self tableview];
    //    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
}
//下拉刷新
- (void)loadNewData{
    //    [_dataArr removeAllObjects];
    //    [self searchLeaseOrderData];
    [_tableview.mj_header endRefreshing];
    
}
-(void)requestDetail{
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/find?action=selectLogisticsOrderDetail"];
    NSDictionary * dic =@{@"id":self.model.id};
    NSDictionary* KCparams = @{@"params":[Command dictionaryToJson:dic]};//
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"司机接货订单详情%@",arr);
        for (NSDictionary *dic in arr) {
            WuliuOrderModel *model=[[WuliuOrderModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            //追加数据
            [_detailArr addObject:model];
        }
        [_tableview reloadData];
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
//根据订单id查询额外需求
-(void)searchNeedData{
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticssendwz?action=searchorderdetail"];
    NSDictionary * dic = @{@"orderId":self.model.id};
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"额外需求%@",arr);
        //        [_needArray addObjectsFromArray:arr];
        
        for (NSDictionary *dic in arr) {
            [_needArray addObject:[NSString stringWithFormat:@"%@",dic[@"owner_service_price"]]];
            [_needContentArray addObject:dic[@"service_name"]];
            
        }
        [_tableview reloadData];
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return _needArray.count+1;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 320;
        //        return self.tableview.rowHeight;
    }else if (indexPath.section == 1){
        return 40;
    }else{
        return 80;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 180;
    }
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
//头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * stringCell = @"DriverHeadDetailCell";
        DriverHeadDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        if (_detailArr.count) {
            
            cell.model = _detailArr[0];
        }
        [cell setPhoneBtnClickBlock:^{
            NSString *ph1 = [NSString stringWithFormat:@"tel:%@",self.model.owner_link_phone];
            UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"拨号" message:self.model.owner_link_phone preferredStyle:UIAlertControllerStyleAlert];
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
        return cell;
    }else if (indexPath.section == 1){
        static NSString * stringCell = @"ExNeedCell";
        ExNeedCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        if (indexPath.row == 0) {
            cell.typeLabel.text = @"额外需求";
            cell.typeLabel.textColor = [UIColor blackColor];
            cell.typeLabel.font =[UIFont systemFontOfSize:17];
            cell.contentLabel.text = @"";
        }else{
            cell.typeLabel.textColor = UIColorFromRGB(0x555555);
            cell.typeLabel.font = [UIFont systemFontOfSize:15];
            cell.contentLabel.textColor = UIColorFromRGB(0x555555);
            cell.contentLabel.font = [UIFont systemFontOfSize:15];
            cell.typeLabel.text = _needContentArray[indexPath.row-1];
            if ([_needArray[indexPath.row -1] isEqualToString:@"0"]) {
                cell.contentLabel.text = @"免费";
            }else{
                cell.contentLabel.text = [NSString stringWithFormat:@"%.2f元",[_needArray[indexPath.row-1] floatValue]];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString * stringCell = @"TotalPriceCell";
        TotalPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.distance.text = [NSString stringWithFormat:@"%.2f公里",[self.model.total_mileage floatValue]];
        cell.price.text = [NSString stringWithFormat:@"%.2f元",[self.model.siji_money floatValue]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self.view addSubview:_tableview];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    }
    return _tableview;
    
}

@end
