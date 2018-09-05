//
//  ForgetViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/8/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ForgetViewController.h"
#import "YZXTimeButton.h"
#define SendTime 60
@interface ForgetViewController ()<UITextFieldDelegate>
{
    UIView* _uppopView;         //上一页弹框
    UIView* _downpopView;       //下一页弹框
    YZXTimeButton* _ecodeBtn;
    UIButton* _nextBtn;
    UIButton* _okBtn;
    UITextField* _phoneField;   //手机号
    UITextField* _ecodeField;   //验证码
    UITextField* _pwdField;     //密码
    UITextField* _againpwdField;//确认密码
    NSString* _smscode;
    BOOL _isregist;
    
    
}
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)creatUI{
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
    imgView.image = [UIImage imageNamed:@"loginback"];
    imgView.userInteractionEnabled = YES;
    [self.view addSubview:imgView];
    UIImageView* logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0.5*(UIScreenW - 107*GMYWIDTH), 0.17*UIScreenH - 24*GMYWIDTH, 107*GMYWIDTH, 48*GMYWIDTH)];
    logoView.image = [UIImage imageNamed:@"logoView"];
    [imgView addSubview:logoView];
    
    CGRect leftFrame;
    leftFrame = CGRectMake(-2, 10, 60, 64);
    UIButton *leftButton= [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame =leftFrame;
    [leftButton addTarget:self action:@selector(dismissOverlayView) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"白色返回_想去"] forState:UIControlStateNormal];
    [imgView addSubview:leftButton];
    
    _uppopView = [[UIView alloc]initWithFrame:CGRectMake(50*GMYWIDTH, 0.34*UIScreenH, UIScreenW - 100*GMYWIDTH, 185*GMYWIDTH)];
    _uppopView.backgroundColor = [UIColor clearColor];
    _uppopView.layer.masksToBounds = YES;
    _uppopView.layer.cornerRadius = 10;
    [self.view addSubview:_uppopView];
    UIImageView* alphaView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _uppopView.width, _uppopView.height)];
    //    alphaView.backgroundColor = [UIColor whiteColor];
    //    alphaView.alpha = 0.8;
    alphaView.image = [UIImage imageNamed:@"uppopView"];
    [_uppopView addSubview:alphaView];
    
    UIImageView* phoneView = [[UIImageView alloc]initWithFrame:CGRectMake(20*GMYWIDTH, 32*GMYWIDTH, _uppopView.width - 40*GMYWIDTH, 42*GMYWIDTH)];
    phoneView.image = [UIImage imageNamed:@"phoneView"];
    phoneView.userInteractionEnabled = YES;
    [_uppopView addSubview:phoneView];
    UIImageView* phoneimgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*GMYWIDTH, 8*GMYWIDTH, 20*GMYWIDTH, phoneView.height - 16*GMYWIDTH)];
    phoneimgView.image = [UIImage imageNamed:@"phoneimgView"];
    [phoneView addSubview:phoneimgView];
    _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(50*GMYWIDTH, 0, phoneView.width - 50*GMYWIDTH, phoneView.height)];
    _phoneField.backgroundColor = [UIColor clearColor];
    _phoneField.placeholder = @"请输入您的手机号";
    _phoneField.delegate = self;
    _phoneField.textColor = [UIColor whiteColor];
    _phoneField.textAlignment = NSTextAlignmentCenter;
    _phoneField.font = [UIFont systemFontOfSize:14*GMYWIDTH];
    [phoneView addSubview:_phoneField];
    [Command placeholderColor:_phoneField str:_phoneField.placeholder color:[UIColor whiteColor]];
    
    UIImageView* ecodeView = [[UIImageView alloc]initWithFrame:CGRectMake(phoneView.left, phoneView.bottom+25*GMYWIDTH, 150*GMYWIDTH, phoneView.height)];
    ecodeView.userInteractionEnabled = YES;
    ecodeView.image = [UIImage imageNamed:@"ecodeView"];
    [_uppopView addSubview:ecodeView];
    UIImageView* ecodeimgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*GMYWIDTH, 8*GMYWIDTH, 20*GMYWIDTH, ecodeView.height - 16*GMYWIDTH)];
    ecodeimgView.image = [UIImage imageNamed:@"ecodeimgView"];
    [ecodeView addSubview:ecodeimgView];
    _ecodeField = [[UITextField alloc]initWithFrame:CGRectMake(50*GMYWIDTH, 0, ecodeView.width - 50*GMYWIDTH, ecodeView.height)];
    _ecodeField.backgroundColor = [UIColor clearColor];
    _ecodeField.placeholder = @"填写验证码";
    _ecodeField.textAlignment = NSTextAlignmentCenter;
    _ecodeField.font = [UIFont systemFontOfSize:14*GMYWIDTH];
    _ecodeField.delegate = self;
    [ecodeView addSubview:_ecodeField];
    [Command placeholderColor:_ecodeField str:_ecodeField.placeholder color:[UIColor whiteColor]];
    
    _ecodeBtn = [[YZXTimeButton alloc]initWithFrame:CGRectMake(ecodeView.right+5*GMYWIDTH, ecodeView.top, phoneView.width - ecodeView.width - 5*GMYWIDTH, ecodeView.height)];
    [_ecodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_ecodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _ecodeBtn.titleLabel.font = [UIFont systemFontOfSize:12*GMYWIDTH];
    [_ecodeBtn setBackgroundImage:[UIImage imageNamed:@"ecodeBtn"] forState:UIControlStateNormal];
    _ecodeBtn.layer.masksToBounds = YES;
    _ecodeBtn.layer.cornerRadius = 5;
    _ecodeBtn.layer.shadowColor=[UIColor blackColor].CGColor;
    _ecodeBtn.layer.shadowOffset=CGSizeMake(0, 0);
    _ecodeBtn.layer.shadowOpacity=0.5;
    _ecodeBtn.layer.shadowRadius= 5;
    _ecodeBtn.clipsToBounds = false;
    [_uppopView addSubview:_ecodeBtn];
    [_ecodeBtn addTarget:self action:@selector(ecodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _nextBtn.frame = CGRectMake(95*GMYWIDTH, _uppopView.bottom+45*GMYWIDTH, UIScreenW - 190*GMYWIDTH, 45*GMYWIDTH);
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:16*GMYWIDTH];
    _nextBtn.layer.masksToBounds = YES;
    _nextBtn.layer.cornerRadius = 18*GMYWIDTH;
    _nextBtn.layer.shadowColor=[UIColor blackColor].CGColor;
    _nextBtn.layer.shadowOffset=CGSizeMake(0, 0);
    _nextBtn.layer.shadowOpacity=0.5;
    _nextBtn.layer.shadowRadius= 10*GMYWIDTH;
    _nextBtn.clipsToBounds = false;
    [self.view addSubview:_nextBtn];
    [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _downpopView = [[UIView alloc]initWithFrame:CGRectMake(36*GMYWIDTH, 0.294*UIScreenH, UIScreenW - 72*GMYWIDTH, 240*GMYWIDTH - 42*GMYWIDTH)];
    _downpopView.backgroundColor = [UIColor clearColor];
    _downpopView.layer.masksToBounds = YES;
    _downpopView.layer.cornerRadius = 10*GMYWIDTH;
    [self.view addSubview:_downpopView];
    _downpopView.hidden = YES;
    UIImageView* alphaView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _downpopView.width, _downpopView.height)];
    alphaView1.image = [UIImage imageNamed:@"uppopView"];
    [_downpopView addSubview:alphaView1];
    
    UIImageView* pwdView = [[UIImageView alloc]initWithFrame:CGRectMake(15*GMYWIDTH, 35*GMYWIDTH, _downpopView.width - 30*GMYWIDTH, 42*GMYWIDTH)];
    pwdView.image = [UIImage imageNamed:@"phoneView"];
    pwdView.userInteractionEnabled = YES;
    [_downpopView addSubview:pwdView];
    UIImageView* pwdimgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*GMYWIDTH, 8*GMYWIDTH, 20*GMYWIDTH, pwdView.height - 16*GMYWIDTH)];
    pwdimgView.image = [UIImage imageNamed:@"pwdimgView1"];
    [pwdView addSubview:pwdimgView];
    _pwdField = [[UITextField alloc]initWithFrame:CGRectMake(40*GMYWIDTH, 0, pwdView.width - 40*GMYWIDTH, pwdView.height)];
    _pwdField.backgroundColor = [UIColor clearColor];
    _pwdField.placeholder = @"请填写密码";
    _pwdField.secureTextEntry = YES;
    _pwdField.textAlignment = NSTextAlignmentRight;
    _pwdField.font = [UIFont systemFontOfSize:13*GMYWIDTH];
    _pwdField.delegate = self;
    [pwdView addSubview:_pwdField];
    [Command placeholderColor:_pwdField str:_pwdField.placeholder color:[UIColor whiteColor]];
    
    UILabel* pwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(pwdView.left, pwdView.bottom, pwdView.width, 15*GMYWIDTH)];
    pwdLabel.text = @"由数字、字母、下划线组成的6-15位密码";
    pwdLabel.textColor = [UIColor lightGrayColor];
    pwdLabel.backgroundColor = [UIColor clearColor];
    pwdLabel.font = [UIFont systemFontOfSize:10*GMYWIDTH];
    [_downpopView addSubview:pwdLabel];
    
    UIImageView* againpwdView = [[UIImageView alloc]initWithFrame:CGRectMake(pwdView.left, pwdView.bottom+20*GMYWIDTH, pwdView.width, pwdView.height)];
    againpwdView.image = [UIImage imageNamed:@"phoneView"];
    againpwdView.userInteractionEnabled = YES;
    [_downpopView addSubview:againpwdView];
    UIImageView* againimgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*GMYWIDTH, 8*GMYWIDTH, 20*GMYWIDTH, againpwdView.height - 16*GMYWIDTH)];
    againimgView.image= [UIImage imageNamed:@"pwdimgView1"];
    [againpwdView addSubview:againimgView];
    _againpwdField = [[UITextField alloc]initWithFrame:CGRectMake(40*GMYWIDTH, 0, againpwdView.width - 40*GMYWIDTH, againpwdView.height)];
    _againpwdField.backgroundColor = [UIColor clearColor];
    _againpwdField.textAlignment = NSTextAlignmentRight;
    _againpwdField.placeholder = @"请确认密码";
    _againpwdField.secureTextEntry = YES;
    _againpwdField.font = [UIFont systemFontOfSize:13*GMYWIDTH];
    _againpwdField.delegate = self;
    [againpwdView addSubview:_againpwdField];
    [Command placeholderColor:_againpwdField str:_againpwdField.placeholder color:[UIColor whiteColor]];
    
    _okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _okBtn.frame = CGRectMake(95*GMYWIDTH, _downpopView.bottom+45*GMYWIDTH, UIScreenW - 190*GMYWIDTH, 45*GMYWIDTH);
    [_okBtn setBackgroundImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
    [_okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _okBtn.titleLabel.font = [UIFont systemFontOfSize:16*GMYWIDTH];
    _okBtn.layer.masksToBounds = YES;
    _okBtn.layer.cornerRadius = 18*GMYWIDTH;
    _okBtn.layer.shadowColor=[UIColor blackColor].CGColor;
    _okBtn.layer.shadowOffset=CGSizeMake(0, 0);
    _okBtn.layer.shadowOpacity=0.5;
    _okBtn.layer.shadowRadius= 10*GMYWIDTH;
    _okBtn.clipsToBounds = false;
    [self.view addSubview:_okBtn];
    _okBtn.hidden = YES;
    [_okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}



- (void)ecodeBtnClick:(YZXTimeButton*)sender{
    [_phoneField resignFirstResponder];
    if ([CommonUtils isValidatePhoneNum:_phoneField.text]) {
        [self isExitsPhoneRequest];
    }else{
        jxt_showToastTitle(@"手机号格式不正确", 1);
    }
    
    
}

- (void)nextBtnClick:(UIButton*)sender{
    NSLog(@"%@%@",_ecodeField.text,_smscode);
    
    if ([_ecodeField.text isEqualToString:_smscode]&&!IsEmptyValue(_ecodeField.text)) {
        _uppopView.hidden = YES;
        _downpopView.hidden = NO;
        _nextBtn.hidden = YES;
        _okBtn.hidden = NO;
    }else{
        jxt_showToastTitle(@"验证码输入不正确", 1);
    }
}

- (void)okBtnClick:(UIButton*)sender{
        if ([Command isPassword:_pwdField.text]) {
            if ([Command isPassword:_pwdField.text]) {
                if ([_pwdField.text isEqualToString:_againpwdField.text]&&!IsEmptyValue(_pwdField.text)) {
                    [self registRequest];
                    
                }else{
                    jxt_showToastTitle(@"两次输入的密码不一致", 1);
                }
            }else{
                jxt_showToastTitle(@"密码格式不正确", 1);
            }
        }else{
            jxt_showToastTitle(@"密码格式不正确", 1);
        }
}

- (void)isExitsPhoneRequest{
    /*
     /mbtwz/register?action=isExitsPhone   "+callback1
     phone  放在data中
     */
    _phoneField.text = [Command convertNull:_phoneField.text];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",_phoneField.text]};
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"/mbtwz/register?action=isExitsPhone"] refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSSLog(@">>>%@",str);
        //true,注册了；false,未注册
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            _isregist = YES;
            if (_isregist) {
                _ecodeBtn.recoderTime = @"yes";
                [_ecodeBtn setKaishi:SendTime];
                [self receiveEcodeRequestF];
            }
        }else{
            _isregist = NO;
            jxt_showToastTitle(@"该手机号未注册", 1);
        }
        
        
    } fail:^(NSError *error) {
        
    }];
    
}

