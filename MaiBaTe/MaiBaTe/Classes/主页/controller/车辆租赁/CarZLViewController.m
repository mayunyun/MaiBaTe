//
//  CarZLViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/9/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CarZLViewController.h"
#import "AddCarZLViewController1.h"
#import "ZuLinCarTableViewCell.h"
#import "ProvinceViewController.h"
#import "CarZLDetailsViewController.h"
@interface CarZLViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIButton * _locationBut;
    UITextField *_carField;
    UIImageView *_imageview;
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation CarZLViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"baiNat"];
    if (statusbarHeight>20) {
        image = [UIImage imageNamed:@"baiNat_X"];
    }
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0x333333)];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"车辆租赁_1"]];
    titleImage.frame = CGRectMake(5, 3, 20, 19);
    [titleView addSubview:titleImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(28, 0, 75, 25)];
    titleLab.text = @"车辆租赁";
    titleLab.textColor = UIColorFromRGB(0x333333);
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    
    UIImage *image = [UIImage imageNamed:@"形状-12"];
    _locationBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locationBut addTarget:self action:@selector(leftToLastViewController) forControlEvents:UIControlEventTouchUpInside];
    [_locationBut setFrame:CGRectMake(0, 0, 120, 40)];
    [_locationBut setTitle:self.city forState:UIControlStateNormal];
    _locationBut.titleLabel.font = [UIFont systemFontOfSize:15];
    [_locationBut setImage:image forState:UIControlStateNormal];
    [_locationBut setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    CGSize size = [_locationBut.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize size1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
    _locationBut.frame = CGRectMake(0, 0, size1.width+25, size1.height);
    [_locationBut setImageEdgeInsets:UIEdgeInsetsMake(0, size1.width+10, 0, 0)];
    [_locationBut setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 10)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBut];
    
//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW/2-115*MYWIDTH, UIScreenH/2-115*MYWIDTH, 230*MYWIDTH, 230*MYWIDTH)];
//    image.image = [UIImage imageNamed:@"建设中"];
//    [self.view addSubview:image];
    //添加手势，为了关闭键盘的操作
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataCity:) name:@"city" object:nil];
    
    _dataArr = [[NSMutableArray alloc]init];
    [self tableview];
    [self loadNewCar_name:@""];
}

