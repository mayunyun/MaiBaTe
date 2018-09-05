//
//  TiXianViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/9/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TiXianViewController.h"
#import "TiXianRecordViewController.h"
@interface TiXianViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    UITextField *_nameField;
    UITextField *_numField;
    UITextField *_moneyField;
    UITextView *_otherView;
    UIButton *_tixianBut;
    NSString *_custname;//姓名
    NSString *_bankcard;//卡号
    NSString *_balance;//余额
    
}

@end

@implementation TiXianViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"钱包提现";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"记录 " style:UIBarButtonItemStylePlain target:self action:@selector(rightBarViewController:)];
    [self.navigationItem.rightBarButtonItem setTintColor:NavBarItemColor];
    
    [self loadNew];
    [self setTiXianUIView];
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
#pragma 在这里面请求数据
- (void)loadNew
{
    
    NSString *URLStr = @"/mbtwz/wallet?action=getCashInfo";
    
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"%@%@",DATA_ADDRESS,URLStr] refreshCache:YES params:nil success:^(id response) {
        [SVProgressHUD dismiss];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"我的>>>>%@",arr);
        if (arr.count>0) {
            _custname = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"custname"]];
            _bankcard = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"bankcard"]];
            _balance = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"balance"]];
            if(![_custname isEqualToString:@""]){
                _nameField.text = _custname;
            }
            if(![_bankcard isEqualToString:@""]){
                _numField.text = _bankcard;
            }
            if(![_balance isEqualToString:@""]){
                _moneyField.placeholder = [NSString stringWithFormat:@"您最大提现金额:￥%.2f元",[_balance floatValue]];
            }
            //判断是否已有提现申请
            if([[NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"isvalid"]] isEqualToString:@"0"]){
                [_tixianBut setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
                [_tixianBut setBackgroundColor:[UIColor grayColor]];
                _tixianBut.userInteractionEnabled = NO;
                jxt_showToastTitle(@"你已提交过申请！请等待审核", 1);
            }else{
                [_tixianBut setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
                [_tixianBut setBackgroundColor:[UIColor clearColor]];
                _tixianBut.userInteractionEnabled = YES;
            }
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}

- (void)setTiXianUIView{
    UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 64+20*MYWIDTH, 200, 20*MYWIDTH)];
    if (statusbarHeight>20) {
        textLab.frame = CGRectMake(15*MYWIDTH, 88+20*MYWIDTH, 200, 20*MYWIDTH);
    }
    textLab.text = @"请输入银行卡信息";
    textLab.textColor = UIColorFromRGB(0x333333);
    textLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textLab];
    
    UIView *Bgview1 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, textLab.bottom+15*MYWIDTH, UIScreenW-30*MYWIDTH, 100*MYWIDTH)];
    Bgview1.backgroundColor = [UIColor whiteColor];
    Bgview1.layer.cornerRadius = 8.0;
    [self.view addSubview:Bgview1];
    
    UIView *Bgview2 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, Bgview1.bottom+20*MYWIDTH, UIScreenW-30*MYWIDTH, 150*MYWIDTH)];
    Bgview2.backgroundColor = [UIColor whiteColor];
    Bgview2.layer.cornerRadius = 8.0;
    [self.view addSubview:Bgview2];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, 0, 60, 50*MYWIDTH)];
    nameLab.text = @"申请人";
    nameLab.textColor = UIColorFromRGB(0x333333);
    nameLab.font = [UIFont systemFontOfSize:15];
    [Bgview1 addSubview:nameLab];
    
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake(10*MYWIDTH+70, 0, Bgview1.width-90-20*MYWIDTH, 50*MYWIDTH)];
    _nameField.backgroundColor = [UIColor whiteColor];
    _nameField.placeholder = @"真实姓名";
    _nameField.delegate = self;
    _nameField.userInteractionEnabled = NO;
    _nameField.font = [UIFont systemFontOfSize:13];
    _nameField.textColor = [UIColor blackColor];
    [Bgview1 addSubview:_nameField];
    
    UILabel *numLab = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, 50*MYWIDTH, 60, 50*MYWIDTH)];
    numLab.text = @"卡号";
    numLab.textColor = UIColorFromRGB(0x333333);
    numLab.font = [UIFont systemFontOfSize:15];
    [Bgview1 addSubview:numLab];
    
    _numField = [[UITextField alloc]initWithFrame:CGRectMake(10*MYWIDTH+70, 50*MYWIDTH, Bgview1.width-90-20*MYWIDTH, 50*MYWIDTH)];
    _numField.backgroundColor = [UIColor whiteColor];
    _numField.placeholder = @"请输入银行卡号";
    _numField.delegate = self;
    _numField.font = [UIFont systemFontOfSize:13];
    _numField.textColor = [UIColor blackColor];
    _numField.keyboardType = UIKeyboardTypeNamePhonePad;
    [Bgview1 addSubview:_numField];
    
    UILabel *xian1 = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, 50*MYWIDTH, Bgview1.width-20*MYWIDTH, 1)];
    xian1.backgroundColor = UIColorFromRGB(0xF4F4F4);
    [Bgview1 addSubview:xian1];
    //
    
    //
    UILabel *moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, 0, 70, 70*MYWIDTH)];
    moneyLab.text = @"提现金额\n\n￥";
    moneyLab.numberOfLines = 4;
    moneyLab.textColor = UIColorFromRGB(0x333333);
    moneyLab.font = [UIFont systemFontOfSize:14];
    [Bgview2 addSubview:moneyLab];
    
    _moneyField = [[UITextField alloc]initWithFrame:CGRectMake(10*MYWIDTH+70, 40*MYWIDTH, Bgview1.width-90-20*MYWIDTH, 30*MYWIDTH)];
    _moneyField.backgroundColor = [UIColor whiteColor];
    _moneyField.delegate = self;
    _moneyField.font = [UIFont systemFontOfSize:13];
    _moneyField.textColor = [UIColor blackColor];
    _moneyField.keyboardType = UIKeyboardTypeNumberPad;
    [Bgview2 addSubview:_moneyField];
    
    UILabel *xian2 = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, 70*MYWIDTH, Bgview2.width-20*MYWIDTH, 1)];
    xian2.backgroundColor = UIColorFromRGB(0xF4F4F4);
    [Bgview2 addSubview:xian2];
    
    UILabel *otherLab = [[UILabel alloc]initWithFrame:CGRectMake(10*MYWIDTH, 70*MYWIDTH, 60, 50*MYWIDTH)];
    otherLab.text = @"备注:";
    otherLab.textColor = UIColorFromRGB(0x333333);
    otherLab.font = [UIFont systemFontOfSize:14];
    [Bgview2 addSubview:otherLab];
    
    _otherView = [[UITextView alloc]initWithFrame:CGRectMake(10*MYWIDTH+70, 75*MYWIDTH, Bgview1.width-90-20*MYWIDTH, 70*MYWIDTH)];
    _otherView.backgroundColor = [UIColor whiteColor];
    _otherView.delegate = self;
    _otherView.font = [UIFont systemFontOfSize:13];
    _otherView.textColor = [UIColor blackColor];
    [Bgview2 addSubview:_otherView];
    
    _tixianBut = [[UIButton alloc]init];
    [_tixianBut setFrame:CGRectMake(15*MYWIDTH,Bgview2.bottom+70*MYWIDTH, UIScreenW-30*MYWIDTH, 50*MYWIDTH)];
    ;
    [_tixianBut setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
    _tixianBut.layer.cornerRadius = 7;
    _tixianBut.layer.masksToBounds = YES;
    [_tixianBut setTitle:@"确认提现" forState:UIControlStateNormal];
    [_tixianBut addTarget:self action:@selector(tixianButClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tixianBut];
}

- (void)tixianButClicked{
    if ([_nameField.text isEqual:@""]) {
        jxt_showToastTitle(@"请填写提现人姓名", 1);
        return;
    }
    if ([_numField.text isEqual:@""]) {
        jxt_showToastTitle(@"请填写银行卡号", 1);
        return;
    }
    if ([_moneyField.text isEqual:@""]||[_moneyField.text intValue]==0) {
        jxt_showToastTitle(@"请填写提现金额", 1);
        return;
    }
    if ([_otherView.text isEqual:@""]) {
        jxt_showToastTitle(@"提现备注不能为空", 1);
        return;
    }
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    NSString *URLStr = @"/mbtwz/wallet?action=addGetCashInfo";
    NSDictionary* parmas = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\",\"custname\":\"%@\",\"bankcard\":\"%@\",\"money\":\"%@\",\"note\":\"%@\"}",_id,_nameField.text,_numField.text,_moneyField.text,_otherView.text]};
    NSLog(@"%@",parmas);
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:parmas success:^(id response) {
        NSString *str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        [SVProgressHUD dismiss];
        NSLog(@"我的>>>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            //字符串中有true串
            jxt_showToastTitle(@"提现申请成功", 1);
            TiXianRecordViewController *tixianJL = [[TiXianRecordViewController alloc]init];
            tixianJL.pushNum = 1;
            [self.navigationController pushViewController:tixianJL animated:YES];
        }else if ([str rangeOfString:@"false"].location!=NSNotFound){
            jxt_showToastTitle(@"提现申请失败", 1);
        }
        else{
            jxt_showToastTitle(str, 1);

        }
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"已经停止编辑");
    if (textView == _otherView) {
        if ([_otherView.text isEqual:@""]) {
            jxt_showToastTitle(@"提现备注不能为空", 1);
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSLog(@"已经停止编辑");
    if (textField == _moneyField) {
        if ([_moneyField.text floatValue] <= 0) {
            jxt_showToastTitle(@"请填写有效的提现金额", 1);
            _moneyField.text = nil;
            return;
        }
        if ([_moneyField.text floatValue]>[_balance floatValue]) {
            jxt_showToastTitle(@"账户余额没有这么多哦", 1);
            _moneyField.text = nil;
        }
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //判断是否是当前输入框
    if (_numField == textField) {
        NSString *text = _numField.text;
        //限制字符 至于那个\b用在search中 写不写都行
        NSCharacterSet* characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        //去掉空格
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        //检查除数字之外的字符 invertedSet:意思是取反,除了数字和退格的内容
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        //拼接text  要输入的部分+原有的
        text = [text stringByReplacingCharactersInRange:range withString:string];
        //去空格
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString* newString = @"";
        //四位添加空格
        while (text.length > 0) {
            NSString* subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        //去掉除数字部分
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        // 限制长度
        if (newString.length >= 24) {
            return NO;
        }
        //赋值
        [_numField setText:newString];
        return NO;
    }
    return YES;
}
- (void)rightBarViewController:(UIButton *)but{
    TiXianRecordViewController *tixianJL = [[TiXianRecordViewController alloc]init];
    tixianJL.pushNum = 0;
    [self.navigationController pushViewController:tixianJL animated:YES];
}


@end
