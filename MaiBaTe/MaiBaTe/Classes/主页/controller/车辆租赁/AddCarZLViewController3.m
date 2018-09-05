//
//  AddCarZLViewController3.m
//  MaiBaTe
//
//  Created by LONG on 2017/12/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AddCarZLViewController3.h"
#import "CarRentalViewController.h"
@interface AddCarZLViewController3 ()

@end

@implementation AddCarZLViewController3

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"baiNat"];
    if (statusbarHeight>20) {
        image = [UIImage imageNamed:@"baiNat_X"];
    }
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0x333333)];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"车辆租赁_1"]];
    titleImage.frame = CGRectMake(0, 3, 20, 19);
    [titleView addSubview:titleImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(23, 0, 75, 25)];
    titleLab.text = @"车辆租赁";
    titleLab.textColor = UIColorFromRGB(0x333333);
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"客服电话"] style:UIBarButtonItemStylePlain target:self action:@selector(rightToLastViewController)];
    [self.navigationItem.rightBarButtonItem setTintColor:UIColorFromRGB(MYColor)];
    
    [self setUIview];
}
- (void)setUIview{
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 64+15*MYWIDTH, UIScreenW, 70*MYWIDTH)];
    if (statusbarHeight>20) {
        head.frame = CGRectMake(0, 88+15*MYWIDTH, UIScreenW, 130*MYWIDTH);
    }
    head.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:head];
    
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(33*MYWIDTH, 22*MYWIDTH, 12*MYWIDTH, 12*MYWIDTH)];
    image1.image = [UIImage imageNamed:@"租车小点_1"];
    [head addSubview:image1];
    
    UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW - 47*MYWIDTH, 18*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    image3.image = [UIImage imageNamed:@"租车大点"];
    [head addSubview:image3];
    
    UIView *xuxian = [[UIView alloc]initWithFrame:CGRectMake(image1.right, 27*MYWIDTH, image3.left-image1.right, 1*MYWIDTH)];
    xuxian.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [head addSubview:xuxian];
    
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW/2-6*MYWIDTH, 22*MYWIDTH, 12*MYWIDTH, 12*MYWIDTH)];
    image2.image = [UIImage imageNamed:@"租车小点_1"];
    [head addSubview:image2];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, image1.bottom, 85*MYWIDTH, 20)];
    lab1.text = @"用车需求";
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.textColor = UIColorFromRGB(0x888888);
    lab1.font = [UIFont systemFontOfSize:12];
    [head addSubview:lab1];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW/2-40*MYWIDTH, image1.bottom, 80*MYWIDTH, 20)];
    lab2.text = @"联系方式";
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.textColor = UIColorFromRGB(0x888888);
    lab2.font = [UIFont systemFontOfSize:12];
    [head addSubview:lab2];
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW-83*MYWIDTH, image1.bottom, 83*MYWIDTH, 20)];
    lab3.text = @"提交需求";
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.textColor = UIColorFromRGB(0x888888);
    lab3.font = [UIFont systemFontOfSize:12];
    [head addSubview:lab3];
    
    UIButton *upBut = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bottom-55*MYWIDTH, UIScreenW, 55*MYWIDTH)];
    [upBut setTitle:@"完成" forState:UIControlStateNormal];
    upBut.titleLabel.font = [UIFont systemFontOfSize:20];
    [upBut setBackgroundColor:UIColorFromRGB(MYColor)];
    [upBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [upBut addTarget:self action:@selector(upviewCilck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upBut];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, head.bottom, UIScreenW, UIScreenW*10/9)];
    image.image = [UIImage imageNamed:@"提交完成"];
    image.userInteractionEnabled = YES;
    [self.view addSubview:image];
    
    UILabel *lab4 = [[UILabel alloc]initWithFrame:CGRectMake(0, image.height/2-25*MYWIDTH, image.width, 20)];
    lab4.text = @"您已提交成功";
    lab4.textAlignment = NSTextAlignmentCenter;
    lab4.textColor = UIColorFromRGB(0x222222);
    lab4.font = [UIFont systemFontOfSize:15];
    [image addSubview:lab4];
    
    UIButton *orderBut = [[UIButton alloc]initWithFrame:CGRectMake(lab4.left, lab4.bottom+17*MYWIDTH, lab4.width, lab4.height)];
    orderBut.titleLabel.font = [UIFont systemFontOfSize:13];
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"查看租赁订单>"];
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    //此时如果设置字体颜色要这样
    [tncString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(MYColor)  range:NSMakeRange(0,[tncString length])];
    
    //设置下划线颜色...
    [tncString addAttribute:NSUnderlineColorAttributeName value:UIColorFromRGB(MYColor) range:(NSRange){0,[tncString length]}];
    [orderBut setAttributedTitle:tncString forState:UIControlStateNormal];
    [orderBut addTarget:self action:@selector(orderButCilck) forControlEvents:UIControlEventTouchUpInside];
    [image addSubview:orderBut];
}
- (void)upviewCilck{
    NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-3]animated:YES];
}
- (void)backToLastViewController:(UIButton *)button{
    NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-3]animated:YES];
}
- (void)orderButCilck{
    CarRentalViewController *carRenVC = [[CarRentalViewController alloc]init];
    carRenVC.push = @"1";
    [self.navigationController pushViewController:carRenVC animated:YES];
}
- (void)rightToLastViewController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定拨打电话：0531-88989022？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0531-88989022"]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
