//
//  WuliuOrderDetail.m
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "WuliuOrderDetail.h"
#import "CarTypeWuliuOrderDetailHeaderCell.h"
#import "AdressCell.h"
#import "HuoWuImageTableViewCell.h"
#import "TotalPriceCell.h"
#import "DriveInfoCell.h"
#import "DriverOrderInfoCell.h"
#import "CancleOrderView.h"
#import "CDZStarsControl.h"
@interface WuliuOrderDetail ()<UITableViewDataSource,UITableViewDelegate,CDZStarsControlDelegate,UITextViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * detailArr;
@property (nonatomic,strong)CancleOrderView * cancleView;
@property (nonatomic,strong)UIView * pcancelView;
@property (nonatomic, strong) CDZStarsControl *starsControl;
@property (nonatomic,strong)UITextView * inputTV;
@property (nonatomic,strong)UIButton * exitBtn;
@property (nonatomic,strong)UIButton * commitBtn;
@end

@implementation WuliuOrderDetail
{
    UIView * starView;
    UILabel *_placeHolderLabel;
    NSString * starScore;
    NSString * fee;
    NSArray * arr;
    UILabel * feeLabel;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"物流发货单订单详情";
    
    _detailArr = [NSMutableArray array];
    [self requestDetail];
    [self requestDataForRate];
    [self tableview];
    starScore = @"5";
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:NO];
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];

}

//下拉刷新
- (void)loadNewData{

    [_tableview.mj_header endRefreshing];
}
-(void)requestDetail{
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticsgoods?action=selectOrderDetByIdCust"];
        NSDictionary * dic =@{@"id":self.model.id};
        NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"订单详情%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            for (NSDictionary *dict in [dic objectForKey:@"response"]) {
                WuliuOrderModel *model=[[WuliuOrderModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_detailArr addObject:model];
                
            }
        }
        
        [_tableview reloadData];
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)requestDataForRate{
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticssendwz?action=searchfee"];
    //    NSDictionary * dic =@{@"orderno":self.model.owner_orderno};
    //    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [HTNetWorking postWithUrl:url refreshCache:YES params:nil success:^(id response) {
        [SVProgressHUD dismiss];
        //        NSString * strfee = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        //        NSLog(@"请求费率%@",strfee);
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求费率%@",arr);
        if (arr.count == 0||arr == nil) {
            fee = @"0";
        }else{
            NSString *feeStr = [NSString stringWithFormat:@"%@",arr[0][@"fee"]];
            fee = [NSString stringWithFormat:@"%.2f",[feeStr floatValue]*100];
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)CommitBtnClicked:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticsgoods?action=evlateOrder"];
    NSDictionary * dic;
    if ([_inputTV.text isEqualToString:@""]) {//默认不填任何信息是好评
        dic =@{@"id":self.model.id,@"driver_fraction":starScore,@"note":@"默认好评"};
    }else{
        dic =@{@"id":self.model.id,@"driver_fraction":starScore,@"note":_inputTV.text};
    }
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"提交评价%@",dic);
        
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // do something
                [SMAlert hide:NO];
                _cancleView.hidden = YES;
                WuliuOrderModel * model = _detailArr[0];
                model.cust_orderstatus = @"2";
                jxt_showToastTitle(@"提交评价成功", 1);
                sender.userInteractionEnabled = NO;
                [_tableview reloadData];
            });
        }else{
            jxt_showToastTitle(@"提交评价失败", 1);
            sender.userInteractionEnabled = NO;
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}

