//
//  SecurityViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/9/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SecurityViewController.h"

@interface SecurityViewController ()
{
    UITextField* _firstField;
    UITextField* _secondField;
}
@end

@implementation SecurityViewController
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
    [self backBarTitleButtonItemTarget:self action:@selector(backpop:) text:@"设置密保"];
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

- (void)backpop:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI{
    
    UIScrollView* bgsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
    bgsView.contentSize = CGSizeMake(UIScreenW, 550*GMYWIDTH);
    bgsView.showsVerticalScrollIndicator = NO;
    bgsView.showsHorizontalScrollIndicator = NO;
    bgsView.bounces = NO;
    bgsView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgsView];
    
    UIImageView* upView = [[UIImageView alloc]initWithFrame:CGRectMake(15*GMYWIDTH, 60*GMYWIDTH, bgsView.width - 30*GMYWIDTH, 290*GMYWIDTH)];
    upView.userInteractionEnabled = YES;
    upView.backgroundColor = [UIColor whiteColor];
    upView.layer.masksToBounds = YES;
    upView.layer.cornerRadius = 10;
    [bgsView addSubview:upView];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 130*GMYWIDTH, upView.width, 0.5)];
    lineView.backgroundColor = UIColorFromRGB(MYLine);
    [upView addSubview:lineView];
    UIImageView* qusimgView = [[UIImageView alloc]initWithFrame:CGRectMake(40*GMYWIDTH, 30*GMYWIDTH, 25*GMYWIDTH, 30*GMYWIDTH)];
    qusimgView.image = [UIImage imageNamed:@"密保密码"];
    qusimgView.contentMode = UIViewContentModeScaleAspectFit;
    [upView addSubview:qusimgView];
    UIButton* qusBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    qusBtn.frame = CGRectMake(qusimgView.right+20*GMYWIDTH, qusimgView.top, upView.width - qusimgView.left*2 - qusimgView.width - 20*GMYWIDTH, qusimgView.height);
    [qusBtn setTitle:@"请选择密保问题一" forState:UIControlStateNormal];
    [qusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qusBtn setBackgroundImage:[UIImage imageNamed:@"密保灰框"] forState:UIControlStateNormal];
    qusBtn.titleLabel.font = [UIFont systemFontOfSize:13*GMYWIDTH];
    [upView addSubview:qusBtn];
    qusBtn.tag = 100;
    [qusBtn addTarget:self action:@selector(qusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* downView = [[UIImageView alloc]initWithFrame:CGRectMake(qusBtn.width - 30*GMYWIDTH, (qusBtn.height - 10*GMYWIDTH)/2, 14*GMYWIDTH, 10*GMYWIDTH)];
    downView.image = [UIImage imageNamed:@"个人信息下拉"];
    [qusBtn addSubview:downView];
    
    UIImageView* ansimgView = [[UIImageView alloc]initWithFrame:CGRectMake(qusimgView.left, qusimgView.bottom+30*GMYWIDTH, qusimgView.width, qusimgView.height)];
    ansimgView.image = [UIImage imageNamed:@"密保填写"];
    ansimgView.contentMode = UIViewContentModeScaleAspectFit;
    [upView addSubview:ansimgView];
    _firstField = [[UITextField alloc]initWithFrame:CGRectMake(qusBtn.left, ansimgView.top, qusBtn.width, qusBtn.height)];
    _firstField.placeholder = @"请填写您的答案";
    _firstField.background = [UIImage imageNamed:@"密保灰框"];
    _firstField.font = [UIFont systemFontOfSize:13*GMYWIDTH];
    _firstField.textAlignment = NSTextAlignmentCenter;
    [upView addSubview:_firstField];
    [Command placeholderColor:_firstField str:_firstField.placeholder color:[UIColor whiteColor]];
    
    UIImageView* qusimgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(40*GMYWIDTH, lineView.bottom+40*GMYWIDTH, 25*GMYWIDTH, 30*GMYWIDTH)];
    qusimgView1.image = [UIImage imageNamed:@"密保密码"];
    qusimgView1.contentMode = UIViewContentModeScaleAspectFit;
    [upView addSubview:qusimgView1];
    UIButton* qusBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    qusBtn1.frame = CGRectMake(qusimgView1.right+20*GMYWIDTH, qusimgView1.top, upView.width - qusimgView1.left*2 - qusimgView1.width - 20*GMYWIDTH, qusimgView1.height);
    [qusBtn1 setTitle:@"请选择密保问题二" forState:UIControlStateNormal];
    [qusBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qusBtn1 setBackgroundImage:[UIImage imageNamed:@"密保灰框"] forState:UIControlStateNormal];
    qusBtn1.titleLabel.font = [UIFont systemFontOfSize:13*GMYWIDTH];
    [upView addSubview:qusBtn1];
    qusBtn1.tag = 101;
    [qusBtn1 addTarget:self action:@selector(qusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* downView1 = [[UIImageView alloc]initWithFrame:CGRectMake(qusBtn1.width - 30*GMYWIDTH, (qusBtn1.height - 10*GMYWIDTH)/2, 14*GMYWIDTH, 10*GMYWIDTH)];
    downView1.image = [UIImage imageNamed:@"个人信息下拉"];
    [qusBtn1 addSubview:downView1];
    UIImageView* ansimgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(qusimgView1.left, qusimgView1.bottom+30*GMYWIDTH, qusimgView1.width, qusimgView1.height)];
    ansimgView1.image = [UIImage imageNamed:@"密保填写"];
    ansimgView1.contentMode = UIViewContentModeScaleAspectFit;
    [upView addSubview:ansimgView1];
    _secondField = [[UITextField alloc]initWithFrame:CGRectMake(qusBtn1.left, ansimgView1.top, qusBtn1.width, qusBtn1.height)];
    _secondField.background = [UIImage imageNamed:@"密保灰框"];
    _secondField.placeholder = @"请填写您的答案";
    _secondField.textAlignment = NSTextAlignmentCenter;
    _secondField.font = [UIFont systemFontOfSize:13*GMYWIDTH];
    [upView addSubview:_secondField];
    [Command placeholderColor:_secondField str:_secondField.placeholder color:[UIColor whiteColor]];
    
    
    UIButton* okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    okBtn.frame = CGRectMake(40*GMYWIDTH, upView.bottom+60*GMYWIDTH, UIScreenW - 80*GMYWIDTH, 40*GMYWIDTH);
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"密保完成"] forState:UIControlStateNormal];
    [bgsView addSubview:okBtn];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}


- (void)qusBtnClick:(UIButton*)sender{
    if (sender.tag == 100) {
        
    }else if (sender.tag == 101){
    
    }

}


- (void)okBtnClick:(UIButton*)sender{

}

@end
