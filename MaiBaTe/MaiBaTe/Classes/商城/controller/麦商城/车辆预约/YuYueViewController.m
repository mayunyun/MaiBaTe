//
//  YuYueViewController.m
//  MaiBaTe
//
//  Created by 钱龙 on 17/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YuYueViewController.h"
#import "YuYueTableViewCell.h"
#import "MyApplyModel.h"
@interface YuYueViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page;
}
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation YuYueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate =(id)self;
    self.view.backgroundColor = UIColorFromRGB(0xEEEEEE);
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 75, 25)];
    titleLab.text = @"我的预约";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    _dataArr = [[NSMutableArray alloc]init];
    _page = 1;
    [self loadData];
    [self tableview];
}
//下拉刷新
- (void)loadNewData{
    [self.dataArr removeAllObjects];
    [self loadData];
    [_tableview.mj_header endRefreshing];
    
}
- (void)addUpData{
    _page++;
    [self loadData];
    [_tableview.mj_footer endRefreshing];
}

-(void)loadData{
    
    NSString *URLStr = @"/mbtwz/scshop?action=getMyApply";
    NSDictionary* params = @{@"page":[NSString stringWithFormat:@"%li",(long)_page],@"rows":@"8",@"params":@""};
    NSSLog(@"参数==%@",params);
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
        NSDictionary* reDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSSLog(@"预约列表%@",reDic);
        
        for (NSMutableDictionary * dic in [reDic objectForKey:@"rows"] ) {
            MyApplyModel *model=[[MyApplyModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArr addObject:model];
        }
        if ([[reDic objectForKey:@"total"] integerValue]==_dataArr.count) {
            [_tableview.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.dataArr.count>0) {
            [self.tableview dismissNoView];
            [self.tableview reloadData];
            
        }else{
            [self.tableview showNoView:nil image:nil certer:CGPointZero];
        }
    } fail:^(NSError *error) {
        
    }];
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH) style:UITableViewStyleGrouped];
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        
        
        [_tableview registerClass:[YuYueTableViewCell class] forCellReuseIdentifier:NSStringFromClass([YuYueTableViewCell class])];
        [_tableview registerClass:[YuYueTableViewCell class] forCellReuseIdentifier:NSStringFromClass([YuYueTableViewCell class])];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addUpData)];
    }
    return _tableview;
    
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
    return 160;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        Class MainTitleClass = [YuYueTableViewCell class];
        YuYueTableViewCell *cell = nil;
        
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainTitleClass)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_dataArr.count) {
            MyApplyModel*model = self.dataArr[indexPath.section];
            cell.data = model;
        }
        [cell setBtnClickBlock:^{
            NSLog(@"点击了删除按钮");
        }];
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}

@end
