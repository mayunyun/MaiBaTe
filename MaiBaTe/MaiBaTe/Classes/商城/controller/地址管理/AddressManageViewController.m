//
//  AddressManageViewController.m
//  MaiBaTe
//
//  Created by 钱龙 on 17/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AddressManageViewController.h"
#import "AddressManageTableViewCell.h"
#import "addAddressTableViewCell.h"
#import "editAddressViewController.h"
@interface AddressManageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * provinceNameArr;
    NSMutableArray * provinceIdArr;
    NSString * provinceName;
    
    NSMutableArray * cityNameArr;
    NSMutableArray * cityIdArr;
    NSString * cityName;
    
    NSMutableArray * townNameArr;
    NSMutableArray * townIdArr;
    NSString * townName;
}
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation AddressManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate =(id)self;
    self.view.backgroundColor = UIColorFromRGB(0xEEEEEE);
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 75, 25)];
    titleLab.text = @"地址管理";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    _dataArr = [[NSMutableArray alloc]init];
    provinceNameArr = [NSMutableArray array];
    cityNameArr = [NSMutableArray array];
    townNameArr = [NSMutableArray array];
    provinceIdArr = [NSMutableArray array];
    cityIdArr = [NSMutableArray array];
    townIdArr = [NSMutableArray array];

    
    
    [self tableview];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
-(void)loadData{
    NSString *URLStr = @"/mbtwz/address?action=searchCustAddress";
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:nil success:^(id response) {
        NSArray* reArr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
//        NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
        NSSLog(@"查询地址列表%@",reArr);
        [_dataArr removeAllObjects];
        for (NSMutableDictionary * dic in reArr) {
            AddressModel * model = [[AddressModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArr addObject:model];
            
        }
        [_tableview reloadData];
    } fail:^(NSError *error) {
        
    }];
    [_tableview.mj_header endRefreshing];
}
-(void)loadProvinceData:(AddressModel *)model{
//    AddressManageTableViewCell * cell = [_tableview cellForRowAtIndexPath:indexPath];
    NSMutableDictionary * cityDic = [[NSMutableDictionary alloc]init];
    NSMutableDictionary * townDic = [[NSMutableDictionary alloc]init];
    NSString *URLStr = @"/mbtwz/address?action=loadProvince";
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:nil success:^(id response) {
        NSArray* reArr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSSLog(@"省份地址%@",reArr);
        for (NSMutableDictionary * dic in reArr) {
            [provinceNameArr addObject:[dic objectForKey:@"areaname"]];
            [provinceIdArr addObject:[dic objectForKey:@"areaid"]];
        }
        
        //根据省份的id获得相应的省份
        provinceName = provinceNameArr[[model.provinceid integerValue]-1];
        NSString *URLStr = @"/mbtwz/address?action=loadCity";
        NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"provinceid\":\"%@\"}",model.provinceid]};
        [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
            NSArray* reArr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            for (NSMutableDictionary * dic in reArr) {
                [cityNameArr addObject:[dic objectForKey:@"areaname"]];
                [cityDic setValue: [dic objectForKey:@"areaname"] forKey:[dic objectForKey:@"areaid"]];
            }
            //根据城市的id获得相应的城市
            cityName = [cityDic objectForKey:model.cityid];
            NSString *URLStr = @"/mbtwz/address?action=loadCountry";
            NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"cityid\":\"%@\"}",model.cityid]};
            [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
                NSArray* reArr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                for (NSMutableDictionary * dic in reArr) {
                    [townNameArr addObject:[dic objectForKey:@"areaname"]];
                    [townDic setValue: [dic objectForKey:@"areaname"] forKey:[dic objectForKey:@"areaid"]];
                }
                //根据县区的id获得相应的县区
                townName = [townDic objectForKey:model.areaid];
                //        [self loadProvinceData:model];
                //请求完成对应的城市名称成功后跳转到下个页面
                editAddressViewController * eavc = [[editAddressViewController alloc]init];
                eavc.strtitle = @"编辑地址";
                eavc.model = model;
                eavc.idString = model.id;
                eavc.provinceName = provinceName;
                eavc.cityName = cityName;
                eavc.townName = townName;
                [self.navigationController pushViewController:eavc animated:YES];

            } fail:^(NSError *error) {
                
            }];
            
        } fail:^(NSError *error) {
            
        }];
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
        
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    return _tableview;
    
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count + 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _dataArr.count) {
        
        static NSString * stringCell = @"addAddressTableViewCell";
        addAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
            
        }
        cell.sideView.layer.cornerRadius = 6.0f;
        cell.inView.layer.cornerRadius = 6.0f;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString * stringCell = @"AddressManageTableViewCell";
    AddressManageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        
    }
    AddressModel * model = _dataArr[indexPath.section];
    cell.bgview.backgroundColor = [UIColor whiteColor];
    cell.bgview.layer.cornerRadius = 8.0f;
    if ([self.controller integerValue] == 0) {
        cell.selectCurrentButton.hidden = YES;
        cell.circleImageView.hidden = YES;
    }
    
    cell.model = model;
    [cell setEditBtnClickBlock:^{
        [self loadProvinceData:model];
        
    }];
    [cell setBigEditBtnClickBlock:^{
        [self loadProvinceData:model];
    }];
    [cell setBigDelBtnClickBlock:^{
        //删除地址
        jxt_showAlertTwoButton(@"您确定删除当前地址", @"是否考虑清楚", @"再想一下", ^(NSInteger buttonIndex) {
            
        }, @"立即删除", ^(NSInteger buttonIndex) {
            [self deleteAddress:model];
        });
    }];
    [cell setDelBtnClickBlock:^{
        //删除地址
        jxt_showAlertTwoButton(@"您确定删除当前地址", @"是否考虑清楚", @"再想一下", ^(NSInteger buttonIndex) {
            
        }, @"立即删除", ^(NSInteger buttonIndex) {
            [self deleteAddress:model];
        });
    }];
    [cell setSelectCurrentButtonBlock:^{
        if (!IsEmptyValue(_dataArr)) {
            AddressModel* model =_dataArr[indexPath.section];
            if (_transVaule) {
                _transVaule(model);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [cell setSetMorenBtnBlock:^{
        
        NSString *URLStr = @"/mbtwz/address?action=updCustAddressDefault";
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\"}",model.id]};
        [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
            //            NSArray* reArr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
            NSSLog(@"设置默认地址%@",str);
            if ([str rangeOfString:@"false"].location!=NSNotFound) {
                jxt_showToastTitle(@"设置默认地址失败", 1);
            }else{
                jxt_showToastTitle(@"设置默认地址成功", 1);
                [self loadData];
            }
        } fail:^(NSError *error) {
            
        }];
    }];
    cell.nameTextField.enabled = NO;
    cell.backgroundColor = UIColorFromRGB(0xEEEEEE);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
//删除地址
-(void)deleteAddress:(AddressModel *)model{
    NSString *URLStr = @"/mbtwz/address?action=delCustAddress";
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
    if (indexPath.section == _dataArr.count) {
        editAddressViewController * vc = [[editAddressViewController alloc]init];
        vc.strtitle = @"添加地址";
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
//        if ([self.controller integerValue]  == 1) {
//            
//        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
