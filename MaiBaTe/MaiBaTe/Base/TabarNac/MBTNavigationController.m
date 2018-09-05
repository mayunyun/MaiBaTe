//
//  MBTNavigationController.m
//  MaiBaTe
//
//  Created by apple on 17/8/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MBTNavigationController.h"
#import "MBTNavBar.h"

@interface MBTNavigationController ()

@end

@implementation MBTNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBTNavBar *navBar =[[MBTNavBar alloc]init];
    [self setValue:navBar forKey:@"navigationBar"];
    
    //设置导航栏颜色
    

}



+ (void)initialize
{
    
    //设置导航条
    [self setupNavBar];
    
    //设置两边的导航项目
    [self setupItem];
    
    
}

+ (void)setupNavBar
{
    
    //导航条
    UINavigationBar *appearance =[UINavigationBar appearance];
    //[appearance setBarTintColor:WHITE];
    [appearance setBarTintColor:UIColorFromRGB(0x333333)];
    NSMutableDictionary *normalDict =[NSMutableDictionary dictionary];
    normalDict[NSFontAttributeName]=[UIFont systemFontOfSize:16];
    normalDict[NSForegroundColorAttributeName]=[UIColor whiteColor];
    [appearance setTitleTextAttributes:normalDict];
    
    
}

+ (void)setupItem
{
    
    //导航条
    UIBarButtonItem *item =[UIBarButtonItem appearance];
    //正常
    NSMutableDictionary *normalDict =[NSMutableDictionary dictionary];
    normalDict[NSFontAttributeName]=[UIFont systemFontOfSize:14];
    normalDict[NSForegroundColorAttributeName]=UIColorFromRGB(MYColor);
    [item setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    
    //不可用
    NSMutableDictionary *disableDict =[NSMutableDictionary dictionary];
    disableDict[NSFontAttributeName]=[UIFont systemFontOfSize:14];
    disableDict[NSForegroundColorAttributeName]=[UIColor lightGrayColor];
    [item setTitleTextAttributes:disableDict forState:UIControlStateDisabled];
    //选择
    NSMutableDictionary *selectedDict =[NSMutableDictionary dictionary];
    selectedDict[NSFontAttributeName]=[UIFont systemFontOfSize:14];
    selectedDict[NSForegroundColorAttributeName]=[UIColor  redColor];
    [item setTitleTextAttributes:selectedDict forState:UIControlStateSelected];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.viewControllers.count>0)
    {
        
        viewController.hidesBottomBarWhenPushed=YES;
        
    }
    [super pushViewController:viewController animated:YES];
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
