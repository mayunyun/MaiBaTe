//
//  SearchOrderVC.m
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SearchOrderVC.h"

@interface SearchOrderVC ()
@property (nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation SearchOrderVC
{
    NSString *  locationStringBefore;
    NSString *  locationStringAfter;
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
    self.title = @"订单搜索";
    _dataArr = [[NSMutableArray alloc]init];
    self.bgView.layer.cornerRadius = 8.f;
    self.bgView.layer.masksToBounds = YES;
    self.timeBut.layer.cornerRadius = 12.f;
    self.timeBut.layer.borderWidth = 1.f;
    self.timeBut.layer.borderColor = UIColorFromRGB(0xFFB400).CGColor;
    self.orderNumTf.layer.cornerRadius = 12.f;
    self.orderNumTf.layer.borderWidth = 1.f;
    self.orderNumTf.layer.borderColor = UIColorFromRGB(0xFFB400).CGColor;
    [Command placeholderColor:self.orderNumTf str:self.orderNumTf.placeholder color:UIColorFromRGB(0x888888)];

    self.nameTf.layer.cornerRadius = 12.f;
    self.nameTf.layer.borderWidth = 1.f;
    self.nameTf.layer.borderColor = UIColorFromRGB(0xFFB400).CGColor;
    [Command placeholderColor:self.nameTf str:self.nameTf.placeholder color:UIColorFromRGB(0x888888)];

    self.phoneTf.layer.cornerRadius = 12.f;
    self.phoneTf.layer.borderWidth = 1.f;
    self.phoneTf.layer.borderColor = UIColorFromRGB(0xFFB400).CGColor;
    [Command placeholderColor:self.phoneTf str:self.phoneTf.placeholder color:UIColorFromRGB(0x888888)];

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
- (IBAction)searchOrderBtnClicked:(id)sender {
    if ([self.orderNumTf.text isEqualToString:@""]&&[self.timeBut.titleLabel.text isEqualToString:@"请选择订单时间"]&&[self.nameTf.text isEqualToString:@""]&&[self.phoneTf.text isEqualToString:@""]) {
        jxt_showAlertOneButton(@"提示", @"请填写一个查询条件", @"确定", ^(NSInteger buttonIndex) {
            
        });
    }else{
        [self searchLeaseOrderData];
    }
}
-(void)searchLeaseOrderData{
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/leaseorderwz?action=searchLeaseOrder"];
    NSString *timeStr = self.timeBut.titleLabel.text;
    if ([self.timeBut.titleLabel.text isEqualToString:@"请选择订单时间"]) {
        timeStr = @"";
    } 

    NSDictionary * dic = @{@"orderno":self.orderNumTf.text,@"createtimebefore":[Command convertNull:locationStringBefore],@"createtimeafter":[Command convertNull:locationStringAfter],@"link_name":self.nameTf.text,@"link_phone":self.phoneTf.text,@"orderstatus":self.orderstatus};
    NSDictionary* KCparams = @{@"params":[Command dictionaryToJson:dic]};//
    [HTNetWorking postWithUrl:url refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"搜索租车订单的列表%@",arr);
        [_dataArr addObjectsFromArray:arr];
        if ([arr isKindOfClass:[NSMutableArray class]]) {
            if (arr.count == 0) {
                jxt_showAlertOneButton(@"提示", @"未搜索到符合条件的订单", @"确定", ^(NSInteger buttonIndex) {
                    
                });
            }else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"InfoNotification" object:nil userInfo:@{@"data":_dataArr}];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
- (IBAction)timeClickBut:(UIButton *)sender {

    __weak typeof(UIButton*) weakBtn = sender;
    [BRDatePickerView showDatePickerWithTitle:@"订单时间" dateType:UIDatePickerModeDate defaultSelValue:nil minDateStr:@"" maxDateStr:[NSDate currentDateString] isAutoSelect:YES resultBlock:^(NSString *selectValue) {
        
        
        NSDateFormatter *date = [[NSDateFormatter alloc]init];
        [date setDateFormat:@"yyyy-MM-dd"];
        NSDate *startD =[date dateFromString:selectValue];
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:startD];//前一天
        NSDate *nextDat = [NSDate dateWithTimeInterval:24*60*60 sinceDate:startD];//后一天
        
        locationStringBefore = [date stringFromDate:lastDay];
        locationStringAfter=[date stringFromDate:nextDat];
        [weakBtn setTitle:selectValue forState:UIControlStateNormal];
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
