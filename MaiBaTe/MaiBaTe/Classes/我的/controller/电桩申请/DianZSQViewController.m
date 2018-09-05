//
//  DianZSQViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DianZSQViewController.h"
#import "ApplyInformationViewController.h"
#import "DianZSQTableViewCell.h"
#import "LoginViewController.h"
#import "DianZSQModel.h"

@interface DianZSQViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page;
    UIButton * _bottomButton;
}
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation DianZSQViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
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
    
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"电桩申请Nar.png"]];
    titleImage.frame = CGRectMake(5, 3, 17, 19);
    [titleView addSubview:titleImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 75, 25)];
    titleLab.text = @"电桩申请";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    _dataArr = [[NSMutableArray alloc]init];
    
    [self tableview];
    [self crateBottomView];
}
-(void)loadData{
    [_dataArr removeAllObjects];

    NSString *URLStr = @"/mbtwz/elecar?action=getMyApply";
//    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"8",@"params":@""};
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:nil success:^(id response) {
        NSArray* reDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];

        NSSLog(@"电桩申请列表%@",reDic);
        for (NSMutableDictionary * dic in reDic ) {
            DianZSQModel *model=[[DianZSQModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArr addObject:model];
        }
        if (self.dataArr.count>0) {
            [self.tableview dismissNoView];
            
        }else{
            [self.tableview showNoView:nil image:nil certer:CGPointZero];
        }
        [self.tableview reloadData];
    } fail:^(NSError *error) {
        
    }];
}
-(void)crateBottomView{
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenH-64, UIScreenW, 64)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _bottomButton.frame = CGRectMake(10, 10, UIScreenW-20, bottomView.height-20);
    [_bottomButton setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
    [_bottomButton setTitle:@"申请电桩" forState:UIControlStateNormal];
    _bottomButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bottomButton addTarget:self action:@selector(ApplyDianZhuang) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_bottomButton];
    if (statusbarHeight>20) {
        bottomView.frame = CGRectMake(0, UIScreenH-64-34, UIScreenW, 64+34);
        _bottomButton.frame = CGRectMake(10, 10, UIScreenW-20, bottomView.height-20-34);

    }
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH-64) style:UITableViewStyleGrouped];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 0, UIScreenW, UIScreenH-64-34);
            
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

        [_tableview registerClass:[DianZSQTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DianZSQTableViewCell class])];
        [_tableview registerClass:[DianZSQTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DianZSQTableViewCell class])];
    }
    return _tableview;
    
}
//下拉刷新
- (void)loadNewData{
    
    [self loadData];
    [_tableview.mj_header endRefreshing];
    
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Class MainTitleClass = [DianZSQTableViewCell class];
    DianZSQTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainTitleClass)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DianZSQModel*model = self.dataArr[indexPath.section];
    if (_dataArr.count) {
        cell.data = model;
    }
    [cell setBtnClickBlock:^{
        //删除地址
        jxt_showAlertTwoButton(@"提示", @"您确定删除吗？", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"立即删除", ^(NSInteger buttonIndex) {
            [self deleteAddress:model];
        });
    }];
    return cell;
}
//删除电桩
-(void)deleteAddress:(DianZSQModel *)model{
    NSString *URLStr = @"/mbtwz/elecar?action=deleteMyele";
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\"}",model.id]};
    NSLog(@"%@",params);
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
        
        NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
        
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            jxt_showToastTitle(@"操作失败", 1);
        }else{
            jxt_showToastTitle(@"操作成功", 1);
            [self loadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)ApplyDianZhuang{
    [Command isloginRequest:^(bool str) {
        if (str) {
            ApplyInformationViewController * vc = [[ApplyInformationViewController alloc]init];
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
@end
