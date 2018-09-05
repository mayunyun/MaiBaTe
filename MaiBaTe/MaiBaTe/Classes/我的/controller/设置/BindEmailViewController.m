//
//  BindEmailViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/8/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BindEmailViewController.h"
#import "YZXTimeButton.h"
#define SendTime 60
@interface BindEmailViewController ()
{
    UITextField* _emailField;
    UITextField* _ecodeField;
    YZXTimeButton* _ecodeBtn;
    NSString* _smscode;
}

@end

@implementation BindEmailViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定邮箱";
    [self creatUI];
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
- (void)backpop:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    UIImageView* bgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*GMYWIDTH, (35+64)*GMYWIDTH, UIScreenW - 30*GMYWIDTH, 150*GMYWIDTH)];
    bgView.userInteractionEnabled = YES;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    UIView* vline = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.height/2, bgView.width, 0.5)];
    vline.backgroundColor = UIColorFromRGB(MYLine);
    [bgView addSubview:vline];
    
    UIImageView* emailimgView = [[UIImageView alloc]initWithFrame:CGRectMake(40*GMYWIDTH, 25*GMYWIDTH, 25*GMYWIDTH, 25*GMYWIDTH)];
    emailimgView.contentMode = UIViewContentModeScaleAspectFit;
    emailimgView.image = [UIImage imageNamed:@"邮箱名"];
    [bgView addSubview:emailimgView];
    _emailField = [[UITextField alloc]initWithFrame:CGRectMake(emailimgView.right+20*GMYWIDTH, 22.5*GMYWIDTH, bgView.width - 2*emailimgView.left - 20*GMYWIDTH, 30*GMYWIDTH)];
    _emailField.layer.masksToBounds = YES;
    _emailField.layer.cornerRadius = 5;
    [_emailField setBackground:[UIImage imageNamed:@"nameView"]];
    _emailField.placeholder = @"请输入您的邮箱地址";
    _emailField.textAlignment = NSTextAlignmentCenter;
    _emailField.font = [UIFont systemFontOfSize:12*GMYWIDTH];
    [bgView addSubview:_emailField];
    [Command placeholderColor:_emailField str:_emailField.placeholder color:[UIColor whiteColor]];
    
    UIImageView* ecodeimgView = [[UIImageView alloc]initWithFrame:CGRectMake(emailimgView.left, emailimgView.top+75*GMYWIDTH, 25*GMYWIDTH, 25*GMYWIDTH)];
    ecodeimgView.contentMode = UIViewContentModeScaleAspectFit;
    ecodeimgView.image = [UIImage imageNamed:@"邮箱验证码"];
    [bgView addSubview:ecodeimgView];
    _ecodeField = [[UITextField alloc]initWithFrame:CGRectMake(ecodeimgView.right+20*GMYWIDTH, ecodeimgView.top-2.5*GMYWIDTH, bgView.width - ecodeimgView.left*2 - 20*GMYWIDTH - 80*GMYWIDTH, 30*GMYWIDTH)];
    _ecodeField.layer.masksToBounds = YES;
    _ecodeField.layer.cornerRadius = 5;
    _ecodeField.placeholder = @"填写验证码";
    _ecodeField.textAlignment = NSTextAlignmentCenter;
    [_ecodeField setBackground:[UIImage imageNamed:@"nameView"]];
    _ecodeField.font = [UIFont systemFontOfSize:12*GMYWIDTH];
    [bgView addSubview:_ecodeField];
    [Command placeholderColor:_ecodeField str:_ecodeField.placeholder color:[UIColor whiteColor]];
    _ecodeBtn = [[YZXTimeButton alloc]initWithFrame:CGRectMake(_ecodeField.right+10*GMYWIDTH, _ecodeField.top, 70*GMYWIDTH, 30*GMYWIDTH)];
    [_ecodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_ecodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _ecodeBtn.titleLabel.font = [UIFont systemFontOfSize:13*GMYWIDTH];
    _ecodeBtn.backgroundColor = UIColorFromRGB(MYOrange);
    [bgView addSubview:_ecodeBtn];
    [_ecodeBtn addTarget:self action:@selector(ecodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    okBtn.frame = CGRectMake(15*GMYWIDTH, bgView.bottom+40*GMYWIDTH, UIScreenW - 30*GMYWIDTH, 35*GMYWIDTH);
    [okBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.cornerRadius = 5;
    [okBtn setBackgroundColor: UIColorFromRGB(MYOrange)];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:15*GMYWIDTH];
    [self.view addSubview:okBtn];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)ecodeBtnClick:(YZXTimeButton*)sender{
    if (!IsEmptyValue(_emailField.text)&&[CommonUtils isValidateEmail:_emailField.text]) {
        sender.recoderTime = @"yes";
        [sender setKaishi:SendTime];
        [self receiveEcodeRequestF];
    }else{
        jxt_showToastTitle(@"邮箱不合法", 1);
    }

}
- (void)okBtnClick:(UIButton*)sender{
    if ([_ecodeField.text isEqualToString:_smscode]&&!IsEmptyValue(_ecodeField.text)) {
        [self dataRequest];
    }else{
        jxt_showToastTitle(@"验证码填写不正确", 1);
    }

}

- (void)receiveEcodeRequestF{
    /*
     /mbtwz/wxcustomer?action=sendEmailNum    获取验证码
     email  邮箱   data传
     */
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSString* urlstr = @"/mbtwz/register?action=getSMSCodeEmail";
    _emailField.text = [Command convertNull:_emailField.text];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"email\":\"%@\"}",_emailField.text]};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id response) {
        [SVProgressHUD dismiss];
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSSLog(@">>>%@",str);
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            jxt_showToastTitle(@"验证码发送失败", 1);
        }else{
            str = [Command replaceAllOthers:str];
            _smscode = [NSString stringWithFormat:@"%@",str];
        }
        
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
    }];
    
    
}



- (void)dataRequest{
    /*
     /mbtwz/wxcustomer?action=addEmailNum    点击完成
     email  邮箱
     */
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSString* urlstr = @"/mbtwz/wxcustomer?action=addEmailNum";
    _emailField.text = [Command convertNull:_emailField.text];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"email\":\"%@\"}",_emailField.text]};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id response) {
        [SVProgressHUD dismiss];
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSSLog(@">>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            jxt_showToastTitle(@"已成功绑定邮箱", 1);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            jxt_showToastTitle(@"绑定邮箱失败", 1);
        }
        
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];

}


@end
