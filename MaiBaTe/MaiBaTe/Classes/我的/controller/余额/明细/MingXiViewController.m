//
//  MingXiViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MingXiViewController.h"
//#import "MingXiTableViewCell.h"
#import "XiaoFeiTableViewCell.h"
#import "MingXiModel.h"
@interface MingXiViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation MingXiViewController

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 20)];
        _tableview.tableHeaderView = head;
        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 80*MYWIDTH)];
        
        UIButton *shixiao = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/2-75*MYWIDTH, 20*MYWIDTH, 150*MYWIDTH, 40*MYWIDTH)];
        [shixiao setTitle:@"开取发票" forState:UIControlStateNormal];
        [shixiao setBackgroundColor:UIColorFromRGB(MYColor)];
        shixiao.titleLabel.font = [UIFont systemFontOfSize:13];
        shixiao.layer.cornerRadius = 5;
        //[food addSubview:shixiao];
        _tableview.tableFooterView = food;
        //[_tableview registerNib:[UINib nibWithNibName:@"MingXiTableViewCell" bundle:nil] forCellReuseIdentifier:@"MingXiTableViewCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"XiaoFeiTableViewCell" bundle:nil] forCellReuseIdentifier:@"XiaoFeiTableViewCell"];

        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

    }
    
    return _tableview;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"账单明细";
    _dataArr = [[NSMutableArray alloc]init];
    [self tableview];
    [self loadNew];
}
//下拉刷新
- (void)loadNewData{
    
    [self loadNew];
    [_tableview.mj_header endRefreshing];
    
}
#pragma 在这里面请求数据
- (void)loadNew
{
    [_dataArr removeAllObjects];
    //最新动态
    NSString *XWURLStr = @"/mbtwz/wallet?action=getCustRecharge";
    [Command loadDataWithParams:nil withPath:XWURLStr completionBlock:^(id responseObject, NSError *error) {
        NSLog(@"我的充值明细%@",responseObject);
        //建立模型
        for (NSDictionary*dic in responseObject ) {
            MingXiModel *model=[[MingXiModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            //追加数据
            [self.dataArr addObject:model];
        }
        if (self.dataArr.count>0) {
            [self.tableview dismissNoView];
            [self.tableview reloadData];
            
        }else{
            [self.tableview showNoView:nil image:nil certer:CGPointZero];
        }
        
    } autoShowError:YES];
    
    
    
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArr.count == 0) {
        return 0;
    }
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    MingXiModel *model;
//    if (_dataArr.count>0) {
//        model = _dataArr[indexPath.row];
//    }
//    if ([model.type intValue] == 0) {
//        return 160;
//    }else if ([model.type intValue] == 1){
//        return 130;
//    }
    return 130;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UITableViewCell *cell;
//    MingXiModel *model;
//    if (_dataArr.count>0) {
//        model = _dataArr[indexPath.row];
//    }
//    if ([model.type intValue] == 0) {
//
//        MingXiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MingXiTableViewCell"];
//        if (!cell) {
//            cell=[[MingXiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MingXiTableViewCell"];
//
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor =[UIColor clearColor];
//        [cell setData:model];
//        return cell;
//
//    }else if([model.type intValue] == 1){
        XiaoFeiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"XiaoFeiTableViewCell"];
        if (!cell) {
            cell=[[XiaoFeiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XiaoFeiTableViewCell"];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor =[UIColor clearColor];
        if (_dataArr.count) {
            MingXiModel *model = _dataArr[indexPath.row];
        [cell setData:model];
        }
        return cell;

//    }
//    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    NSLog(@"%ld",indexPath.row);
}
- (void)backToLastViewController:(UIButton *)button{
    
    if ([self.controller isEqualToString:@"pay"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else if ([self.controller isEqualToString:@"mingxi"]){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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
