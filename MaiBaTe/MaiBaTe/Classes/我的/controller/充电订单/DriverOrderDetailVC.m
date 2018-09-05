//
//  DriverOrderDetailVC.m
//  MaiBaTe
//
//  Created by 钱龙 on 2018/1/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DriverOrderDetailVC.h"
#import "CancleOrderView.h"
#import "CarTypeDriverHeadDetailCell.h"
#import "HuoWuImageTableViewCell.h"
#import "TotalPriceCell.h"
#import "DriverRemarkVC.h"
@interface DriverOrderDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * detailArr;
@property (nonatomic,strong)CancleOrderView * cancleView;
@property (nonatomic,strong)UIView * pcancelView;
@end

@implementation DriverOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"司机接货单订单详情";
    _detailArr = [NSMutableArray array];
    [self requestDetail];
    [self tableview];
}
//下拉刷新
- (void)loadNewData{
    //    [_dataArr removeAllObjects];
    //    [self searchLeaseOrderData];
    [_tableview.mj_header endRefreshing];
    
}
-(void)requestDetail{
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticsgoods?action=selectOrderDetById"];
    NSDictionary * dic =@{@"id":self.model.id};
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"司机接货订单详情%@",arr);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            for (NSDictionary *dict in [dic objectForKey:@"response"]) {
                WuliuOrderModel *model=[[WuliuOrderModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                //追加数据
                [_detailArr addObject:model];
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
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 450;
//        return self.tableview.rowHeight;
    }else if (indexPath.section == 1){
        return 150;
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
        static NSString * stringCell = @"CarTypeDriverHeadDetailCell";
        CarTypeDriverHeadDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        if (_detailArr.count) {
            
            cell.model = _detailArr[0];
        }
        [cell setPhoneBtnClickBlock:^{
            NSString *ph1 = [NSString stringWithFormat:@"tel:%@",self.model.contactphone];
            UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"拨号" message:self.model.contactphone preferredStyle:UIAlertControllerStyleAlert];
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
        static NSString * stringCell = @"HuoWuImageTableViewCell";
        HuoWuImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_detailArr.count) {
            WuliuOrderModel *model = _detailArr[0];
            NSArray *images = model.imgList;
            if (images.count>2) {
                [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PHOTO_ADDRESS,[images[0] objectForKey:@"imgurl"]]] placeholderImage:[UIImage imageNamed:@""]];
                [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PHOTO_ADDRESS,[images[1] objectForKey:@"imgurl"]]] placeholderImage:[UIImage imageNamed:@""]];
                [cell.image3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PHOTO_ADDRESS,[images[2] objectForKey:@"imgurl"]]] placeholderImage:[UIImage imageNamed:@""]];
            }else if (images.count==2){
                [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PHOTO_ADDRESS,[images[0] objectForKey:@"imgurl"]]] placeholderImage:[UIImage imageNamed:@""]];
                [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PHOTO_ADDRESS,[images[1] objectForKey:@"imgurl"]]] placeholderImage:[UIImage imageNamed:@""]];
            }else if (images.count==1){
                [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PHOTO_ADDRESS,[images[0] objectForKey:@"imgurl"]]] placeholderImage:[UIImage imageNamed:@""]];
            }
        }
        return cell;
    }else{
        static NSString * stringCell = @"TotalPriceCell";
        TotalPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        if (_detailArr.count) {
            WuliuOrderModel *mode = _detailArr[0];
            cell.huowuPrice.text = [NSString stringWithFormat:@"%.2f元",[mode.siji_money floatValue]];
        }else{
            cell.huowuPrice.text = @"0元";
        }
        
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
