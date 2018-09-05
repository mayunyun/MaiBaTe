//
//  MBTTabBarController.m
//  MaiBaTe
//
//  Created by apple on 17/8/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MBTTabBarController.h"
#import <AVFoundation/AVFoundation.h>

#import "MBTNavigationController.h"
#import "MBTTabar.h"
#import "MainViewController.h"
#import "ShopViewController.h"
#import "FindViewController.h"
#import "MeViewController.h"
#import "CoreViewController.h"
#import "CarChargeViewController.h"
#import "LoginViewController.h"
@interface MBTTabBarController ()<MBTTabarDelegate>{
    int type;
}

@end

@implementation MBTTabBarController

#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+ (void)initialize
{
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    dictNormal[NSForegroundColorAttributeName] = UIColorFromRGB(0x333333);
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    
    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    dictSelected[NSForegroundColorAttributeName] = UIColorFromRGB(MYColor);
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    
    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"chongdianzhuangtai" object:nil];
    
    //添加各个控制器
    [self addAllChilds];

    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
    MBTTabar *tabbar = [[MBTTabar alloc] init];
    tabbar.myDelegate = self;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];
    
//    // 设置一个自定义 View,大小等于 tabBar 的大小
//    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
//    // 给自定义 View 设置颜色
//    bgView.backgroundColor = [UIColor whiteColor];
//    // 将自定义 View 添加到 tabBar 上
//    [self.tabBar insertSubview:bgView atIndex:0];
    
    
}
- (void)InfoNotificationAction:(NSNotification *)notification{
    
    
    NSString *str = notification.userInfo[@"chongdian"];
    if ([str isEqualToString:@"(null)"]) {
        type = 0;
        return;
    }else if ([str rangeOfString:@"false"].location!=NSNotFound){//"false"
        type = 1;
        return;
    }else if ([str rangeOfString:@"true"].location!=NSNotFound){//"true"
        type = 2;
        return;
    }else{
        type = 0;
    }
    NSLog(@"---接收到通知---");
    
}
#pragma mark 添加各个子控制器
- (void)addAllChilds
{
    MainViewController *mainVC = [[MainViewController alloc] init];
    [self setUpOneChildVcWithVc:mainVC Image:@"home_normal" selectedImage:@"home_highlight" title:@"首页"];

    ShopViewController *shopVC = [[ShopViewController alloc] init];
    [self setUpOneChildVcWithVc:shopVC Image:@"fish_normal" selectedImage:@"fish_highlight" title:@"商城"];

    FindViewController *findVC = [[FindViewController alloc] init];
    [self setUpOneChildVcWithVc:findVC Image:@"message_normal" selectedImage:@"message_highlight" title:@"发现"];

    MeViewController *meVC = [[MeViewController alloc] init];
    [self setUpOneChildVcWithVc:meVC Image:@"account_normal" selectedImage:@"account_highlight" title:@"我的"];

}
#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    MBTNavigationController *nav = [[MBTNavigationController alloc] initWithRootViewController:Vc];
    
    
    //Vc.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    Vc.tabBarItem.selectedImage = mySelectedImage;
    
    Vc.tabBarItem.title = title;
    
    Vc.navigationItem.title = title;
    
    [self addChildViewController:nav];
    
}


#pragma mark - ------------------------------------------------------------------
#pragma mark - LBTabBarDelegate
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(MBTTabar *)tabBar
{
    if (type == 2) {
        CarChargeViewController *carcharge = [[CarChargeViewController alloc]init];
        carcharge.pushnumer = 2;
        [self presentViewController:carcharge animated:YES completion:nil];
    }else if (type == 1){
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusDenied){
            if (IS_VAILABLE_IOS8) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相机权限受限" message:@"请在iPhone的\"设置->隐私->相机\"选项中,允许\"麦巴特\"访问您的相机." preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([self canOpenSystemSettingView]) {
                        [self systemSettingView];
                    }
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"相机权限受限" message:@"请在iPhone的\"设置->隐私->相机\"选项中,允许\"麦巴特\"访问您的相机." delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [alert show];
            }
            
            return;
        }
        
        CoreViewController *plusVC = [[CoreViewController alloc] init];
        // plusVC.view.alpha = 0;
        [plusVC setDidReceiveBlock:^(NSString *result) {
            NSSLog(@"%@", result);
            //        if ([result isEqualToString:@"login"]){
            NSLog(@"%@",result);
            //        }
            
        }];
        [self presentViewController:plusVC animated:YES completion:nil];
    }else{
        LoginViewController *Login = [[LoginViewController alloc]init];
        [self presentViewController:Login animated:YES completion:nil];

    }
    
    

    

}

/**
 *  是否可以打开设置页面
 *
 */
- (BOOL)canOpenSystemSettingView {
    if (IS_VAILABLE_IOS8) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

/**
 *  跳到系统设置页面
 */
- (void)systemSettingView {
    if (IS_VAILABLE_IOS8) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chongdianzhuangtai" object:self];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
