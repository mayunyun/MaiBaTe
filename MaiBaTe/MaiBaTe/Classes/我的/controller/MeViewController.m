//
//  MeViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MeViewController.h"
#import "MeTabviewHeaderView.h"
#import "MeTableViewCell.h"
#import "MyOrderForViewController.h"//我的订单
#import "DianZSQViewController.h"//电桩申请
#import "NewMyCarViewController.h"//我的车辆
#import "SetViewController.h"//设置
#import "MyPurseViewController.h"//我的钱包
#import "MyYeEViewController.h"//余额
#import "YouHuiJuanViewController.h"//优惠券
#import "ScoresViewController.h"//积分
#import "MineMessageViewController.h"//个人信息
#import "MingXiViewController.h"//余额明细
#import "LoginViewController.h"
#import "MeModel.h"
#import "DriverRemarkVC.h"
@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,MeTabviewHeadDelegate,UIGestureRecognizerDelegate>
{
    UIView *statusBarView;
    MeTabviewHeaderView *_headview;
}
@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation MeViewController
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, -45, UIScreenW, UIScreenH+64)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled =NO;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _tableview.showsVerticalScrollIndicator =
        NO;
        [self.view addSubview:_tableview];
        
        _headview = [[MeTabviewHeaderView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 200*MYWIDTH)];
        _headview.delegate = self;
        _tableview.tableHeaderView = _headview;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starScore)];
        [_headview.starV addGestureRecognizer:tap];
        [_tableview registerClass:[MeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MeTableViewCell class])];
        
    }
    return _tableview;
    
}
-(void)starScore{
    DriverRemarkVC * vc = [[DriverRemarkVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArr = [[NSMutableArray alloc]init];
    self.navigationItem.leftBarButtonItem = nil;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate =(id)self;
    [self tableview];
}
#pragma 在这里面请求数据
- (void)loadNew
{
    [_dataArr removeAllObjects];
    MeModel *model=[[MeModel alloc]init];
    
    NSString *URLStr = @"/mbtwz/personal?action=getPersonalInfo";
    [HTNetWorking postWithUrl:[NSString stringWithFormat:@"%@%@",DATA_ADDRESS,URLStr] refreshCache:YES params:nil success:^(id response) {
        [SVProgressHUD dismiss];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"我的信息%@",arr);
        //建立模型
        if (!(response == nil)) {
            [model setValuesForKeysWithDictionary:arr[0]];
            //追加数据
            [_dataArr addObject:model];
        }
        [_headview settitledata:model];
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*MYWIDTH;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class MainClass = [MeTableViewCell class];
    MeTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainClass)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *data = @[@"我的钱包",@"账单",@"我的订单",@"电桩申请",@"我的车辆",@"设置"];
    [cell setdata:data[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [Command isloginRequest:^(bool str) {
        if (str) {
            if (indexPath.row == 0){
                MyPurseViewController *myPurse = [[MyPurseViewController alloc]init];
                myPurse.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myPurse animated:YES];
            }
            else if (indexPath.row == 1){
                MingXiViewController *mingxi = [[MingXiViewController alloc]init];
                mingxi.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:mingxi animated:YES];
            }else if (indexPath.row == 2) {
                MyOrderForViewController *chargeO = [[MyOrderForViewController alloc]init];
                chargeO.hidesBottomBarWhenPushed = YES;
//                chargeO.type = 2;
                [self.navigationController pushViewController:chargeO animated:YES];
            }else if (indexPath.row == 3){
                DianZSQViewController *DianZSQ = [[DianZSQViewController alloc]init];
                DianZSQ.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:DianZSQ animated:YES];
            }else if (indexPath.row == 4){
                NewMyCarViewController *MyCarV = [[NewMyCarViewController alloc]init];
                MyCarV.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:MyCarV animated:YES];
            }else if (indexPath.row == 5){
                SetViewController *setVC = [[SetViewController alloc]init];
                setVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:setVC animated:YES];
            }
        }else{
            LoginViewController* vc = [[LoginViewController alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
    
    NSLog(@"%ld",indexPath.row);
}
- (void)MeTabviewHeaderViewBtnHaveString:(int)resultString{
    
    [Command isloginRequest:^(bool str) {
        if (str) {
            if (resultString == 0) {//余额
                MyYeEViewController *myYuE = [[MyYeEViewController alloc]init];
                myYuE.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myYuE animated:YES];
                
            }else if (resultString == 1){//优惠券
                YouHuiJuanViewController *YouHuiJuan = [[YouHuiJuanViewController alloc]init];
                YouHuiJuan.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:YouHuiJuan animated:YES];
                
            }else if (resultString == 2){//积分
                ScoresViewController *ScoresVC = [[ScoresViewController alloc]init];
                ScoresVC.hidesBottomBarWhenPushed = YES;
                if (_dataArr.count>0) {
                    ScoresVC.model = _dataArr[0];
                }
                [self.navigationController pushViewController:ScoresVC animated:YES];
            }else if (resultString == 4){//钱包
                MyPurseViewController *myPurse = [[MyPurseViewController alloc]init];
                myPurse.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myPurse animated:YES];
            }else if (resultString == 5){//个人信息
                MineMessageViewController* MineMessagevc = [[MineMessageViewController alloc]init];
                if (!IsEmptyValue(_dataArr)) {
                    MeModel* model = [[MeModel alloc]init];
                    model = _dataArr[0];
                    MineMessagevc.model = model;
                    [self.navigationController pushViewController:MineMessagevc animated:YES];
                }
            }
        }else{
            LoginViewController* vc = [[LoginViewController alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
    if (statusbarHeight>20) {
        statusBarView.frame = CGRectMake(0, -44,    self.view.bounds.size.width, 44);
    }
    statusBarView.backgroundColor = color;
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    
}
- (void)ajaxCallbak{
    [Command isloginRequest:^(bool str) {
        if (str) {
            //判断充电状态
            [self loadNew];

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
            
        }else{
            MeModel *model=[[MeModel alloc]init];
            [_headview settitledata:model];

            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginViewController* vc = [[LoginViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }
    }];
}

@end
