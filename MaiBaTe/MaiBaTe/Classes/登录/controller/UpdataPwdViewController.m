//
//  UpdataPwdViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/8/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "UpdataPwdViewController.h"

@interface UpdataPwdViewController ()<UITextFieldDelegate>
{
    UIView* _downpopView;       //下一页弹框
    UIButton* _okBtn;
    UITextField* _pwdField;     //密码
    UITextField* _againpwdField;//确认密码
    
    
}

@end

@implementation UpdataPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)creatUI{
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
    imgView.image = [UIImage imageNamed:@"loginback"];
    imgView.userInteractionEnabled = YES;
    [self.view addSubview:imgView];
    UIImageView* logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0.5*(UIScreenW - 107), 0.17*UIScreenH - 24, 107, 48)];
    logoView.image = [UIImage imageNamed:@"logoView"];
    [imgView addSubview:logoView];
    
    CGRect leftFrame;
    leftFrame = CGRectMake(-2, 10, 60, 64);
    UIButton *leftButton= [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame =leftFrame;
    [leftButton addTarget:self action:@selector(dismissOverlayView) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"白色返回_想去"] forState:UIControlStateNormal];
    [imgView addSubview:leftButton];
    
    _downpopView = [[UIView alloc]initWithFrame:CGRectMake(36, 0.33*UIScreenH, UIScreenW - 72, 240 - 42)];
    _downpopView.backgroundColor = [UIColor clearColor];
    _downpopView.layer.masksToBounds = YES;
    _downpopView.layer.cornerRadius = 10;
    [self.view addSubview:_downpopView];
    _downpopView.hidden = YES;
    UIImageView* alphaView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _downpopView.width, _downpopView.height)];
    alphaView1.image = [UIImage imageNamed:@"uppopView"];
    [_downpopView addSubview:alphaView1];
    
    UIImageView* pwdView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 35, _downpopView.width - 30, 42)];
    pwdView.image = [UIImage imageNamed:@"nameView"];
    pwdView.userInteractionEnabled = YES;
    [_downpopView addSubview:pwdView];
    UIImageView* pwdimgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, pwdView.height - 20)];
    pwdimgView.contentMode = UIViewContentModeScaleAspectFit;
    pwdimgView.image = [UIImage imageNamed:@"pwdimgView1"];
    [pwdView addSubview:pwdimgView];
    _pwdField = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, pwdView.width - 40, pwdView.height)];
    _pwdField.backgroundColor = [UIColor clearColor];
    _pwdField.placeholder = @"请填写密码";
    _pwdField.secureTextEntry = YES;
    _pwdField.textAlignment = NSTextAlignmentCenter;
    _pwdField.font = [UIFont systemFontOfSize:13];
    [pwdView addSubview:_pwdField];
    [Command placeholderColor:_pwdField str:_pwdField.placeholder color:[UIColor whiteColor]];
    
    UILabel* pwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(pwdView.left, pwdView.bottom, pwdView.width, 15)];
    pwdLabel.text = @"由数字、字母、下划线组成的6-15位密码";
    pwdLabel.textColor = [UIColor lightGrayColor];
    pwdLabel.backgroundColor = [UIColor clearColor];
    pwdLabel.font = [UIFont systemFontOfSize:10];
    [_downpopView addSubview:pwdLabel];
    
    UIImageView* againpwdView = [[UIImageView alloc]initWithFrame:CGRectMake(pwdView.left, pwdView.bottom+20, pwdView.width, pwdView.height)];
    againpwdView.image = [UIImage imageNamed:@"nameView"];
    againpwdView.userInteractionEnabled = YES;
    [_downpopView addSubview:againpwdView];
    UIImageView* againimgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, againpwdView.height - 20)];
    againimgView.image= [UIImage imageNamed:@"pwdimgView1"];
    againimgView.contentMode = UIViewContentModeScaleAspectFit;
    [againpwdView addSubview:againimgView];
    _againpwdField = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, againpwdView.width - 40, againpwdView.height)];
    _againpwdField.backgroundColor = [UIColor clearColor];
    _againpwdField.textAlignment = NSTextAlignmentCenter;
    _againpwdField.placeholder = @"请确认密码";
    _againpwdField.secureTextEntry = YES;
    _againpwdField.font = [UIFont systemFontOfSize:13];
    [againpwdView addSubview:_againpwdField];
    [Command placeholderColor:_againpwdField str:_againpwdField.placeholder color:[UIColor whiteColor]];
    
    _okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _okBtn.frame = CGRectMake(95, _downpopView.bottom+45, UIScreenW - 190, 36);
    //    _okBtn.backgroundColor = UIColorFromRGB(MYOrange);
    [_okBtn setBackgroundImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
    [_okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _okBtn.layer.masksToBounds = YES;
    _okBtn.layer.cornerRadius = 18;
    _okBtn.layer.shadowColor=[UIColor blackColor].CGColor;
    _okBtn.layer.shadowOffset=CGSizeMake(0, 0);
    _okBtn.layer.shadowOpacity=0.5;
    _okBtn.layer.shadowRadius= 10;
    _okBtn.clipsToBounds = false;
    [self.view addSubview:_okBtn];
    _okBtn.hidden = YES;
    [_okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
}
- (void)okBtnClick:(UIButton*)sender{
    if ([Command isPassword:_pwdField.text]) {
        if ([_pwdField.text isEqualToString:_againpwdField.text]&&!IsEmptyValue(_pwdField.text)) {
            [self registRequest];
            
        }else{
            jxt_showToastTitle(@"两次输入的密码不一致", 1);
        }
    }else{
        jxt_showToastTitle(@"密码格式不正确", 1);
    }
}


- (void)registRequest{
    /*
     /mbtwz/register?action=upPassword"+callback1
     参数：phone password 放在data中
     */
    NSString* urlstr = @"/mbtwz/register?action=upPassword";
    _pwdField.text = [Command convertNull:_pwdField.text];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\",\"password\":\"%@\"}",self.phone,_pwdField.text]};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSSLog(@">>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            jxt_showToastTitle(@"密码修改成功", 1);
            UIViewController *rootVC = self.presentingViewController;
            while (rootVC.presentingViewController) {
                rootVC = rootVC.presentingViewController;
            }
            [rootVC dismissViewControllerAnimated:YES completion:nil];
        }else{
            jxt_showToastTitle(@"密码修改失败", 1);
        }
    } fail:^(NSError *error) {
        
    }];
    
    
}

- (void)dismissOverlayView{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
