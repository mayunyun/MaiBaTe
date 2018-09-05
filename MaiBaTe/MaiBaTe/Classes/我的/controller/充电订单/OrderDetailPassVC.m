//
//  OrderDetailPassVC.m
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "OrderDetailPassVC.h"
#import "OrderDetailHeadCell.h"
#import "OrderDetailFooterCell.h"
#import "OrderDetailNeedCell.h"
#import "HomeTableHeaderView.h"
#import "OrderDetailPassCell.h"
#import "OrderDetailBeiZhuCell.h"
@interface OrderDetailPassVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic, strong) HomeTableHeaderView *headerView;

@end

@implementation OrderDetailPassVC
{
    UIButton * _bottomButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    _dataArr = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self searchLeaseOrderData];
    [self tableview];
}
-(void)searchLeaseOrderData{
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/leaseorderwz?action=searchLeaseOrderDetail"];
    NSDictionary * dic = @{@"order_id":self.orderDic[@"id"]};
    NSDictionary* KCparams = @{@"params":[Command dictionaryToJson:dic]};//
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"租车订单的详情%@",arr);
        [_dataArr addObjectsFromArray:arr];
        [_tableview reloadData];
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
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
    }
    return _tableview;
    
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArr.count==0) {
        return 0;
    }
    if ([_dataArr[0][@"orderstatus"] integerValue] == 2){
        if ([[Command convertNull:[NSString stringWithFormat:@"%@",_dataArr[0][@"note"]]] isEqualToString:@""]) {
            return _dataArr.count+2;
        }
        return _dataArr.count+3;

    }
    if ([[Command convertNull:[NSString stringWithFormat:@"%@",_dataArr[0][@"note"]]] isEqualToString:@""]) {
        return _dataArr.count+3;
    }
    return _dataArr.count+4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArr.count==0) {
        return 0.01;
    }
    if ([_dataArr[0][@"orderstatus"] integerValue] == 2){
        if (indexPath.section == 2+_dataArr.count){
            return [self getHeightLineWithString:[NSString stringWithFormat:@"%@",_dataArr[0][@"note"]] withWidth:UIScreenW-16 withFont:[UIFont systemFontOfSize:14]]+40;
        }
        
    }
    
    if (indexPath.section == 0) {
        return 260;
    }else if (indexPath.section == 1+_dataArr.count){
        return 44;
    }else if (indexPath.section == 2+_dataArr.count){
        return 180;
    }else if (indexPath.section == 3+_dataArr.count){
        return [self getHeightLineWithString:[NSString stringWithFormat:@"%@",_dataArr[0][@"note"]] withWidth:UIScreenW-20 withFont:[UIFont systemFontOfSize:14]]+40;
    }else{
        if ([_dataArr[0][@"orderstatus"] integerValue] == 1){
            return 315;
        }
        return 265;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * stringCell = @"OrderDetailHeadCell";
        OrderDetailHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.dic = _dataArr[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.section == 1+_dataArr.count){
        static NSString * stringCell = @"OrderDetailFooterCell";
        OrderDetailFooterCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.getCarTimeLabel.text = [NSString stringWithFormat:@"%@",_dataArr[0][@"take_time"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2+_dataArr.count){
        if ([_dataArr[0][@"orderstatus"] integerValue] == 2){
            static NSString * stringCell = @"OrderDetailBeiZhuCell";
            OrderDetailBeiZhuCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
            }
            cell.BeiZhuLab.text = [NSString stringWithFormat:@"%@",_dataArr[0][@"note"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static NSString * stringCell = @"OrderDetailPassCell";
            OrderDetailPassCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
            }
            cell.dic = _dataArr[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if (indexPath.section == 3+_dataArr.count){
        static NSString * stringCell = @"OrderDetailBeiZhuCell";
        OrderDetailBeiZhuCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.BeiZhuLab.text = [NSString stringWithFormat:@"%@",_dataArr[0][@"note"]];
        if ([[Command convertNull:cell.BeiZhuLab.text] isEqualToString:@""]) {
            cell.BeiZhuLab.text = @"无";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString * stringCell = @"OrderDetailNeedCell";
        OrderDetailNeedCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.dataDic = _dataArr[indexPath.section -1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{//头视图

    if (section == 0) {
        return 20;
    }else if(section==_dataArr.count+1){
        return 10;
    }else{
        return 30;
    }
}
//头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    if (section == 0||section==_dataArr.count+1) {
        return nil;
    }else if(section == _dataArr.count+2){
        _headerView = [HomeTableHeaderView headerViewWithTableView:tableView];
        _headerView.status = @"提车信息";
        if ([_dataArr[0][@"orderstatus"] integerValue] == 2){
            _headerView.status = @"备注";
        }
        return _headerView;
    }else if(section == _dataArr.count+3){
        _headerView = [HomeTableHeaderView headerViewWithTableView:tableView];
        _headerView.status = @"备注";
        return _headerView;
    }else{
        _headerView = [HomeTableHeaderView headerViewWithTableView:tableView];
        _headerView.count = section;
        return _headerView;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



@end