//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
    
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 50*MYWIDTH)];
        head.layer.cornerRadius = head.height *0.5;
        _tableview.tableHeaderView = head;
        
        
        
        _carField = [[UITextField alloc]initWithFrame:CGRectMake(head.left+15*MYWIDTH, head.top+10*MYWIDTH, head.width-30*MYWIDTH, head.height-14*MYWIDTH)];
        //carField.delegate = self;
        _carField.backgroundColor = [UIColor whiteColor];
        _carField.placeholder = @"输入相关车型搜索";
        _carField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13*MYWIDTH];
        _carField.textAlignment = NSTextAlignmentCenter;
        _carField.textColor = UIColorFromRGB(0x333333);
        _carField.layer.masksToBounds = YES;
        _carField.layer.cornerRadius = _carField.height*0.5;
        _carField.delegate = self;
        [_carField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [head addSubview:_carField];
        [Command placeholderColor:_carField str:_carField.placeholder color:UIColorFromRGB(0x666666)];
        
        _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(head.left+100*MYWIDTH, head.top+20*MYWIDTH, 15*MYWIDTH, 15*MYWIDTH)];
        _imageview.image = [UIImage imageNamed:@"查询"];
        [head addSubview:_imageview];
        
        [_tableview registerClass:[ZuLinCarTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ZuLinCarTableViewCell class])];
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
    }
    
    return _tableview;
    
}
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    if (theTextField.text.length>0) {
        
        [self loadNewCar_name:[NSString stringWithFormat:@"%@",theTextField.text]];
    }else{
        [self loadNewCar_name:@""];
    }
}
- (void)leftToLastViewController{
    ProvinceViewController *provc = [[ProvinceViewController alloc]init];
    [self.navigationController pushViewController:provc animated:YES];
}
//下拉刷新
- (void)loadNewData{
    [_carField resignFirstResponder];
    //_imageview.frame = CGRectMake(100*MYWIDTH, 20*MYWIDTH, 15*MYWIDTH, 15*MYWIDTH);
    [self loadNewCar_name:_carField.text];
    [_tableview.mj_header endRefreshing];
    
}
#pragma 在这里面请求数据
- (void)loadNewCar_name:(NSString *)car_name
{
    //
    NSString *XWURLStr = @"/mbtwz/leasecar?action=searchleasecar";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"cityname\":\"%@\",\"car_name\":\"%@\"}",_locationBut.titleLabel.text,car_name]};
    [_dataArr removeAllObjects];

    [HTNetWorking postWithUrl:XWURLStr refreshCache:YES params:params success:^(id response) {
        [_dataArr removeAllObjects];

        NSArray* Array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        NSSLog(@"zulin%@",Array);
        if (Array.count) {
            for (NSDictionary *diction in Array) {
                //建立模型
                ZuLinModel *model=[[ZuLinModel alloc]init];
                [model setValuesForKeysWithDictionary:diction];
                //追加数据
                [self.dataArr addObject:model];
            }
        }
        if (self.dataArr.count>0) {
            [self.tableview dismissNoView];
        }else{
            //    [self.tableview showNoView:nil image:nil certer:CGPointZero];
        }
        [self.tableview reloadData];

        
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArr.count == 0) {
        return 0;
    }
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 220*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Class ZuLinCarClass = [ZuLinCarTableViewCell class];
    ZuLinCarTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZuLinCarClass)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =[UIColor clearColor];
    if (_dataArr.count) {
        ZuLinModel *model = _dataArr[indexPath.row];
        [cell setdata:model];
        cell.xiangqingbut.tag = indexPath.row;
        [cell.xiangqingbut addTarget:self action:@selector(xiangqingbutClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [Command isloginRequest:^(bool str) {
        if (str) {
            
            AddCarZLViewController1 *addcar = [[AddCarZLViewController1 alloc]init];
            addcar.city = _locationBut.titleLabel.text;
            ZuLinModel *model = _dataArr[indexPath.row];
            addcar.carname = model.car_name;
            addcar.carnameid = model.id;
            [self.navigationController pushViewController:addcar animated:YES];
            
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginViewController* vc = [[LoginViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }
    }];
    
    
}
- (void)xiangqingbutClick:(UIButton *)but{
    ZuLinModel *model = _dataArr[but.tag];
    CarZLDetailsViewController *carDetail = [[CarZLDetailsViewController alloc]init];
    carDetail.data = model;
    [self.navigationController pushViewController:carDetail animated:YES];
}
- (void)getLoadDataCity:(NSNotification *)notifiation{
    NSLog(@"%@",notifiation.userInfo);
    [_locationBut setTitle:[NSString stringWithFormat:@"%@",notifiation.userInfo] forState:UIControlStateNormal];
    CGSize size = [_locationBut.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize size1 = CGSizeMake(ceilf(size.width), ceilf(size.height));
    _locationBut.frame = CGRectMake(0, 0, size1.width+25, size1.height);
    [_locationBut setImageEdgeInsets:UIEdgeInsetsMake(0, size1.width+10, 0, 0)];
    [_locationBut setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 10)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_locationBut];
    _carField.text = @"";
    [_carField resignFirstResponder];
    //_imageview.frame = CGRectMake(100*MYWIDTH, 20*MYWIDTH, 15*MYWIDTH, 15*MYWIDTH);
    [self loadNewCar_name:@""];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self loadNewCar_name:textField.text];
    return [textField resignFirstResponder];
}
- ( void )textFieldDidBeginEditing:( UITextField*)textField{
    //_imageview.frame = CGRectMake(20*MYWIDTH, 20*MYWIDTH, 15*MYWIDTH, 15*MYWIDTH);
}

- ( void )textFieldDidEndEditing:( UITextField *)textField
{
//    if ([textField.text isEqualToString:@""]) {
//        _imageview.frame = CGRectMake(100*MYWIDTH, 20*MYWIDTH, 15*MYWIDTH, 15*MYWIDTH);
//    }
}
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"city" object:nil];
}



@end
