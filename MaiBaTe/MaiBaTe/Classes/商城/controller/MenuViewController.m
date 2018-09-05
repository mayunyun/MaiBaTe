//
//  MenuViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/9/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MenuViewController.h"
#import "YuYueViewController.h"
#import "MYYMyOrderViewController.h"
#import "AddressManageViewController.h"
#import "LoginViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"菜单.png"]];
    titleImage.frame = CGRectMake(5, 3, 17, 19);
    [titleView addSubview:titleImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 75, 25)];
    titleLab.text = @"订单中心";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    [self creatUI];
}

- (void)creatUI{
    NSArray *titleArr = @[@"商城订单",@"我的预约"];

    CGFloat w = 70*GMYWIDTH;
    UIImageView* bgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*GMYWIDTH, (25+64)*GMYWIDTH, UIScreenW - 30*GMYWIDTH, titleArr.count*w)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 10*GMYWIDTH;
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, i*w, bgView.width, w);
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.tag = 100+i;
        [bgView addSubview:btn];
        [btn addTarget:self action:@selector(cellClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10*GMYWIDTH, 15*GMYWIDTH, bgView.width/2, 35*GMYWIDTH)];
        label.text = titleArr[i];
        label.font = [UIFont systemFontOfSize:14*GMYWIDTH];
        label.backgroundColor = [UIColor clearColor];
        [btn addSubview:label];
        
        
        if (i != 0) {
            UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, w*i, bgView.width, 1)];
            xian.backgroundColor = UIColorFromRGB(0xF4F4F4);
            [bgView addSubview:xian];
        }
        
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(btn.width - 20*GMYWIDTH, (w - 15*GMYWIDTH)/2, 10*GMYWIDTH, 15*GMYWIDTH)];
        imgView.image = [UIImage imageNamed:@"chargeback"];
        [btn addSubview:imgView];
        
    }
    
    UIImageView* bgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(15*GMYWIDTH, bgView.bottom+15*MYWIDTH, UIScreenW - 30*GMYWIDTH, w)];
    bgView1.layer.masksToBounds = YES;
    bgView1.layer.cornerRadius = 10*GMYWIDTH;
    bgView1.userInteractionEnabled = YES;
    bgView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView1];
    
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(0, 0, bgView.width, w);
    [btn1 setBackgroundColor:[UIColor clearColor]];
    btn1.tag = 102;
    [bgView1 addSubview:btn1];
    [btn1 addTarget:self action:@selector(cellClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(10*GMYWIDTH, 15*GMYWIDTH, bgView.width/2, 35*GMYWIDTH)];
    label1.text = @"地址管理";
    label1.font = [UIFont systemFontOfSize:14*GMYWIDTH];
    label1.backgroundColor = [UIColor clearColor];
    [btn1 addSubview:label1];
    
    UIImageView* imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(btn1.width - 20*GMYWIDTH, (w - 15*GMYWIDTH)/2, 10*GMYWIDTH, 15*GMYWIDTH)];
    imgView1.image = [UIImage imageNamed:@"chargeback"];
    [btn1 addSubview:imgView1];
}

- (void)cellClick:(UIButton*)sender{
    [Command isloginRequest:^(bool str) {
        if (str) {
            if (sender.tag == 100) {
                //我的订单
                MYYMyOrderViewController *order = [[MYYMyOrderViewController alloc]init];
                [self.navigationController pushViewController:order animated:YES];
                
            }else if (sender.tag == 101){
                //我的预约
                YuYueViewController * yyvc = [[YuYueViewController alloc]init];
                [self.navigationController pushViewController:yyvc animated:YES];
                
                
            }else if (sender.tag == 102){
                //地址管理
                AddressManageViewController * amvc = [[AddressManageViewController alloc]init];
                
                [self.navigationController pushViewController:amvc animated:YES];
                
            }
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginViewController* vc = [[LoginViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }
    }];
    
    
    
}

@end
