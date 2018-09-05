//
//  SaveCenterViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/9/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SaveCenterViewController.h"
#import "PayPwdViewController.h"
#import "ReplacePwdViewController.h"
#import "BindEmailViewController.h"
#import "SecurityViewController.h"
#import "QQandWXViewController.h"
@interface SaveCenterViewController ()
{
    NSArray* _titleArr;
}
@end

@implementation SaveCenterViewController
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
    self.navigationItem.title = @"安全中心";
    _titleArr = @[@"修改密码",@"绑定邮箱",@"绑定QQ/微信",@"设置支付密码"];//,@"设置密保"
    [self creatUI];
}

- (void)creatUI{
    CGFloat w = 70*GMYWIDTH;
    UIImageView* bgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*GMYWIDTH, (25+64)*GMYWIDTH, UIScreenW - 30*GMYWIDTH, _titleArr.count*w)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 10*GMYWIDTH;
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    for (int i = 0; i < _titleArr.count; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, i*w, bgView.width, w);
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.tag = 100+i;
        [bgView addSubview:btn];
        [btn addTarget:self action:@selector(cellClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*GMYWIDTH, 15*GMYWIDTH, bgView.width/2, 35*GMYWIDTH)];
        label.text = _titleArr[i];
        label.font = [UIFont systemFontOfSize:14*GMYWIDTH];
        label.backgroundColor = [UIColor clearColor];
        [btn addSubview:label];
//        if (i==3) {
//            label.textColor = UIColorFromRGB(0x666666);
//        }
        
        if (i != 0) {
            UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, w*i, bgView.width, 1)];
            xian.backgroundColor = UIColorFromRGB(0xF4F4F4);
            [bgView addSubview:xian];
        }

        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(btn.width - 20*GMYWIDTH, (w - 15*GMYWIDTH)/2, 10*GMYWIDTH, 15*GMYWIDTH)];
        imgView.image = [UIImage imageNamed:@"chargeback"];
        [btn addSubview:imgView];

    }
    
}

- (void)cellClick:(UIButton*)sender{
    if (sender.tag == 100) {

        //修改密码
        ReplacePwdViewController* vc = [[ReplacePwdViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 101){
        //绑定邮箱
        BindEmailViewController* vc = [[BindEmailViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

    }else if (sender.tag == 102){
        //绑定球球、微信
        QQandWXViewController* vc = [[QQandWXViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
//    else if (sender.tag == 103){
//        //设置密保
//        jxt_showToastTitle(@"正在开发中", 1);
////        SecurityViewController* vc = [[SecurityViewController alloc]init];
////        [self.navigationController pushViewController:vc animated:YES];
//    }
    else if (sender.tag == 103){
        //设置支付密码
        PayPwdViewController* vc = [[PayPwdViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

@end
