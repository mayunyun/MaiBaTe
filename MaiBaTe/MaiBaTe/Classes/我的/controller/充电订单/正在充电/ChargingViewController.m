//
//  ChargingViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ChargingViewController.h"
#import "ChargingViewTableViewCell.h"
#import "ChargingModel.h"
@interface ChargingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,assign)NSMutableArray *dataArr;

@end

@implementation ChargingViewController
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 45*MYWIDTH, UIScreenW, UIScreenH-45*MYWIDTH-64)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_tableview];
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 15)];
        _tableview.tableHeaderView = head;
        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 20)];
        _tableview.tableFooterView = food;
        [_tableview registerNib:[UINib nibWithNibName:@"ChargingViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChargingViewTableViewCell"];
        
    }
    return _tableview;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor clearColor];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableview reloadData];
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ChargingViewTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ChargingViewTableViewCell"];
    if (!cell) {
        cell=[[ChargingViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChargingViewTableViewCell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ChargingModel*model=self.dataArr[indexPath.row];
    cell.data = model;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
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
