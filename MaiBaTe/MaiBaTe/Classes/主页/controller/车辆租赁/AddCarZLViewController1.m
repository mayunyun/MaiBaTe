//
//  AddCarZLViewController1.m
//  MaiBaTe
//
//  Created by LONG on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AddCarZLViewController1.h"
#import "AddCarZLViewController2.h"
#import "AddZuLinCarTableViewCell.h"
#import "ProvinceViewController.h"
@interface AddCarZLViewController1()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_cityLab;
    NSString *_createtime;
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSArray *timeArr;
@property(nonatomic,strong)NSArray *carNameArr;

@end

@implementation AddCarZLViewController1

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
    _dataArr = [[NSMutableArray alloc]init];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"车辆租赁_1"]];
    titleImage.frame = CGRectMake(0, 3, 20, 19);
    [titleView addSubview:titleImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(23, 0, 75, 25)];
    titleLab.text = @"车辆租赁";
    titleLab.textColor = UIColorFromRGB(0x333333);
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"客服电话"] style:UIBarButtonItemStylePlain target:self action:@selector(rightToLastViewController)];
    [self.navigationItem.rightBarButtonItem setTintColor:UIColorFromRGB(MYColor)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataCity:) name:@"city" object:nil];
    
    AddZuLinModel *model = [[AddZuLinModel alloc]init];
    model.count = 1;
    model.carname = self.carname;
    model.model_id = self.carnameid;
    model.order_type = @"1";
    model.time = @"请选择";
    [_dataArr addObject:model];
    
    [self tableview];
    [self loadNewSearchtime];
    [self loadNewSearchcity];
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [_tableview registerClass:[AddZuLinCarTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AddZuLinCarTableViewCell class])];

        [self.view addSubview:_tableview];
        
        [self setwithheadview];
        
        [self setwithfootview];
    }
    
    return _tableview;
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArr.count == 0) {
        return 0;
    }
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 245*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Class ZuLinCarClass = [AddZuLinCarTableViewCell class];
    AddZuLinCarTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZuLinCarClass)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =[UIColor clearColor];
    AddZuLinModel *model = _dataArr[indexPath.row];
    cell.model = model;
    if (_timeArr.count) {
        cell.CArr = [[NSMutableArray alloc]init];
        cell.DArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in _timeArr) {
            if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]] isEqualToString:@"1"]) {
                [cell.CArr addObject:dic];
            }else{
                [cell.DArr addObject:dic];

            }
        }
    }
    cell.NameArr = [[NSArray alloc]initWithArray:_carNameArr];
    [cell setdata:indexPath.row];
    cell.deleteBut.tag = indexPath.row;
    [cell.deleteBut addTarget:self action:@selector(deldeteButClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}
- (void)deldeteButClick:(UIButton *)but{
    jxt_showAlertTwoButton(@"提示", @"确定要删除吗？", @"取消", ^(NSInteger buttonIndex) {
        
    }, @"确定", ^(NSInteger buttonIndex) {
        [_dataArr removeObjectAtIndex:but.tag];
        [_tableview reloadData];
    });
    
}
- (void)setwithheadview{
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 130*MYWIDTH)];
    head.backgroundColor = [UIColor whiteColor];
    _tableview.tableHeaderView = head;
    
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(33*MYWIDTH, 18*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    image1.image = [UIImage imageNamed:@"租车大点"];
    [head addSubview:image1];
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW/2-6*MYWIDTH, 22*MYWIDTH, 12*MYWIDTH, 12*MYWIDTH)];
    image2.image = [UIImage imageNamed:@"租车小点"];
    [head addSubview:image2];
    UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW - 47*MYWIDTH, 22*MYWIDTH, 12*MYWIDTH, 12*MYWIDTH)];
    image3.image = [UIImage imageNamed:@"租车小点"];
    [head addSubview:image3];
    
    UIImageView *xuxian = [[UIImageView alloc]initWithFrame:CGRectMake(image1.right, 27*MYWIDTH, image2.left-image1.right, 2*MYWIDTH)];
    xuxian.image = [UIImage imageNamed:@"横虚线"];
    [head addSubview:xuxian];
    UIImageView *xuxian1 = [[UIImageView alloc]initWithFrame:CGRectMake(image2.right, 27*MYWIDTH, image3.left-image2.right, 2*MYWIDTH)];
    xuxian1.image = [UIImage imageNamed:@"横虚线"];
    [head addSubview:xuxian1];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, image1.bottom, 85*MYWIDTH, 20)];
    lab1.text = @"用车需求";
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.textColor = UIColorFromRGB(0x888888);
    lab1.font = [UIFont systemFontOfSize:12];
    [head addSubview:lab1];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW/2-40*MYWIDTH, image1.bottom, 80*MYWIDTH, 20)];
    lab2.text = @"联系方式";
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.textColor = UIColorFromRGB(0x888888);
    lab2.font = [UIFont systemFontOfSize:12];
    [head addSubview:lab2];
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW-83*MYWIDTH, image1.bottom, 83*MYWIDTH, 20)];
    lab3.text = @"提交需求";
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.textColor = UIColorFromRGB(0x888888);
    lab3.font = [UIFont systemFontOfSize:12];
    [head addSubview:lab3];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 75*MYWIDTH, UIScreenW, 1)];
    xian.backgroundColor = UIColorFromRGB(MYLine);
    [head addSubview:xian];
    
    UIImageView *iconview = [[UIImageView alloc]initWithFrame:CGRectMake(16*MYWIDTH, xian.bottom+17*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    iconview.image = [UIImage imageNamed:@"租车取"];
    [head addSubview:iconview];
    _cityLab = [[UILabel alloc]initWithFrame:CGRectMake(iconview.right+8, xian.bottom+17*MYWIDTH, 80, 20*MYWIDTH)];
    _cityLab.text = self.city;
    _cityLab.textColor = UIColorFromRGB(0x222222);
    _cityLab.font = [UIFont systemFontOfSize:14];
    [head addSubview:_cityLab];
    UIButton *cityBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW-115, xian.bottom, 100, 50*MYWIDTH)];
    [cityBut setTitle:@"点击更换取车城市" forState:UIControlStateNormal];
    cityBut.titleLabel.font = [UIFont systemFontOfSize:12];
    cityBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cityBut setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
    [cityBut addTarget:self action:@selector(cityButCilck) forControlEvents:UIControlEventTouchUpInside];
    [head addSubview:cityBut];
}
-(void)cityButCilck{
    ProvinceViewController *provc = [[ProvinceViewController alloc]init];
    [self.navigationController pushViewController:provc animated:YES];
}
- (void)setwithfootview{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 235*MYWIDTH)];
    foot.backgroundColor = [UIColor clearColor];
    _tableview.tableFooterView = foot;
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(30*MYWIDTH, 0, 300*MYWIDTH, 35*MYWIDTH)];
    lab1.text = @"如需租赁多种车型，请点击增加车型";
    lab1.textColor = UIColorFromRGB(0x888888);
    lab1.font = [UIFont systemFontOfSize:12];
    [foot addSubview:lab1];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, lab1.bottom, UIScreenW-30*MYWIDTH, 105*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.layer.cornerRadius = 10;
    [foot addSubview:bgview];
    
    UIButton *zddCar = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, bgview.width-30, 50*MYWIDTH)];
    [zddCar setImage:[UIImage imageNamed:@"增加车型"] forState:UIControlStateNormal];
    [zddCar setTitle:@" 增加车型" forState:UIControlStateNormal];
    zddCar.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [zddCar setTitleColor:UIColorFromRGB(MYColor) forState:UIControlStateNormal];
    [zddCar addTarget:self action:@selector(zddCarClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:zddCar];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, zddCar.bottom, bgview.width, 1)];
    xian.backgroundColor = UIColorFromRGB(MYLine);
    [bgview addSubview:xian];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian.bottom, 150*MYWIDTH, 50*MYWIDTH)];
    lab2.text = @"预计取车时间";
    lab2.textColor = UIColorFromRGB(0x222222);
    lab2.font = [UIFont systemFontOfSize:14];
    [bgview addSubview:lab2];
    
    UIImageView *youimage = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.width-20*MYWIDTH, xian.bottom+18*MYWIDTH, 7*MYWIDTH, 14*MYWIDTH)];
    youimage.image = [UIImage imageNamed:@"chargeback"];
    [bgview addSubview:youimage];
    
    UIButton *timeBut = [[UIButton alloc]initWithFrame:CGRectMake(lab2.right, xian.bottom, bgview.width-30*MYWIDTH-lab2.right, 50*MYWIDTH)];
    [timeBut setTitle:@"请选择" forState:UIControlStateNormal];
    timeBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [timeBut setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    timeBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [timeBut addTarget:self action:@selector(timeButClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:timeBut];
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(30*MYWIDTH, bgview.bottom, 300*MYWIDTH, 40*MYWIDTH)];
    lab3.text = @">价格更低，租期更灵活";
    lab3.textColor = UIColorFromRGB(0x888888);
    lab3.font = [UIFont systemFontOfSize:12];
    [foot addSubview:lab3];
    
    UIButton *upBut = [[UIButton alloc]initWithFrame:CGRectMake(0, lab3.bottom, UIScreenW, 55*MYWIDTH)];
    [upBut setTitle:@"下一步" forState:UIControlStateNormal];
    upBut.titleLabel.font = [UIFont systemFontOfSize:20];
    [upBut setBackgroundColor:UIColorFromRGB(MYColor)];
    [upBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [upBut addTarget:self action:@selector(ajaxCallbak) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:upBut];
}
- (void)timeButClick:(UIButton *)sender{
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDate *now = [NSDate date];
//    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
//    NSDate *startDate = [calendar dateFromComponents:components];
//    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    // 设置格式：yyyy-MM-dd HH:mm:ss
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    [BRDatePickerView showDatePickerWithTitle:@"取车时间" dateType:UIDatePickerModeDateAndTime defaultSelValue:nil minDateStr:[formatter stringFromDate:endDate] maxDateStr:@"" isAutoSelect:YES resultBlock:^(NSString *selectValue) {
//        [weakBtn setTitle:selectValue forState:UIControlStateNormal];
//        _createtime = selectValue;
//    }];
    
    __weak typeof(UIButton*) weakBtn = sender;
    __weak typeof(self) weakSelf = self;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";

    NSMutableArray *year = [[NSMutableArray alloc]init];
    for (int i=0; i<30; i++) {
        NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];

        [year addObject:[NSString stringWithFormat:@"%@",[formatter stringFromDate:endDate]]];
        startDate = [formatter dateFromString:[formatter stringFromDate:endDate]];
    }
    NSLog(@"%@",year);
    
    NSMutableArray *day = [[NSMutableArray alloc]init];
    NSString *dayStr;
    for (int i=0; i<24; i++) {
        if (i<10) {
            dayStr = [NSString stringWithFormat:@"0%d:00",i];
        }else{
            dayStr = [NSString stringWithFormat:@"%d:00",i];
        }
        [day addObject:dayStr];
    }
//    // 自定义多列字符串
    NSArray *dataSources = @[year,day];

    [BRStringPickerView showStringPickerWithTitle:@"" dataSource:dataSources defaultSelValue:weakSelf isAutoSelect:YES resultBlock:^(id selectValue) {
        [weakBtn setTitle:[NSString stringWithFormat:@"%@ %@",selectValue[0],selectValue[1]] forState:UIControlStateNormal];
        _createtime = [NSString stringWithFormat:@"%@ %@",selectValue[0],selectValue[1]];
    }];
}
- (void)zddCarClick{
    AddZuLinModel *model = [[AddZuLinModel alloc]init];
    model.count = 1;
    model.carname = @"请选择";
    model.order_type = @"1";
    model.time = @"请选择";
    [_dataArr addObject:model];
    [_tableview reloadData];
}
//- (void)ajaxCallbak{
//    [Command isloginRequest:^(bool str) {
//        if (str) {
//
//            [self upviewCilck];
//
//        }else{
//            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
//
//            }, @"前往", ^(NSInteger buttonIndex) {
//                LoginViewController* vc = [[LoginViewController alloc]init];
//                [self presentViewController:vc animated:YES completion:nil];
//            });
//        }
//    }];
//}
- (void)ajaxCallbak{
    if ([[Command convertNull:_cityLab.text] isEqualToString:@""]||[_cityLab.text isEqualToString:@"定位中"]) {
        jxt_showAlertTitle(@"请选择取车城市");
        return;
    }
    if ([[Command convertNull:_createtime] isEqualToString:@""]) {
        jxt_showAlertTitle(@"请选择预计取车时间");
        return;
    }
    NSLog(@">>>数组%@",_dataArr);
    AddCarZLViewController2 *addcar = [[AddCarZLViewController2 alloc]init];
    addcar.city = _cityLab.text;
    addcar.time = _createtime;
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    int i = 1;
    for (AddZuLinModel *model in _dataArr) {
        if (!model.model_id) {
            jxt_showAlertOneButton(@"提示", [NSString stringWithFormat:@"需求(%d):请选择车辆型号",i], @"确定", ^(NSInteger buttonIndex) {
                
            });
            return;
        }
        if (!model.during_time) {
            jxt_showAlertOneButton(@"提示", [NSString stringWithFormat:@"需求(%d):请选择租车时长",i], @"确定", ^(NSInteger buttonIndex) {
                
            });
            return;
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:@"lease_order_details" forKey:@"table"];
        [dic setValue:[NSString stringWithFormat:@"%@",model.model_id] forKey:@"model_id"];
        [dic setValue:[NSString stringWithFormat:@"%@",model.order_type] forKey:@"order_type"];
        [dic setValue:[NSString stringWithFormat:@"%zd",model.count] forKey:@"lease_count"];
        [dic setValue:model.during_time forKey:@"during_time"];
        [dataArr addObject:dic];
        i++;
    }
    addcar.carArr = [[NSArray alloc]initWithArray:dataArr];
    [self.navigationController pushViewController:addcar animated:YES];
}
- (void)getLoadDataCity:(NSNotification *)notifiation{
    NSLog(@"%@",notifiation.userInfo);
    if (![[NSString stringWithFormat:@"%@",notifiation.userInfo] isEqualToString:_cityLab.text]) {
        _cityLab.text = [NSString stringWithFormat:@"%@",notifiation.userInfo];
        [_dataArr removeAllObjects];
        [self loadNewSearchcity];
        [self zddCarClick];
    }
    
}

#pragma 在这里面请求数据
- (void)loadNewSearchtime
{
    //
    NSString *XWURLStr = @"/mbtwz/leasecar?action=searchtime";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"type\":\"%@\"}",@""]};
    
    [HTNetWorking postWithUrl:XWURLStr refreshCache:YES params:params success:^(id response) {
        _timeArr = [[NSArray alloc]init];
        _timeArr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        [_tableview reloadData];
        
    } fail:^(NSError *error) {
        
    }];

}
- (void)loadNewSearchcity
{
    NSString *URLStr = @"/mbtwz/leasecar?action=searchleasecarName";
    NSDictionary* paramsname = @{@"params":[NSString stringWithFormat:@"{\"cityname\":\"%@\"}",_cityLab.text]};
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:paramsname success:^(id response) {
        _carNameArr = [[NSArray alloc]init];
        _carNameArr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        [_tableview reloadData];
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)rightToLastViewController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定拨打电话：0531-88989022？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0531-88989022"]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"city" object:nil];
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
