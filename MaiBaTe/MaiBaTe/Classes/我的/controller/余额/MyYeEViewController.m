//
//  MyYeEViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyYeEViewController.h"
#import "MingXiViewController.h"
#import "ChongZhiViewController.h"
#import "TiXianViewController.h"
#import "MeModel.h"

@interface MyYeEViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_headtitle;
    MeModel *_model;
}
@property(nonatomic,strong)UITableView *tableview;


@end

@implementation MyYeEViewController
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled = NO;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        
        UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 200*MYWIDTH)];
        bgimage.image = [UIImage imageNamed:@"余额背景"];
        
        UILabel *title  = [[UILabel alloc]initWithFrame:CGRectMake(25*MYWIDTH, bgimage.height/4, 150*MYWIDTH, 25*MYWIDTH)];
        title.text = @"账户余额";
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = UIColorFromRGB(0x333333);
        title.font = [UIFont systemFontOfSize:15];
        [bgimage addSubview:title];
        
        _headtitle  = [[UILabel alloc]initWithFrame:CGRectMake(title.x, bgimage.height/2, UIScreenW-50*MYWIDTH, 40)];
        

        _headtitle.textAlignment = NSTextAlignmentLeft;
        _headtitle.textColor = UIColorFromRGB(0x333333);
        _headtitle.font = [UIFont systemFontOfSize:30];
        [bgimage addSubview:_headtitle];
        
        _tableview.tableHeaderView = bgimage;
        
    }
    return _tableview;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNew];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"余额";
    [self tableview];
}
#pragma 在这里面请求数据
- (void)loadNew
{
    
    NSString *XWURLStr = @"/mbtwz/personal?action=getPersonalInfo";
    [Command loadDataWithParams:nil withPath:XWURLStr completionBlock:^(id responseObject, NSError *error) {
        NSLog(@"我的信息%@",responseObject);
        //建立模型
        if (!(responseObject == nil)) {
            _model =[[MeModel alloc]init];
            [_model setValuesForKeysWithDictionary:responseObject[0]];
            //追加数据
            if ([[NSString stringWithFormat:@"￥%@",_model.balance] isEqualToString:@"(null)"]) {
                _headtitle.text = @"￥0";
            }else{
                _headtitle.text = [NSString stringWithFormat:@"￥%.2f",[_model.balance floatValue]];
            }
        }
        [_tableview reloadData];
        
    } autoShowError:YES];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*MYWIDTH;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15*MYWIDTH;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 15*MYWIDTH)];
    view.backgroundColor = UIColorFromRGB(0xEEEEEE);
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString* cellID = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头

    NSArray *arr = @[@[@"充值",@"提现"],@[@"明细"]];
    cell.textLabel.text = arr[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:arr[indexPath.section][indexPath.row]];
    if (indexPath.section == 0 && indexPath.row == 1) {
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 1)];
        xian.backgroundColor = UIColorFromRGB(MYLine);
        [cell addSubview:xian];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 1) {
        MingXiViewController *MXVC = [[MingXiViewController alloc]init];
        [self.navigationController pushViewController:MXVC animated:YES];
    }else if(indexPath.section == 0){
        if (indexPath.row == 0) {
            ChongZhiViewController *chongzhi = [[ChongZhiViewController alloc]init];
            [self.navigationController pushViewController:chongzhi animated:YES];
        }else if (indexPath.row == 1){
            TiXianViewController *tixian = [[TiXianViewController alloc]init];
            tixian.id = [NSString stringWithFormat:@"%@",_model.id];
            [self.navigationController pushViewController:tixian animated:YES];
        }
    }
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
