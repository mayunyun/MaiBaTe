//
//  MyPurseViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyPurseViewController.h"
#import "MyPurseTableViewCell.h"

#import "MyYeEViewController.h"
#import "YouHuiJuanViewController.h"
#import "ScoresViewController.h"
#import "MeModel.h"
@interface MyPurseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_headtitle;
    UIImageView *_headview;
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation MyPurseViewController
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled =NO;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 220*MYWIDTH)];
        
        UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 200*MYWIDTH)];
        bgimage.image = [UIImage imageNamed:@"头像背景_1"];
        [bgview addSubview:bgimage];
    
        UIImageView *headviewBG = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, bgimage.height/2-55*MYWIDTH, 110*MYWIDTH, 110*MYWIDTH)];
        headviewBG.image = [UIImage imageNamed:@"默认头像BG"];
        headviewBG.layer.masksToBounds = YES;
        headviewBG.layer.cornerRadius = headviewBG.width/2;
        [bgimage addSubview:headviewBG];
        
        _headview = [[UIImageView alloc]initWithFrame:CGRectMake(12*MYWIDTH, 12*MYWIDTH, 86*MYWIDTH, 86*MYWIDTH)];
        _headview.image = [UIImage imageNamed:@"默认头像"];
        _headview.layer.masksToBounds = YES;
        _headview.layer.cornerRadius = _headview.width/2;
        [headviewBG addSubview:_headview];
        
        _headtitle  = [[UILabel alloc]initWithFrame:CGRectMake(headviewBG.x+headviewBG.width+10, headviewBG.y+headviewBG.width/2-10, 200, 20)];
        _headtitle.text = @"麦巴特用户";
        _headtitle.textAlignment = NSTextAlignmentLeft;
        _headtitle.textColor = UIColorFromRGB(0x333333);
        _headtitle.font = [UIFont systemFontOfSize:16];
        [bgview addSubview:_headtitle];
        
        _tableview.tableHeaderView = bgview;
        
        [_tableview registerClass:[MyPurseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MyPurseTableViewCell class])];
        
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
    _dataArr = [[NSMutableArray alloc]init];

    self.navigationItem.title = @"我的钱包";
    [self tableview];
}
#pragma 在这里面请求数据
- (void)loadNew
{
    [_dataArr removeAllObjects];
    
    NSString *XWURLStr = @"/mbtwz/personal?action=getPersonalInfo";
    [Command loadDataWithParams:nil withPath:XWURLStr completionBlock:^(id responseObject, NSError *error) {
        NSLog(@"我的信息%@",responseObject);
        //建立模型
        if (!(responseObject == nil)) {
            MeModel *model=[[MeModel alloc]init];
            [model setValuesForKeysWithDictionary:responseObject[0]];
            //追加数据
            [_dataArr addObject:model];
            [self settitledata];
        }
        [_tableview reloadData];
        
    } autoShowError:YES];
}
- (void)settitledata{
    MeModel *model = _dataArr[0];
    if ([[NSString stringWithFormat:@"%@",model.custname] isEqualToString:@"(null)"]) {
        _headtitle.text = @"麦巴特用户";
    }else{
        _headtitle.text = model.custname;
    }
    
    if (![[NSString stringWithFormat:@"%@",model.autoname] isEqualToString:@"(null)"]) {
        NSString *image = [NSString stringWithFormat:@"%@/%@/%@",PHOTO_ADDRESS,model.folder,model.autoname];
        NSLog(@"%@",image);
        [_headview sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class MainClass = [MyPurseTableViewCell class];
    MyPurseTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainClass)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *data = @[@"余额",@"优惠券",@"积分"];
    [cell setdata:data[indexPath.row]];
    if (indexPath.row == 0) {
        cell.otherView.text = @"0元";
    }else if (indexPath.row == 1){
        cell.otherView.text = @"0张";
    }else if (indexPath.row == 2){
        cell.otherView.text = @"0麦豆";
    }
    if (_dataArr.count>0) {
        MeModel *model = _dataArr[0];
        if (indexPath.row == 0) {
            if ([[NSString stringWithFormat:@"%@",model.balance] isEqualToString:@"(null)"]) {
                cell.otherView.text = @"0元";
            }else{
                cell.otherView.text = [NSString stringWithFormat:@"%.2f元",[model.balance floatValue]];
            }
        }else if (indexPath.row == 1){
            if ([[NSString stringWithFormat:@"%@",model.tickets] isEqualToString:@"(null)"]) {
                cell.otherView.text = @"0张";
            }else{
                cell.otherView.text = [NSString stringWithFormat:@"%@张",model.count];
            }
        }else if (indexPath.row == 2){
            if ([[NSString stringWithFormat:@"%@",model.scores] isEqualToString:@"(null)"]) {
                cell.otherView.text = @"0麦豆";
            }else{
                cell.otherView.text = [NSString stringWithFormat:@"%@麦豆",model.scores];
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MyYeEViewController *MyYuE = [[MyYeEViewController alloc]init];
        [self.navigationController pushViewController:MyYuE animated:YES];
    }else if (indexPath.row == 1){
        YouHuiJuanViewController *YouHuiJuan = [[YouHuiJuanViewController alloc]init];
        if (_dataArr.count>0) {
           // YouHuiJuan.model = _dataArr[0];
        }
        [self.navigationController pushViewController:YouHuiJuan animated:YES];
    }else if (indexPath.row == 2){
        ScoresViewController *ScoresView = [[ScoresViewController alloc]init];
        if (_dataArr.count>0) {
            ScoresView.model = _dataArr[0];
        }
        [self.navigationController pushViewController:ScoresView animated:YES];
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