- (void)receiveEcodeRequestF{
    /*
     /mbtwz/register?action=getSMSCode"+callback1
     参数：phone  放在params中
     */
    NSString* urlstr = @"/mbtwz/register?action=getSMSCode";
    _phoneField.text = [Command convertNull:_phoneField.text];
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",_phoneField.text]};
    [SVProgressHUD showWithStatus:@"正在加载..."];
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
        [SVProgressHUD dismiss];
    }];
    
    
}



- (void)registRequest{
    /*
     /mbtwz/register?action=upPassword"+callback1  
     参数：phone password 放在data中
     */
    NSString* urlstr = @"/mbtwz/register?action=upPassword";
    _phoneField.text = [Command convertNull:_phoneField.text];
    _pwdField.text = [Command convertNull:_pwdField.text];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\",\"password\":\"%@\"}",_phoneField.text,_pwdField.text]};
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id response) {
        [SVProgressHUD dismiss];
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSSLog(@">>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            jxt_showToastTitle(@"密码修改成功", 1);
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",_pwdField.text] forKey:PASSWORD];

            UIViewController *rootVC = self.presentingViewController;
            while (rootVC.presentingViewController) {
                rootVC = rootVC.presentingViewController;
            }
            [rootVC dismissViewControllerAnimated:YES completion:nil];
        }else{
            jxt_showToastTitle(@"密码修改失败", 1);
        }
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
    
}

- (void)dismissOverlayView{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
