//
//  OrderDetailVC.m
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "OrderDetailVC.h"
#import "OrderDetailHeadCell.h"
#import "OrderDetailFooterCell.h"
#import "OrderDetailNeedCell.h"
#import "HomeTableHeaderView.h"
@interface OrderDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic, strong) HomeTableHeaderView *headerView;
@end

@implementation OrderDetailVC
{
    UIButton * _bottomButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    _dataArr = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self tableview];
    [self searchLeaseOrderData];
    [self crateBottomView];
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
-(void)crateBottomView{
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenH-50, UIScreenW, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _bottomButton.frame = CGRectMake(0, 0, UIScreenW, bottomView.height);
    [_bottomButton setBackgroundColor:[UIColor lightGrayColor]];
    [_bottomButton setTitle:@"取消订单" forState:UIControlStateNormal];
    _bottomButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bottomButton addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_bottomButton];
    if (statusbarHeight>20) {
        bottomView.frame = CGRectMake(0, UIScreenH-50-34, UIScreenW, 50+34);
        _bottomButton.frame = CGRectMake(10, 10, UIScreenW-20, bottomView.height-20-34);
        
    }
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH-50) style:UITableViewStyleGrouped];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 0, UIScreenW, UIScreenH-50-34);
            
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
    return 1+_dataArr.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 260;
    }else if (indexPath.section == 1+_dataArr.count){
        return 44;
    }else{
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
        cell.dic = self.orderDic;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if (indexPath.section == 1+_dataArr.count){
        static NSString * stringCell = @"OrderDetailFooterCell";
        OrderDetailFooterCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.getCarTimeLabel.text = [NSString stringWithFormat:@"%@",self.orderDic[@"take_time"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
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
    return 1;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{//头视图
    if (section == 0) {
        return 20;  
    }else{
        return 30;
    }
} 
//头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0||section==1+_dataArr.count+1-1) {
        return nil;
    }else{
        _headerView = [HomeTableHeaderView headerViewWithTableView:tableView];
        _headerView.count = section;
        return _headerView;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)cancelOrder{
    jxt_showAlertTwoButton(@"提示", @"是否取消订单", @"取消", ^(NSInteger buttonIndex) {
        
    }, @"确定", ^(NSInteger buttonIndex) {
        [self searchCancle];
    });
    
}
-(void)searchCancle{
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/leaseorderwz?action=cancleLeaseOrder"];
    NSDictionary * dic = @{@"id":self.orderDic[@"id"]};
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        NSString * result = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"取消订单返回的内容%@",result);
        if ([result containsString:@"true"]||[result isEqualToString:@"true"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"InfoNotification" object:nil userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else if([result containsString:@"notloggedin"]||[result isEqualToString:@"notloggedin"]){
            jxt_showToastTitle(@"登录失效", 2);
        }else{
            jxt_showToastTitle(@"取消失败", 2);
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
@end