-(void)startOrder{
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticsgoods?action=startOrder"];
    NSDictionary * dic =@{@"id":self.model.id};
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"开始订单%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            jxt_showToastTitle(@"订单已开始", 2);
            WuliuOrderModel * model = _detailArr[0];
            model.cust_orderstatus = @"1";
            //刷新完数据滚动到顶部
            [_tableview setContentOffset:CGPointMake(0,0) animated:YES];
            [_tableview reloadData];
        }else{
            jxt_showToastTitle(@"开始订单失败", 2);
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
//结束订单
-(void)endingOrderData{
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticsgoods?action=finishOrder"];
    NSDictionary * dic =@{@"id":self.model.id};
        NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"结束订单%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            starView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW-60, UIScreenH*1.4/3)];
            starView.backgroundColor = [UIColor whiteColor];
            starView.layer.cornerRadius = 40.f;
            starView.layer.masksToBounds = YES;
            [starView addSubview:self.starsControl];
            [starView addSubview:self.exitBtn];
            [starView addSubview:self.inputTV];
            [starView addSubview:self.commitBtn];
            [SMAlert showCustomView:starView];
            
        }else{
            jxt_showToastTitle(@"完成订单失败", 2);
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)DriverSyData{
    WuliuOrderModel * model;
    if (_detailArr.count) {
        model  = _detailArr[0];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticsgoods?action=overTime"];
    NSDictionary * dic =@{@"id":self.model.id};
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"司机失约%@",dic);
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            jxt_showToastTitle(@"提交成功", 2);
            WuliuOrderModel * model = _detailArr[0];
            model.cust_orderstatus = @"-1";
            //刷新完数据滚动到顶部
            [_tableview setContentOffset:CGPointMake(0,0) animated:YES];
            [_tableview reloadData];
        }else{
            jxt_showToastTitle([dic objectForKey:@"msg"], 2);
        }
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)cancelOrderData{
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticsgoods?action=cancelOrder"];
    NSDictionary * dic =@{@"id":self.model.id};
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};//
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"取消订单%@",dic);
        UIView * canView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW-60, UIScreenH*1.2/4)];
        canView.backgroundColor = [UIColor whiteColor];
        //    canView.layer.cornerRadius = 40.f;
        //    canView.layer.masksToBounds = YES;
        UIButton * quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        quitBtn.frame = CGRectMake(canView.right-25*MYWIDTH, 10*MYWIDTH, 15*MYWIDTH, 15*MYWIDTH);
        [quitBtn setImage:[UIImage imageNamed:@"关闭_1"] forState:UIControlStateNormal];
        [quitBtn addTarget:self action:@selector(quitPage) forControlEvents:UIControlEventTouchUpInside];
        [canView addSubview:quitBtn];
        UIImageView * imagev = [[UIImageView alloc]initWithFrame:CGRectMake((canView.width/2)-40*MYWIDTH, 20*MYWIDTH, 70*MYWIDTH, 80*MYWIDTH)];
        imagev.image = [UIImage imageNamed:@"8.1"];
        [canView addSubview:imagev];
        UILabel * note1Label = [[UILabel alloc]initWithFrame:CGRectMake(0, imagev.bottom +20*MYWIDTH, canView.width, 20*MYWIDTH)];
        note1Label.text = @"订单已取消";
        note1Label.textColor = UIColorFromRGB(0x484848);
        note1Label.textAlignment = NSTextAlignmentCenter;
        note1Label.font = [UIFont systemFontOfSize:15*MYWIDTH];
        [canView addSubview:note1Label];
        feeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, note1Label.bottom +5*MYWIDTH, note1Label.width, 20*MYWIDTH)];
        feeLabel.text = @"";
        feeLabel.textColor = UIColorFromRGB(0x484848);
        feeLabel.textAlignment = NSTextAlignmentCenter;
        feeLabel.font = [UIFont systemFontOfSize:15*MYWIDTH];
        [canView addSubview:feeLabel];
        if ([[dic objectForKey:@"flag"] intValue]==200) {
            [SMAlert showCustomView:canView];
            feeLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"msg"]];
        }else{
            jxt_showToastTitle(@"取消订单失败", 1);
        }
        
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5; 
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 367;
    }else if (indexPath.section == 1){
        return 120;
    }else if (indexPath.section == 2){
        return 150;
    }else if (indexPath.section == 3){
        return 80;
    }else{
        WuliuOrderModel * model;
        if (_detailArr.count) {
            model = _detailArr[0];
        }
        NSString * driver_custId = [NSString stringWithFormat:@"%@",model.driver_custid];
        if ([[Command convertNull:driver_custId] isEqualToString:@""]||[model.driver_custid intValue] == 0) {
            return 80;
        }else{
            return 120;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 4) {
        return 240;
    }
        return 1;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 4) {
        __weak typeof(self) weakSelf = self;
//        __weak typeof(_cancleView) _weakcancleView = _cancleView;
        _cancleView = [CancleOrderView headerViewWithTableView:tableView];
        if (_detailArr.count) {
         WuliuOrderModel * model  = _detailArr[0];
        NSArray * arr = @[model.cust_orderstatus,model.driver_orderstatus];
            _cancleView.status = arr;
        }
        [_cancleView setCancleBtnBlock:^{
            //取消订单视图
            UIView * canView = [weakSelf cancelView];
            canView.backgroundColor = [UIColor whiteColor];
            [SMAlert showCustomView:canView];
            
        }];
        [_cancleView setStartBtnBlock:^{
            jxt_showAlertTwoButton(@"提示", @"确认开始订单", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"确定", ^(NSInteger buttonIndex) {
                [weakSelf startOrder];
            });
            
        }];
        [_cancleView setEndBtnBlock:^{
            jxt_showAlertTwoButton(@"提示", @"确认完成订单", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"确定", ^(NSInteger buttonIndex) {
                [weakSelf endingOrderData];
            });
            
        }];
        [_cancleView setDriverSyBlock:^{
            jxt_showAlertTwoButton(@"提示", @"确定司机失约了？", @"取消", ^(NSInteger buttonIndex) {

            }, @"确定", ^(NSInteger buttonIndex) {
                [weakSelf DriverSyData];
            });
            
        }];
        return _cancleView;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{//头视图
    return 20;
}
//头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * stringCell = @"CarTypeWuliuOrderDetailHeaderCell";
        CarTypeWuliuOrderDetailHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        if (_detailArr.count) {
            cell.model = _detailArr[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        static NSString * stringCell = @"AdressCell";
        AdressCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        if (_detailArr.count) {
            WuliuOrderModel *mode = _detailArr[0];
            cell.startPosition.text = [NSString stringWithFormat:@"%@",mode.startaddress];
            cell.endPosition.text = [NSString stringWithFormat:@"%@",mode.endaddress];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2){
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
    }else if (indexPath.section == 3){
        static NSString * stringCell = @"TotalPriceCell";
        TotalPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        if (_detailArr.count) {
            WuliuOrderModel *mode = _detailArr[0];
            cell.huowuPrice.text = [NSString stringWithFormat:@"%.2f元",[mode.price floatValue]];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        //未接单
        WuliuOrderModel * model;
        if (_detailArr.count) {
            model = _detailArr[0];
        }
        NSString * driver_custId = [NSString stringWithFormat:@"%@",model.driver_custid];
        if ([[Command convertNull:driver_custId] isEqualToString:@""]||[model.driver_custid intValue] == 0) {
            static NSString * stringCell = @"DriveInfoCell";
            DriveInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            //接单
            static NSString * stringCell = @"DriverOrderInfoCell";
            DriverOrderInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
            }
            WuliuOrderModel * model;
            if (_detailArr.count) {
                model = _detailArr[0];
                cell.driverName.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",model.drivername]];
                cell.driverPhone.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",model.driverphone]];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
//取消订单确认弹窗
-(UIView *)cancelView{
    if (_pcancelView == nil) {
        _pcancelView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW-40, UIScreenH/3)];
//        _pcancelView.layer.cornerRadius = 60.f;
//        _pcancelView.layer.masksToBounds = YES;
        UILabel * cancelLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*MYWIDTH, 10, _pcancelView.width-20, 30*MYWIDTH)];
        cancelLabel.text = @"取消订单";
        cancelLabel.textColor = UIColorFromRGB(0x484848);
        [_pcancelView addSubview:cancelLabel];
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, cancelLabel.bottom +5*MYWIDTH,_pcancelView.width, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_pcancelView addSubview:line];
        UIImageView * pointImagev1 = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, line.bottom +22*MYWIDTH, 15*MYWIDTH, 15*MYWIDTH)];
        pointImagev1.image = [UIImage imageNamed:@"点"];
        [_pcancelView addSubview:pointImagev1];
        UILabel * note1Label = [[UILabel alloc]initWithFrame:CGRectMake(pointImagev1.right+3, line.bottom +20*MYWIDTH, cancelLabel.width-20*MYWIDTH, 20*MYWIDTH)];
        note1Label.text = [NSString stringWithFormat:@"%@",@"司机接单前及接单三分钟内可免费取消"];
        note1Label.textColor = UIColorFromRGB(0x484848);
        note1Label.font = [UIFont systemFontOfSize:14*MYWIDTH];
        [_pcancelView addSubview:note1Label];
        UIImageView * pointImagev2 = [[UIImageView alloc]initWithFrame:CGRectMake(20*MYWIDTH, note1Label.bottom +12*MYWIDTH, 15*MYWIDTH, 15*MYWIDTH)];
        pointImagev2.image = [UIImage imageNamed:@"点"];
        [_pcancelView addSubview:pointImagev2];
        UILabel * note2Label = [[UILabel alloc]initWithFrame:CGRectMake(pointImagev2.right+3, note1Label.bottom +10*MYWIDTH, note1Label.width, 20*MYWIDTH)];
        note2Label.text = [NSString stringWithFormat:@"司机接单三分钟后取消,将扣您%@%%的费用",fee];
        note2Label.textColor = UIColorFromRGB(0x484848);
        note2Label.font = [UIFont systemFontOfSize:14*MYWIDTH];
        [_pcancelView addSubview:note2Label];
        UIButton * continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        continueBtn.frame = CGRectMake(20, _pcancelView.height-60, (_pcancelView.width-60)/2, 40*MYWIDTH);
        [continueBtn setTitle:@"继续订单" forState:UIControlStateNormal];
        [continueBtn addTarget:self action:@selector(continueBtnCliked) forControlEvents:UIControlEventTouchUpInside];
        continueBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [continueBtn setBackgroundColor:UIColorFromRGB(0xFFB400)];
        continueBtn.layer.cornerRadius = 8.f;
        continueBtn.layer.masksToBounds = YES;
        [_pcancelView addSubview:continueBtn];
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(continueBtn.right+20, _pcancelView.height-60, (_pcancelView.width-60)/2, 40*MYWIDTH);
        [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnCliked) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelBtn setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
        cancelBtn.layer.cornerRadius = 8.f;
        cancelBtn.layer.masksToBounds = YES;
        [_pcancelView addSubview:cancelBtn];
    }
    return _pcancelView;
}
-(void)quitPage{
    [SMAlert hide:NO];
    _cancleView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)continueBtnCliked{
    [SMAlert hide:NO];
}
-(void)cancelBtnCliked{
    [SMAlert hide:NO];
    [self cancelOrderData];
}
- (void)textViewDidChange:(UITextView *)textView

