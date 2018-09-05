//
//  YouHuiJuanViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YouHuiJuanViewController.h"
#import "YouHuiJuanTableViewCell.h"
@interface YouHuiJuanViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;


@end

@implementation YouHuiJuanViewController

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
        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 20*MYWIDTH)];
        
//        UIButton *shixiao = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/2-75*MYWIDTH, 20*MYWIDTH, 150*MYWIDTH, 40*MYWIDTH)];
//        [shixiao setTitle:@"查看已失效优惠券" forState:UIControlStateNormal];
//        [shixiao setBackgroundColor:UIColorFromRGB(0x999999)];
//        shixiao.titleLabel.font = [UIFont systemFontOfSize:13];
//        shixiao.layer.cornerRadius = 5;
//        [food addSubview:shixiao];
        _tableview.tableFooterView = food;
        [_tableview registerNib:[UINib nibWithNibName:@"YouHuiJuanTableViewCell" bundle:nil] forCellReuseIdentifier:@"YouHuiJuanTableViewCell"];
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

    }
    return _tableview;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"优惠券";
    _dataArr = [[NSMutableArray alloc]init];
    [self tableview];
    [self dataRequest];
//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW/2-115*MYWIDTH, UIScreenH/2-115*MYWIDTH, 230*MYWIDTH, 230*MYWIDTH)];
//    image.image = [UIImage imageNamed:@"建设中"];
//    [self.view addSubview:image];
    
}
//下拉刷新
- (void)loadNewData{
    
    [self dataRequest];
    [_tableview.mj_header endRefreshing];
    
}
- (void)dataRequest{
    [_dataArr removeAllObjects];
    [HTNetWorking postWithUrl:@"/mbtwz/WxCoupon?action=getCustTickets" refreshCache:YES params:nil success:^(id response) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",array);
        if (!IsEmptyValue(array)) {
            for (NSDictionary *dic in array) {
                YouHuiModel *model=[[YouHuiModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArr addObject:model];
            }
            [_tableview reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YouHuiJuanTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YouHuiJuanTableViewCell"];
    if (!cell) {
        cell=[[YouHuiJuanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YouHuiJuanTableViewCell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArr.count>0) {
        //圆角
        cell.bgview.frame = CGRectMake(15, 0, UIScreenW-30, 150);
        UIBezierPath *maskPath;
        if (indexPath.row == 0) {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bgview.bounds byRoundingCorners:UIRectCornerTopRight |UIRectCornerTopLeft cornerRadii:CGSizeMake(8, 8)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = cell.bgview.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.bgview.layer.mask = maskLayer;
        }else if (indexPath.row == _dataArr.count-1){
            maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bgview.bounds byRoundingCorners:UIRectCornerBottomRight |UIRectCornerBottomLeft cornerRadii:CGSizeMake(8, 8)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = cell.bgview.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.bgview.layer.mask = maskLayer;
        }
        YouHuiModel *model = _dataArr[indexPath.row];
        cell.nameLab.text = [NSString stringWithFormat:@"%@",model.cheap_name];
        cell.moneyLab.text = [NSString stringWithFormat:@"￥%.2f",[model.cheap_equal_money floatValue]];
        cell.cheap_descriptLab.text = [NSString stringWithFormat:@"%@",model.cheap_descript];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_push isEqualToString:@"1"]) {
        YouHuiModel *model = _dataArr[indexPath.row];
        if (_youhuiVaule) {
            _youhuiVaule(model);
        }
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
