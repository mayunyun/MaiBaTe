//
//  ReplacePwdViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/9/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ReplacePwdViewController.h"
#import "YZXTimeButton.h"
#define SendTime 60
@interface ReplacePwdViewController ()<UITextFieldDelegate>
{
    UIView* _uppopView;         //上一页弹框
    UIView* _downpopView;       //下一页弹框
    YZXTimeButton* _ecodeBtn;
    UIButton* _okBtn;
    UITextField* _phoneField;   //手机号
    UITextField* _ecodeField;   //验证码
    UITextField* _pwdField;     //密码
    UITextField* _againpwdField;//确认密码
    NSString* _smscode;
    BOOL _isregist;
}
@end

@implementation ReplacePwdViewController
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
    self.navigationItem.title = @"修改密码";
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



- (void)creatUI{
    UIScrollView* bgsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
    bgsView.contentSize = CGSizeMake(UIScreenW, 500);
    bgsView.bounces = NO;
    bgsView.showsVerticalScrollIndicator = NO;
    bgsView.showsHorizontalScrollIndicator = NO;
    bgsView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgsView];

    _uppopView = [[UIView alloc]initWithFrame:CGRectMake(15*GMYWIDTH, 40*GMYWIDTH, UIScreenW - 30*GMYWIDTH, 150*GMYWIDTH)];
    _uppopView.backgroundColor = [UIColor clearColor];
    _uppopView.layer.masksToBounds = YES;
    _uppopView.layer.cornerRadius = 10;
    [bgsView addSubview:_uppopView];
    UIImageView* alphaView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _uppopView.width, _uppopView.height)];
    alphaView.image = [UIImage imageNamed:@"uppopView"];
    [_uppopView addSubview:alphaView];
    
    UIImageView* phoneimgView = [[UIImageView alloc]initWithFrame:CGRectMake(40*GMYWIDTH, 27.5*GMYWIDTH, 20*GMYWIDTH, 25*GMYWIDTH)];
    phoneimgView.image = [UIImage imageNamed:@"修改手机"];
    [_uppopView addSubview:phoneimgView];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(phoneimgView.right+20*GMYWIDTH, 25*GMYWIDTH, _uppopView.width - 2*phoneimgView.left - phoneimgView.width - 20*GMYWIDTH, 30*GMYWIDTH)];
    if ([user objectForKey:USERPHONE]) {
        _phoneField.text = [user objectForKey:USERPHONE];
    }
    [_phoneField setBackground:[UIImage imageNamed:@"nameView"]];
    _phoneField.placeholder = @"请输入您的手机号 ";
    _phoneField.delegate = self;
    _phoneField.textColor = [UIColor whiteColor];
    _phoneField.textAlignment = NSTextAlignmentRight;
    _phoneField.font = [UIFont systemFontOfSize:12*GMYWIDTH];
    _phoneField.layer.masksToBounds = YES;
    _phoneField.layer.cornerRadius = 5;
    [_uppopView addSubview:_phoneField];
    [Command placeholderColor:_phoneField str:_phoneField.placeholder color:[UIColor whiteColor]];
    
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(0, _uppopView.height/2, _uppopView.width, 0.5)];
    line1.backgroundColor = UIColorFromRGB(MYLine);
    [_uppopView addSubview:line1];
    
    UIImageView* ecodeimgView = [[UIImageView alloc]initWithFrame:CGRectMake(phoneimgView.left, line1.bottom+15*GMYWIDTH+2.5*GMYWIDTH, 20*GMYWIDTH, 25*GMYWIDTH)];
    ecodeimgView.image = [UIImage imageNamed:@"修改验证码"];
    [_uppopView addSubview:ecodeimgView];
    _ecodeField = [[UITextField alloc]initWithFrame:CGRectMake(ecodeimgView.right+20*GMYWIDTH, line1.bottom+15*GMYWIDTH, _uppopView.width - ecodeimgView.left*2 - ecodeimgView.width - 20*GMYWIDTH - 80*GMYWIDTH, _phoneField.height)];
    [_ecodeField setBackground:[UIImage imageNamed:@"nameView"]];
    _ecodeField.placeholder = @"填写验证码";
    _ecodeField.textAlignment = NSTextAlignmentCenter;
    _ecodeField.font = _phoneField.font;
    [_uppopView addSubview:_ecodeField];
    [Command placeholderColor:_ecodeField str:_ecodeField.placeholder color:[UIColor whiteColor]];
    
    _ecodeBtn = [[YZXTimeButton alloc]initWithFrame:CGRectMake(_ecodeField.right+10*GMYWIDTH, _ecodeField.top, 70*GMYWIDTH, _ecodeField.height)];
    [_ecodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_ecodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_ecodeBtn setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
    _ecodeBtn.titleLabel.font = [UIFont systemFontOfSize:12*GMYWIDTH];
    _ecodeBtn.layer.masksToBounds = YES;
    _ecodeBtn.layer.cornerRadius = 5;
    [_uppopView addSubview:_ecodeBtn];
    [_ecodeBtn addTarget:self action:@selector(ecodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _downpopView = [[UIView alloc]initWithFrame:CGRectMake(_uppopView.left  , _uppopView.bottom+10*GMYWIDTH, _uppopView.width, _uppopView.height)];
    _downpopView.backgroundColor = [UIColor clearColor];
    _downpopView.layer.masksToBounds = YES;
    _downpopView.layer.cornerRadius = 10*GMYWIDTH;
    [bgsView addSubview:_downpopView];
    UIImageView* alphaView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _downpopView.width, _downpopView.height)];
    alphaView1.image = [UIImage imageNamed:@"uppopView"];
    [_downpopView addSubview:alphaView1];
    
    UIImageView* pwdimgView = [[UIImageView alloc]initWithFrame:CGRectMake(phoneimgView.left, phoneimgView.top, phoneimgView.width, phoneimgView.height )];
    pwdimgView.image = [UIImage imageNamed:@"修改密码"];
    [_downpopView addSubview:pwdimgView];
    _pwdField = [[UITextField alloc]initWithFrame:CGRectMake(_phoneField.left, _phoneField.top, _phoneField.width, _phoneField.height)];
    [_pwdField setBackground:[UIImage imageNamed:@"nameView"]];
    _pwdField.placeholder = @"请设置新密码 ";
    _pwdField.secureTextEntry = YES;
    _pwdField.textAlignment = NSTextAlignmentRight;
    _pwdField.font = _ecodeField.font;
    [_downpopView addSubview:_pwdField];
    [Command placeholderColor:_pwdField str:_pwdField.placeholder color:[UIColor whiteColor]];
    
    UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(0, _downpopView.height/2, _downpopView.width, 0.5)];
    line2.backgroundColor = line1.backgroundColor;
    [_downpopView addSubview:line2];
    
    UIImageView* againimgView = [[UIImageView alloc]initWithFrame:CGRectMake(pwdimgView.left, line2.bottom+15*GMYWIDTH+2.5*GMYWIDTH, 20*GMYWIDTH, 25*GMYWIDTH)];
    againimgView.image= [UIImage imageNamed:@"修改密码"];
    [_downpopView addSubview:againimgView];
    _againpwdField = [[UITextField alloc]initWithFrame:CGRectMake(againimgView.right+20*GMYWIDTH, line2.bottom+15*GMYWIDTH, _pwdField.width, _pwdField.height)];
    [_againpwdField setBackground:[UIImage imageNamed:@"nameView"]];
    _againpwdField.textAlignment = NSTextAlignmentRight;
    _againpwdField.placeholder = @"请再次确认新密码 ";
    _againpwdField.secureTextEntry = YES;
    _againpwdField.font = _pwdField.font;
    [_downpopView addSubview:_againpwdField];
    [Command placeholderColor:_againpwdField str:_againpwdField.placeholder color:[UIColor whiteColor]];
    
    _okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _okBtn.frame = CGRectMake(30*GMYWIDTH, _downpopView.bottom+70*GMYWIDTH, UIScreenW - 60*GMYWIDTH, 36*GMYWIDTH);
    [_okBtn setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
    [_okBtn setTitle:@"完  成" forState:UIControlStateNormal];
    [_okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _okBtn.titleLabel.font = [UIFont systemFontOfSize:16*GMYWIDTH];
    _okBtn.layer.masksToBounds = YES;
    _okBtn.layer.cornerRadius = 5*GMYWIDTH;
    [bgsView addSubview:_okBtn];
    [_okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)ecodeBtnClick:(UIButton*)seder{
    [_phoneField resignFirstResponder];
    if ([CommonUtils isValidatePhoneNum:_phoneField.text]) {
        NSString* phone = [[NSUserDefaults standardUserDefaults]objectForKey:USERPHONE];
        if ([_phoneField.text isEqualToString:phone]) {
            [self isExitsPhoneRequest];
        }else{
            jxt_showToastTitle(@"此手机号不是当前登录用户", 1);
        }
    }else{
        jxt_showToastTitle(@"手机号格式不正确", 1);
    }
    

}

- (void)okBtnClick:(UIButton*)sender{
    if ([_ecodeField.text isEqualToString:_smscode]&&!IsEmptyValue(_ecodeField.text)) {
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

    }else{
        jxt_showToastTitle(@"验证码输入不正确", 1);
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
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSSLog(@">>>%@",str);
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            jxt_showToastTitle(@"验证码发送失败", 1);
        }else{
            str = [Command replaceAllOthers:str];
            _smscode = [NSString stringWithFormat:@"%@",str];
        }
        
        
    } fail:^(NSError *error) {
        
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
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSSLog(@">>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            jxt_showToastTitle(@"密码修改成功", 1);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            jxt_showToastTitle(@"密码修改失败", 1);
        }
    } fail:^(NSError *error) {
        
    }];
    
    
}


@end
