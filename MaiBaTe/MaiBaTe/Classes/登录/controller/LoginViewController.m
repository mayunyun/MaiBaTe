//
//  LoginViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/8/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "AccountModel.h"
#import "ForgetViewController.h"
#import "JPUSHService.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField* _userField;
    UITextField* _pwdField;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    
    
}


- (void)creatUI{
    
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
    imgView.image = [UIImage imageNamed:@"loginback"];
    imgView.userInteractionEnabled = YES;
    [self.view addSubview:imgView];
    
    CGRect leftFrame;
    leftFrame = CGRectMake(-2, 10, 60, 64);
    UIButton *leftButton= [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame =leftFrame;
    [leftButton addTarget:self action:@selector(dismissOverlayView) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"白色返回_想去"] forState:UIControlStateNormal];
    [imgView addSubview:leftButton];
    
    UIImageView* logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0.5*(UIScreenW - 107*GMYWIDTH), 0.17*UIScreenH - 24*GMYWIDTH, 107*GMYWIDTH, 48*GMYWIDTH)];
    logoView.image = [UIImage imageNamed:@"logoView"];
    [imgView addSubview:logoView];
    
    UIImageView* userView = [[UIImageView alloc]initWithFrame:CGRectMake(50*GMYWIDTH, 0.34*UIScreenH, UIScreenW - 100*GMYWIDTH, 50*GMYWIDTH)];
    userView.userInteractionEnabled = YES;
    userView.image = [UIImage imageNamed:@"userView"];
    [self.view addSubview:userView];
    UIImageView* userimgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, userView.height - 30, userView.height - 30)];
    userimgView.image = [UIImage imageNamed:@"userimgView"];
    [userView addSubview:userimgView];
    _userField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, userView.width , userView.height)];
    _userField.backgroundColor = [UIColor clearColor];
    _userField.placeholder = @" 请输入用户名/手机号";
    _userField.keyboardType = UIKeyboardTypeDefault;
    _userField.textAlignment =  NSTextAlignmentCenter;
    _userField.font = [UIFont systemFontOfSize:13*GMYWIDTH];
    _userField.textColor = [UIColor whiteColor];
    _userField.delegate = self;
    [userView addSubview:_userField];
    [Command placeholderColor:_userField str:_userField.placeholder color:[UIColor whiteColor]];

    
    UIImageView* pwdView = [[UIImageView alloc]initWithFrame:CGRectMake(userView.left, userView.bottom+20*GMYWIDTH, userView.width, userView.height)];
    pwdView.userInteractionEnabled = YES;
    pwdView.image = [UIImage imageNamed:@"userView"];
    [self.view addSubview:pwdView];
    UIImageView* pwdimgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, pwdView.height - 30, pwdView.height - 30)];
    pwdimgView.image = [UIImage imageNamed:@"pwdimgView"];
    [pwdView addSubview:pwdimgView];
    _pwdField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, pwdView.width , pwdView.height)];//- 50
    _pwdField.backgroundColor = [UIColor clearColor];
    _pwdField.placeholder = @"请输入密码";
    _pwdField.secureTextEntry = YES;
    _pwdField.textColor = [UIColor whiteColor];
    _pwdField.font = [UIFont systemFontOfSize:13*GMYWIDTH];
    _pwdField.textAlignment = NSTextAlignmentCenter;
    _pwdField.delegate = self;
    [pwdView addSubview:_pwdField];
    [Command placeholderColor:_pwdField str:_pwdField.placeholder color:[UIColor whiteColor]];
    
    UIButton* forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    forgetPwdBtn.frame = CGRectMake(pwdView.right - 100, pwdView.bottom+5*GMYWIDTH, 100, 25*GMYWIDTH) ;
    forgetPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:12*GMYWIDTH];
    [forgetPwdBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetPwdBtn setTitleColor:COLOR(250, 166, 8, 1) forState:UIControlStateNormal];
    [self.view addSubview:forgetPwdBtn];
    [Command addUnderline:forgetPwdBtn str:@"忘记密码？" color:UIColorFromRGB(MYOrange)];
    [forgetPwdBtn addTarget:self action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(pwdView.left+45*GMYWIDTH, pwdView.bottom+50*GMYWIDTH, pwdView.width - 90*GMYWIDTH, 45*GMYWIDTH);
    
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 20;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18*GMYWIDTH];
//    [loginBtn setBackgroundColor:UIColorFromRGB(MYOrange)];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginBtnView"] forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(32, loginBtn.bottom+82*GMYWIDTH, UIScreenW - 64, 2*GMYWIDTH)];
    bottomLine.image = [UIImage imageNamed:@"bottomLine"];
    [self.view addSubview:bottomLine];
    
    UIButton* registBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registBtn.frame = CGRectMake(loginBtn.left + 10*GMYWIDTH, bottomLine.bottom+10*GMYWIDTH, loginBtn.width - 20*GMYWIDTH, 40*GMYWIDTH);
//    [registBtn setBackgroundColor:COLOR(130, 130, 130, 0.6)];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"registBtn"] forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:14*GMYWIDTH];
    [registBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    [self.view addSubview:registBtn];
    [registBtn addTarget:self action:@selector(registBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)forgetBtnClick:(UIButton*)sender{
    ForgetViewController* vc = [[ForgetViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];

}

- (void)loginBtnClick:(UIButton*)sender{
    if (!IsEmptyValue(_userField.text)) {
        if (!IsEmptyValue(_pwdField.text)) {
            [self loginRequest];
        }else{
            jxt_showToastTitle(@"密码未填写", 1);
        }
    }else{
        jxt_showToastTitle(@"用户名未填写", 1);
    }
}

- (void)registBtnClick:(UIButton*)sender{
    RegistViewController* vc = [[RegistViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)dismissOverlayView{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)loginRequest{
    /*
     登录接口：/mbtwz/mallLogin?action=checkMallLogin"+callback1
     参数：account  ，password放在data中
     */
    NSString *urlstr = @"/mbtwz/mallLogin?action=checkMallLogin";
    _userField.text = [Command convertNull:_userField.text];
    _pwdField.text = [Command convertNull:_pwdField.text];
    NSDictionary* parmas = @{@"data":[NSString stringWithFormat:@"{\"account\":\"%@\",\"password\":\"%@\"}",_userField.text,_pwdField.text]};
    [SVProgressHUD showWithStatus:@"正在登录..."];
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id response) {
        [SVProgressHUD dismiss];
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSSLog(@">>>%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"用户信息%@",array);
        if (!IsEmptyValue(array)) {
            AccountModel* model = [[AccountModel alloc]init];
            [model setValuesForKeysWithDictionary:array[0]];
            if ([[NSString stringWithFormat:@"%@",model.isvalid] integerValue] == 1) {
                //账户启用
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",model.Id] forKey:USERID];
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",model.custname] forKey:USENAME];
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",model.custphone] forKey:USERPHONE];
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",model.password] forKey:PASSWORD];
                
                [self joinJPush:[NSString stringWithFormat:@"%@",model.custphone]];

                [self dismissOverlayView];
            }else{
                jxt_showToastTitle(@"该账户已停用", 1);
            }
        }else{
            jxt_showToastTitle(@"账户或密码不正确", 1);
        }
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark 用户+标签、别名
-(void)joinJPush:(NSString *)tag{
    //    NSLog(@"%@",tag);
   
    [JPUSHService setAlias:tag completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {

    } seq:arc4random()%100];
//    NSSet * set = [[NSSet alloc] initWithObjects:@"abc",@"one", nil];
//
//    [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//
//    } seq:0];
}
@end
