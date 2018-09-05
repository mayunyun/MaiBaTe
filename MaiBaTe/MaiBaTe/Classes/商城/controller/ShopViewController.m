//
//  ShopViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ShopViewController.h"
#import "IconsCollectionViewCell.h"
#import "CollectionReusableView.h"
#import "MenuViewController.h"
#import "DetailsViewController.h"
#import "ShopCarViewController.h"
#import "LoginViewController.h"
#import "PeiJianViewController.h"
#import "JiFenShopViewController.h"
#import "NewCarViewController.h"
#import "ETCRechargeViewController.h"

@interface ShopViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *statusBarView;
}
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ShopViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setTranslucent:YES];
    self.navigationItem.title = @"";
    
    UIImage *image = [UIImage imageNamed:@"iconfont-touming"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
    
    [self setStatusBarBackgroundColor:UIColorFromRGB(0x333333)];
    [self ajaxCallbak];
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [statusBarView removeFromSuperview];
    
}

- (UITableView *)TableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
        //_tableView.backgroundColor = [UIColorFromRGB(0xF0F0F0)];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionFooterHeight  = 1.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
//        CollectionReusableView *header = [[CollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenW*37/50+20*MYWIDTH)];
//        header.backgroundColor = UIColorFromRGB(0xEEEEEE);
//        UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 50*MYWIDTH)];
//        _tableView.tableHeaderView = headview;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate =(id)self;
    self.navigationItem.leftBarButtonItem = nil;
    
    [self TableView];
    [self navbarBGView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10*MYWIDTH;
    }
    return 15*MYWIDTH;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 15*MYWIDTH)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150*MYWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = @[@"shopping1",@"shopping5",@"shopping2",@"shopping3",@"shopping4"];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:arr[indexPath.section]]];
    image.frame = CGRectMake(10*MYWIDTH, 0, UIScreenW-20*MYWIDTH, 150*MYWIDTH);
    [cell.contentView addSubview:image];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        PeiJianViewController *vc = [[PeiJianViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 2){
        JiFenShopViewController *jfvc = [[JiFenShopViewController alloc]init];
        [self.navigationController pushViewController:jfvc animated:YES];
    }
    else if (indexPath.section == 1){
        NewCarViewController *newcar = [[NewCarViewController alloc]init];
        [self.navigationController pushViewController:newcar animated:YES];
    }
    else if (indexPath.section == 4){
        ETCRechargeViewController *etcvc = [[ETCRechargeViewController alloc]init];
        [self.navigationController pushViewController:etcvc animated:YES];
    }
    else{
        jxt_showToastTitle(@"敬请期待", 1);
    }
    
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    statusBarView = [[UIView alloc]initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
    if (statusbarHeight>20) {
        statusBarView.frame = CGRectMake(0, -44,    self.view.bounds.size.width, 44);
    }
    statusBarView.backgroundColor = color;
    [self.navigationController.navigationBar addSubview:statusBarView];
}
- (void)navbarBGView{
    UIImageView *navbar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, UIScreenW, 44)];
    if (statusbarHeight>20) {
        navbar.frame = CGRectMake(0, 44, UIScreenW, 44);
    }
    navbar.image = [UIImage imageNamed:@"navbarBG"];
    navbar.userInteractionEnabled = YES;
    [self.view addSubview:navbar];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"菜单"] style:UIBarButtonItemStylePlain target:self action:@selector(muluButClick)];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(MYColor)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"购物车"] style:UIBarButtonItemStylePlain target:self action:@selector(rightToLastViewController)];
    [self.navigationItem.rightBarButtonItem setTintColor:UIColorFromRGB(MYColor)];
}
- (void)muluButClick{
    MenuViewController *menu = [[MenuViewController alloc]init];
    [self.navigationController pushViewController:menu animated:YES];
}
- (void)rightToLastViewController{
    [Command isloginRequest:^(bool str) {
        if (str) {
            ShopCarViewController * vc = [[ShopCarViewController alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginViewController* vc = [[LoginViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }
    }];
    
}

- (void)ajaxCallbak{
    [Command isloginRequest:^(bool str) {
        if (str) {
            //判断充电状态
            
            NSString *URLStr = @"/mbtwz/wxorder?action=zhengzaichongdian";
            
            [HTNetWorking postWithUrl:[NSString stringWithFormat:@"%@%@",DATA_ADDRESS,URLStr] refreshCache:YES params:nil success:^(id response) {
                [SVProgressHUD dismiss];
                NSString *str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                NSLog(@"充电状态:%@",str);
                
                NSDictionary *dict = @{@"chongdian":[NSString stringWithFormat:@"%@",str]};
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"chongdianzhuangtai" object:nil userInfo:dict];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
            } fail:^(NSError *error) {
                [SVProgressHUD dismiss];
                
            }];
            
        }
    }];
}
@end

