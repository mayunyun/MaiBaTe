//
//  MyOrderForViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/11/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyOrderForViewController.h"
#import "MyOrderForTableViewCell.h"
#import "ChargeOrderViewController.h"
#import "MYYMyOrderViewController.h"
#import "LoginViewController.h"
#import "AllWuLiuOrderViewController.h"
#import "CarRentalViewController.h"
@interface MyOrderForViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@end

@implementation MyOrderForViewController
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
    // Do any additional setup after loading the view.
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"账单Nar.png"]];
    titleImage.frame = CGRectMake(5, 3, 17, 19);
    [titleView addSubview:titleImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 75, 25)];
    titleLab.text = @"我的订单";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    [self tableview];
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, UIScreenW, UIScreenH)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled =NO;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _tableview.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableview];
        [_tableview registerClass:[MyOrderForTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MyOrderForTableViewCell class])];
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 10)];
        _tableview.tableHeaderView = header;
    }
    return _tableview;
    
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class MainClass = [MyOrderForTableViewCell class];
    MyOrderForTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainClass)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *data = @[@"充电订单",@"商城订单",@"物流订单",@"租车订单"];
    [cell setdata:data[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [Command isloginRequest:^(bool str) {
        if (str) {
            if (indexPath.row == 0) {
                ChargeOrderViewController *chargeO = [[ChargeOrderViewController alloc]init];
                chargeO.hidesBottomBarWhenPushed = YES;
                chargeO.type = 2;
                [self.navigationController pushViewController:chargeO animated:YES];
            }else if (indexPath.row == 1){
                MYYMyOrderViewController *DianZSQ = [[MYYMyOrderViewController alloc]init];
                DianZSQ.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:DianZSQ animated:YES];
            }else if (indexPath.row == 2){

//                jxt_showToastTitle(@"敬请期待", 1);

                AllWuLiuOrderViewController *DianZSQ = [[AllWuLiuOrderViewController alloc]init];
                DianZSQ.stitle = @"物流订单";
                DianZSQ.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:DianZSQ animated:YES];

            }else if (indexPath.row == 3){
                CarRentalViewController *ZuCheOrder = [[CarRentalViewController alloc]init];
                ZuCheOrder.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:ZuCheOrder animated:YES];
            }
        }else{
            LoginViewController* vc = [[LoginViewController alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
    
    NSLog(@"%ld",indexPath.row);
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