{
    
    if (textView.text.length == 0 )
        
    {
        
        _placeHolderLabel.text = @"请输入您的宝贵意见!";
        
    }
    
    else
        
    {
        
        _placeHolderLabel.text = @"";
        
    }
    
}
-(void)exitRemarkPage{
    [SMAlert hide:NO];
    _cancleView.hidden = YES;
    WuliuOrderModel * model = _detailArr[0];
    model.cust_orderstatus = @"2";
    [_tableview reloadData];
}
#pragma remark -- 星星评价
- (void)starsControl:(CDZStarsControl *)starsControl didChangeScore:(CGFloat)score{
//    self.label.text = [NSString stringWithFormat:@"%.1f",score];
    starScore = [NSString stringWithFormat:@"%.f",score];
    NSLog(@"星星的分数%@",starScore);
}

#pragma mark -- 懒加载
- (CDZStarsControl *)starsControl{
    if (!_starsControl) {
    
        _starsControl = [CDZStarsControl.alloc initWithFrame:CGRectMake(30*MYWIDTH, 30*MYWIDTH, starView.width - 60*MYWIDTH , 35*MYWIDTH) stars:5 starSize:CGSizeMake(35*MYWIDTH, 35*MYWIDTH) noramlStarImage:[UIImage imageNamed:@"11.2"] highlightedStarImage:[UIImage imageNamed:@"11.1"]];
        _starsControl.delegate = self;
        _starsControl.allowFraction = NO;
        _starsControl.score = 5.0f;
    }
    return _starsControl;
}
-(UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exitBtn.frame = CGRectMake(_starsControl.right, 10*MYWIDTH, 15*MYWIDTH, 15*MYWIDTH);
        [_exitBtn setImage:[UIImage imageNamed:@"关闭_1"] forState:UIControlStateNormal];
        [_exitBtn addTarget:self action:@selector(exitRemarkPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
    
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
         _tableview.scrollsToTop = YES;
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    }
    return _tableview;
    
}
-(UITextView *)inputTV{
    if (!_inputTV) {
        _inputTV = [[UITextView alloc] initWithFrame:CGRectMake(20*MYWIDTH, self.starsControl.bottom+15*MYWIDTH, starView.width-40*MYWIDTH, starView.height/2)];
        _inputTV.font = [UIFont systemFontOfSize:15*MYWIDTH];
        _inputTV.layer.cornerRadius = 8.f;
        _inputTV.layer.borderWidth = 1.0f;
        _inputTV.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _inputTV.delegate = self;
        _inputTV.backgroundColor = [UIColor clearColor];
        _inputTV.textColor = [UIColor blackColor];
        [starView addSubview:_inputTV];
        _inputTV.text = @"";
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5*MYWIDTH, 5*MYWIDTH,starView.width-40*MYWIDTH, 20*MYWIDTH)];
        _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        _placeHolderLabel.font = [UIFont systemFontOfSize:17*MYWIDTH];
        _placeHolderLabel.text = @"请输入您的宝贵意见!";
        [_inputTV addSubview:_placeHolderLabel];
        //给键盘加一个view收起键盘
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 30)];
        [topView setBarStyle:UIBarStyleBlack];
        UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
        NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
        [topView setItems:buttonsArray];
        [_inputTV setInputAccessoryView:topView];
        
    }
    return _inputTV;
}
-(UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.frame = CGRectMake(_inputTV.centerX-70*MYWIDTH, starView.height-60*MYWIDTH, 140*MYWIDTH, 40*MYWIDTH);
        [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:15*MYWIDTH];
        [_commitBtn setBackgroundColor:UIColorFromRGB(0xFFB400)];
        [_commitBtn addTarget:self action:@selector(CommitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _commitBtn.layer.cornerRadius = 8.f;
        _commitBtn.layer.masksToBounds = YES;
    }
    return _commitBtn;
}
-(void)dismissKeyBoard
{
    [_inputTV resignFirstResponder];
}

@end
