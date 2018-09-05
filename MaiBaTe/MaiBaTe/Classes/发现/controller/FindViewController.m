//
//  FindViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FindViewController.h"
#import "HuodongViewController.h"
#import "CarHomeViewController.h"
#import "DiscoverController.h"
#import "CircleViewController.h"
#import "QuestionViewController.h"
#import "LoginViewController.h"
#import "MeTableViewCell.h"

@interface FindViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableview;

@end

@implementation FindViewController

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled = NO;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [_tableview registerClass:[MeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MeTableViewCell class])];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 10)];
        _tableview.tableHeaderView = view;
        [self.view addSubview:_tableview];
        
    }
    return _tableview;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self ajaxCallbak];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate =(id)self;
    self.navigationItem.leftBarButtonItem = nil;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"搜索_1"] style:UIBarButtonItemStylePlain target:self action:@selector(rightToLastViewController:)];
//    [self.navigationItem.rightBarButtonItem setTintColor:NavBarItemColor];
    
    [self tableview];

}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class MainClass = [MeTableViewCell class];
    MeTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainClass)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *data = @[@"圈子",@"问答",@"电车之家",@"活动"];
    [cell setFindData:data[indexPath.row]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 0) {
        
        [Command isloginRequest:^(bool str) {
            if (str) {
                CircleViewController * cvc = [[CircleViewController alloc]init];
                cvc.htmlUrl = [NSString stringWithFormat:@"%@/maibatewz/weixin/page/faxianapp/quanzi/quanzi.html",WEB_ADDRESS];
                [self.navigationController pushViewController:cvc animated:YES];
            }else{
                jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                    
                }, @"前往", ^(NSInteger buttonIndex) {
                    LoginViewController* vc = [[LoginViewController alloc]init];
                    [self presentViewController:vc animated:YES completion:nil];
                });
            }
        }];
    }else if (indexPath.row == 1){
        QuestionViewController * qvc = [[QuestionViewController alloc]init];
        qvc.htmlUrl = [NSString stringWithFormat:@"%@/maibatewz/weixin/page/faxianapp/quanzi/question.html",WEB_ADDRESS];
        [self.navigationController pushViewController:qvc animated:YES];
    }else if(indexPath.row == 2){
        CarHomeViewController *CarHomeV = [[CarHomeViewController alloc]init];
        CarHomeV.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:CarHomeV animated:YES];
    }else if (indexPath.row == 3){
        HuodongViewController *HuodongVC = [[HuodongViewController alloc]init];
        HuodongVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:HuodongVC animated:YES];
    }
    NSLog(@"%ld",indexPath.row);
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
- (void)rightToLastViewController:(UIButton *)button{
    
}
@end
