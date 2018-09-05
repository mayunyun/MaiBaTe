//
//  MyCarViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyCarViewController.h"
#import "MyCarTableViewCell.h"
#import "AddMyCarViewController.h"
#import "LoginViewController.h"
@interface MyCarViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation MyCarViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNew];

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
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_tableview];
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 10)];
        _tableview.tableHeaderView = head;
        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 65*MYWIDTH)];
        UIButton *addCar = [[UIButton alloc]init];
        [addCar setFrame:CGRectMake(15*MYWIDTH,10*MYWIDTH, UIScreenW-30*MYWIDTH, 45*MYWIDTH)];
        ;
        [addCar setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        [addCar setTitle:@"添加车辆" forState:UIControlStateNormal];
        [addCar addTarget:self action:@selector(addCarButClicked) forControlEvents:UIControlEventTouchUpInside];
        [food addSubview:addCar];
        _tableview.tableFooterView = food;
        
        [_tableview registerClass:[MyCarTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MyCarTableViewCell class])];
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
    }
    return _tableview;
    
}
//下拉刷新
- (void)loadNewData{
    
    [self loadNew];
    [_tableview.mj_header endRefreshing];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的车辆Nar.png"]];
    titleImage.frame = CGRectMake(5, 3, 17, 19);
    [titleView addSubview:titleImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 75, 25)];
    titleLab.text = @"我的车辆";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    self.navigationItem.titleView = titleView;
    self.dataArr = [[NSMutableArray alloc]init];
    [self tableview];
}

#pragma 在这里面请求数据
- (void)loadNew
{
    
    [_dataArr removeAllObjects];
    NSString *URLStr = @"/mbtwz/elecar?action=getMyCar";
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:nil success:^(id response) {
        
        NSArray* Array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        NSSLog(@"xilie%@",Array);
        if (Array.count) {
            for (NSDictionary *diction in Array) {
                //建立模型
                MyCarModel *model=[[MyCarModel alloc]init];
                [model setValuesForKeysWithDictionary:diction];
                //追加数据
                [self.dataArr addObject:model];
            }
        }
        [_tableview reloadData];

    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class MainTitleClass = [MyCarTableViewCell class];
    MyCarTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainTitleClass)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!IsEmptyValue(_dataArr)) {
        MyCarModel *model = _dataArr[indexPath.row];
        [cell setData:model];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSLog(@"%ld",indexPath.row);
}
- (void)addCarButClicked{
    [Command isloginRequest:^(bool str) {
        if (str) {
            AddMyCarViewController *addCar = [[AddMyCarViewController alloc]init];
            [self.navigationController pushViewController:addCar animated:YES];
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
