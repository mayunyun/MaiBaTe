//
//  QQandWXViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/9/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "QQandWXViewController.h"

@interface QQandWXViewController ()
{
    UITextField* _qqField;
    UITextField* _wxField;
    
}
@end

@implementation QQandWXViewController
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
    self.navigationItem.title = @"绑定QQ微信";
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
    bgsView.contentSize = CGSizeMake(UIScreenW, 500*GMYWIDTH);
    bgsView.bounces = NO;
    bgsView.showsHorizontalScrollIndicator = NO;
    bgsView.showsVerticalScrollIndicator = NO;
    bgsView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgsView];
    
    UIImageView* upView = [[UIImageView alloc]initWithFrame:CGRectMake(20*GMYWIDTH, 45*GMYWIDTH, UIScreenW - 40*GMYWIDTH, 200*GMYWIDTH)];
    upView.backgroundColor = [UIColor whiteColor];
    upView.userInteractionEnabled = YES;
    upView.layer.masksToBounds = YES;
    upView.layer.cornerRadius = 10*GMYWIDTH;
    [bgsView addSubview:upView];
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, upView.height*0.5, upView.width, 0.7)];
    line.backgroundColor = UIColorFromRGB(MYLine);
    [upView addSubview:line];
    
    UILabel* qqLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*GMYWIDTH, 30*GMYWIDTH, 50*GMYWIDTH, 40*GMYWIDTH)];
    qqLabel.text = @"QQ:";
    qqLabel.font = [UIFont systemFontOfSize:15*GMYWIDTH];
    [upView addSubview:qqLabel];
    _qqField = [[UITextField alloc]initWithFrame:CGRectMake(qqLabel.right, qqLabel.top, upView.width - qqLabel.right - 30*GMYWIDTH, qqLabel.height)];
    _qqField.font = [UIFont systemFontOfSize:14*GMYWIDTH];
    _qqField.background = [UIImage imageNamed:@"nameView"];
    [upView addSubview:_qqField];
    UILabel* wxLabel = [[UILabel alloc]initWithFrame:CGRectMake(qqLabel.left, line.bottom+30*GMYWIDTH, qqLabel.width, qqLabel.height)];
    wxLabel.text = @"微信:";
    wxLabel.font = qqLabel.font;
    [upView addSubview:wxLabel];
    _wxField = [[UITextField alloc]initWithFrame:CGRectMake(wxLabel.right, wxLabel.top, _qqField.width, wxLabel.height)];
    _wxField.background = _qqField.background;
    _wxField.font = _qqField.font;
    [upView addSubview:_wxField];
    
    UIButton* okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    okBtn.frame = CGRectMake(upView.left, upView.bottom+40*GMYWIDTH, upView.width, 40*GMYWIDTH);
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16*GMYWIDTH];
    okBtn.backgroundColor = UIColorFromRGB(MYOrange);
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.cornerRadius = 3*GMYWIDTH;
    [bgsView addSubview:okBtn];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

- (void)okBtnClick:(UIButton*)sender{
    if (IsEmptyValue(_qqField.text)&&IsEmptyValue(_wxField.text)) {
        jxt_showToastTitle(@"qq和微信不能同时为空", 1);
    }else{
        [self dataRequest];
    }
}

- (void)dataRequest{
    /*
    /mbtwz/wxcustomer?action=addQqWechat
     参数：qq   wechat     放在data中
     */
    NSString* urlstr = @"/mbtwz/wxcustomer?action=addQqWechat";
    _qqField.text = [Command convertNull:_qqField.text];
    _wxField.text = [Command convertNull:_wxField.text];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"qq\":\"%@\",\"wechat\":\"%@\"}",_qqField.text,_wxField.text]};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSSLog(@"绑定邮箱和球球>>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            jxt_showToastTitle(@"绑定成功", 1);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            jxt_showToastTitle(@"绑定失败", 1);
        }
    } fail:^(NSError *error) {
        
    }];
}

@end
