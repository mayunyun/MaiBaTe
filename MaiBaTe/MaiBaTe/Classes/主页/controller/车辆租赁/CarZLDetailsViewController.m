//
//  CarZLDetailsViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/12/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CarZLDetailsViewController.h"
#import "CarDetailsTableViewCell.h"
@interface CarZLDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSArray *dataArr;

@end

@implementation CarZLDetailsViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"baiNat(1)"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0x333333)];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 75, 25)];
    titleLab.text = _data.car_name;
    titleLab.textColor = UIColorFromRGB(0x333333);
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = titleLab;

    if ([[NSString stringWithFormat:@"%@",self.data.typename] isEqualToString:@"物流车"]) {
        _dataArr = @[@{@"name":@"车辆型号",@"other":[NSString stringWithFormat:@"%@",_data.car_name]},
                     @{@"name":@"外观尺寸",@"other":[NSString stringWithFormat:@"%@",_data.outside_size]},
                     @{@"name":@"最大总质量",@"other":[NSString stringWithFormat:@"%@",_data.max_weight]},
                     @{@"name":@"额定载重量",@"other":[NSString stringWithFormat:@"%@",_data.rated_weight]},
                     @{@"name":@"整车重量",@"other":[NSString stringWithFormat:@"%@",_data.car_weight]},
                     @{@"name":@"电机型式",@"other":[NSString stringWithFormat:@"%@",_data.electric_mac_type]},
                     @{@"name":@"额定功率",@"other":[NSString stringWithFormat:@"%@",_data.rated_power]},
                     @{@"name":@"最大功率",@"other":[NSString stringWithFormat:@"%@",_data.max_power]},
                     @{@"name":@"电池类型",@"other":[NSString stringWithFormat:@"%@",_data.battery_type]},
                     @{@"name":@"电池容量",@"other":[NSString stringWithFormat:@"%@",_data.car_electricity]},
                     @{@"name":@"续航里程",@"other":[NSString stringWithFormat:@"%@",_data.car_extension_mileage]},
                     @{@"name":@"充电时间",@"other":[NSString stringWithFormat:@"%@",_data.charge_time]},
                     @{@"name":@"充电类型",@"other":[NSString stringWithFormat:@"%@",_data.charge_type]},
                     @{@"name":@"货厢内尺寸",@"other":[NSString stringWithFormat:@"%@",_data.inside_size]},
                     @{@"name":@"厢货空间",@"other":[NSString stringWithFormat:@"%@",_data.car_space]}
                     ];
    }else{
        _dataArr = @[@{@"name":@"车辆型号",@"other":[NSString stringWithFormat:@"%@",_data.car_name]},
                     @{@"name":@"外观尺寸",@"other":[NSString stringWithFormat:@"%@",_data.outside_size]},
                     @{@"name":@"最大总质量",@"other":[NSString stringWithFormat:@"%@",_data.max_weight]},
                     @{@"name":@"额定载重量",@"other":[NSString stringWithFormat:@"%@",_data.rated_weight]},
                     @{@"name":@"整车重量",@"other":[NSString stringWithFormat:@"%@",_data.car_weight]},
                     @{@"name":@"电机型式",@"other":[NSString stringWithFormat:@"%@",_data.electric_mac_type]},
                     @{@"name":@"额定功率",@"other":[NSString stringWithFormat:@"%@",_data.rated_power]},
                     @{@"name":@"最大功率",@"other":[NSString stringWithFormat:@"%@",_data.max_power]},
                     @{@"name":@"电池类型",@"other":[NSString stringWithFormat:@"%@",_data.battery_type]},
                     @{@"name":@"电池容量",@"other":[NSString stringWithFormat:@"%@",_data.car_electricity]},
                     @{@"name":@"续航里程",@"other":[NSString stringWithFormat:@"%@",_data.car_extension_mileage]},
                     @{@"name":@"充电时间",@"other":[NSString stringWithFormat:@"%@",_data.charge_time]},
                     @{@"name":@"充电类型",@"other":[NSString stringWithFormat:@"%@",_data.charge_type]},
                     @{@"name":@"车辆外观颜色",@"other":[NSString stringWithFormat:@"%@",_data.car_outside_color]},
                     @{@"name":@"内饰颜色",@"other":[NSString stringWithFormat:@"%@",_data.car_inside_color]},
                     @{@"name":@"车辆配置",@"other":[NSString stringWithFormat:@"%@",_data.car_configure]},
                     @{@"name":@"驱动型式",@"other":[NSString stringWithFormat:@"%@",_data.car_drive]},
                     @{@"name":@"乘坐人数",@"other":[NSString stringWithFormat:@"%@",_data.car_people]}
                     ];
    }
    
    [self tableview];
}

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_tableview];
        
        
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenW*3/5+30*MYWIDTH)];
        head.backgroundColor = [UIColor whiteColor];
        _tableview.tableHeaderView = head;
        UIImageView *carimage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 0, UIScreenW-60, UIScreenW*3/5)];
        [carimage setContentMode:UIViewContentModeScaleAspectFill];
        NSString *imageStr = [NSString stringWithFormat:@"%@/%@%@",PHOTO_ADDRESS,_data.folder,_data.autoname];
        [carimage sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"icon_noting_face"]];
        [head addSubview:carimage];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, carimage.bottom, UIScreenW, 30*MYWIDTH)];
        titleLab.backgroundColor = UIColorFromRGB(0xEEEEEE);
        titleLab.text = [NSString stringWithFormat:@"%@基本参数",self.data.typename];
        titleLab.font = [UIFont systemFontOfSize:12];
        titleLab.textColor = UIColorFromRGB(0x555555);
        titleLab.textAlignment = NSTextAlignmentCenter;
        [head addSubview:titleLab];
        [_tableview registerClass:[CarDetailsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CarDetailsTableViewCell class])];
        
        
    }
    
    return _tableview;
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 35*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Class ZuLinCarClass = [CarDetailsTableViewCell class];
    CarDetailsTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZuLinCarClass)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =[UIColor whiteColor];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = _dataArr[indexPath.row];
    [cell setdata:[dic objectForKey:@"name"] otherStr:[dic objectForKey:@"other"]];
    return cell;
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
