//
//  AboutWXViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/9/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AboutWXViewController.h"

@interface AboutWXViewController ()

@end

@implementation AboutWXViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationBar *bar = [UINavigationBar appearance];
    
    [bar setTranslucent:YES];
    self.navigationItem.title = @"";
    
    UIImage *image = [UIImage imageNamed:@"iconfont-touming"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
    
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
    // Do any additional setup after loading the view.
    [self setAboutWXView];
}

-(void)setAboutWXView{
    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WXBG"]];
    bgImage.frame = CGRectMake(0, 0, UIScreenW, UIScreenH);
    bgImage.userInteractionEnabled = YES;
    [self.view addSubview:bgImage];
    
    UILabel *MaiBut = [[UILabel alloc]initWithFrame:CGRectMake(0, 120*MYWIDTH, UIScreenW, 50)];
    MaiBut.text = @"MAIBUT";
    MaiBut.textAlignment = NSTextAlignmentCenter;
    MaiBut.font = [UIFont systemFontOfSize:30*MYWIDTH];
    MaiBut.textColor = [UIColor whiteColor];
    [bgImage addSubview:MaiBut];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MAIBUTWX"]];
    image.frame = CGRectMake(UIScreenW/2-86*MYWIDTH, UIScreenH/3, 172*MYWIDTH, 172*MYWIDTH);
    [bgImage addSubview:image];
    
    UILabel *other = [[UILabel alloc]initWithFrame:CGRectMake(0, UIScreenH/3*2, UIScreenW, 80)];
    other.textAlignment = NSTextAlignmentCenter;
    other.numberOfLines = 4;
    other.text = @"扫描关注麦巴特微信公众号\n\n最新资讯随时享";
    other.font = [UIFont systemFontOfSize:14];
    other.textColor = [UIColor whiteColor];
    [bgImage addSubview:other];
}
- (void)dismissOverlayView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
