//
//  SearchWuliuOrderVC.m
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SearchWuliuOrderVC.h"
#import "ZJBLStoreShopTypeAlert.h"
#import "AllWuliuOrderListVC.h"
#import "CarTapeAllWuliuOrderListVC.h"
@interface SearchWuliuOrderVC ()
@property (nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation SearchWuliuOrderVC
{
    NSArray *titles;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [IQKeyboardManager sharedManager].enable = NO;
}
//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"物流订单搜索";
    titles = @[@"物流发货单",@"司机接货单"];
    _dataArr = [[NSMutableArray alloc]init];
    self.bgView.layer.cornerRadius = 8.f;
    self.bgView.layer.masksToBounds = YES;
    self.timeBtn.layer.cornerRadius = 12.f;
    self.timeBtn.layer.borderWidth = 1.f;
    self.timeBtn.layer.borderColor = UIColorFromRGB(0xFFB400).CGColor;
    self.orderNo.layer.cornerRadius = 12.f;
    self.orderNo.layer.borderWidth = 1.f;
    self.orderNo.layer.borderColor = UIColorFromRGB(0xFFB400).CGColor;
    [Command placeholderColor:self.orderNo str:self.orderNo.placeholder color:UIColorFromRGB(0x888888)];
    
    self.name.layer.cornerRadius = 12.f;
    self.name.layer.borderWidth = 1.f;
    self.name.layer.borderColor = UIColorFromRGB(0xFFB400).CGColor;
    [Command placeholderColor:self.name str:self.name.placeholder color:UIColorFromRGB(0x888888)];
    
    self.phone.layer.cornerRadius = 12.f;
    self.phone.layer.borderWidth = 1.f;
    self.phone.layer.borderColor = UIColorFromRGB(0xFFB400).CGColor;
    [Command placeholderColor:self.phone str:self.phone.placeholder color:UIColorFromRGB(0x888888)];
    
    self.orderType.layer.cornerRadius = 12.f;
    self.orderType.layer.borderWidth = 1.f;
    self.orderType.layer.borderColor = UIColorFromRGB(0xFFB400).CGColor;
    [self.orderType setTitle:self.orderTypeString forState:UIControlStateNormal];
    //添加手势，为了关闭键盘的操作
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
    
}
- (IBAction)selectTimeBtnClick:(UIButton *)sender {
    __weak typeof(UIButton*) weakBtn = sender;
    [BRDatePickerView showDatePickerWithTitle:@"订单时间" dateType:UIDatePickerModeDate defaultSelValue:nil minDateStr:@"" maxDateStr:[NSDate currentDateString] isAutoSelect:YES resultBlock:^(NSString *selectValue) {
        
        [weakBtn setTitle:selectValue forState:UIControlStateNormal];
    }];
}
- (IBAction)selectTypeBtnClick:(UIButton *)sender {
//    [ZJBLStoreShopTypeAlert showWithTitle:@"选择订单类型" titles:titles selectIndex:^(NSInteger selectIndex) {
//    } selectValue:^(NSString *selectValue) {
//    } showCloseButton:YES];
    __weak typeof(UIButton*) weakBtn = sender;
    __weak typeof(self) weakSelf = self;
    [BRStringPickerView showStringPickerWithTitle:@"" dataSource:titles defaultSelValue:weakSelf isAutoSelect:YES resultBlock:^(id selectValue) {
        [weakBtn setTitle:selectValue forState:UIControlStateNormal];
    }];
    
}
- (IBAction)searchBtnClick:(UIButton *)sender {
    if ([self.orderNo.text isEqualToString:@""]&&[self.timeBtn.titleLabel.text isEqualToString:@"请选择订单时间"]&&[self.name.text isEqualToString:@""]&&[self.phone.text isEqualToString:@""]&&[self.orderType.titleLabel.text isEqualToString:@""]) {
        jxt_showAlertOneButton(@"提示", @"请填写一个查询条件", @"确定", ^(NSInteger buttonIndex) {
            
        });
    }else{
        [self searchLeaseOrderData];
    }
}
-(void)searchLeaseOrderData{
    [_dataArr removeAllObjects];
    NSString *url;
    NSString * typeString = self.orderType.titleLabel.text;
    if (self.carTypeint==1) {
        if ([typeString isEqualToString:@"物流发货单"]) {
            url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticssendwz?action=searchsendorder"];
        }else{
            url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticssendwz?action=searchfindorder"];
        }
    }else{
        if ([typeString isEqualToString:@"物流发货单"]) {
            url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticsgoods?action=searchPersonOrderFH"];
        }else{
            url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/logisticsgoods?action=searchPersonOrderJH"];
        }
    }
    
    NSString *timeStr = self.timeBtn.titleLabel.text;
    if ([self.timeBtn.titleLabel.text isEqualToString:@"请选择订单时间"]) {
        timeStr = @"";
    }
    NSDictionary * dic = @{@"orderno":self.orderNo.text,@"createtime":timeStr,@"owner_link_name":self.name.text,@"owner_link_phone":self.phone.text};
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dic]};
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        if (self.carTypeint==1) {
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"搜索物流订单的列表%@",arr);
            [_dataArr addObjectsFromArray:arr];
            if ([arr isKindOfClass:[NSMutableArray class]]) {
                if (arr.count == 0) {
                    jxt_showAlertOneButton(@"提示", @"未搜索到符合条件的订单", @"确定", ^(NSInteger buttonIndex) {
                        
                    });
                }else{
                    CarTapeAllWuliuOrderListVC * vc = [[CarTapeAllWuliuOrderListVC alloc]init];
                    if ([typeString isEqualToString:@"物流发货单"]) {
                        vc.type = @"1";
                    }else{
                        vc.type = @"2";
                    }
                    //                vc.type = self.orderTypeString;
                    vc.arr = _dataArr;
                    vc.isBack = @"1";
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            if ([[dic objectForKey:@"flag"] intValue]==200) {
                if ([[dic objectForKey:@"response"] count] == 0) {
                    jxt_showAlertOneButton(@"提示", @"未搜索到符合条件的订单", @"确定", ^(NSInteger buttonIndex) {
                        
                    });
                    return ;
                }
                 [_dataArr addObjectsFromArray:[dic objectForKey:@"response"]];
                AllWuliuOrderListVC * vc = [[AllWuliuOrderListVC alloc]init];
                if ([typeString isEqualToString:@"物流发货单"]) {
                    vc.type = @"1";
                }else{
                    vc.type = @"2";
                }
                //                vc.type = self.orderTypeString;
                vc.arr = _dataArr;
                vc.isBack = @"1";
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                jxt_showAlertOneButton(@"提示", @"未搜索到符合条件的订单", @"确定", ^(NSInteger buttonIndex) {
                    
                });
            }
        }
        
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
//以下两个代理方法可以防止键盘遮挡textview
-(void)textFieldDidBeginEditing:(UITextView *)textView{
    
    //这里的offset的大小是控制着呼出键盘的时候view上移多少。比如上移20，就给offset赋值-20，以此类推。也可以根据屏幕高度的不同做一个if判断。
    
    float offset = 0.0f;
    
    offset = -40;
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;
    
    CGRect rect = CGRectMake(0.0f, offset , width, height);
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
}
//完成编辑的时候下移回来（只要把offset重新设为0就行了）

-(void)textFieldDidEndEditing:(UITextView *)textView{
    
    float offset = 0.0f;
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;
    
    CGRect rect = CGRectMake(0.0f, offset , width, height);
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
}


@end
