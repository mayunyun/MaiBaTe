//
//  ApplyInformationViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/10/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ApplyInformationViewController.h"
#import "NIDropDown.h"
#import "ApplyInformationOneTableViewCell.h"
#import "ApplyInformationTwoTableViewCell.h"
@interface ApplyInformationViewController ()<UITableViewDelegate,UITableViewDataSource,NIDropDownDelegate>
{
    NIDropDown *dropDown1;
    NIDropDown *dropDown2;
    NIDropDown *dropDown3;
    
    NSMutableArray * provinceNameArr;
    NSMutableArray * provinceIdArr;
    NSMutableArray * cityNameArr;
    NSMutableArray * cityIdArr;
    NSMutableArray * townNameArr;
    NSMutableArray * townIdArr;
    NSString * provinceId;
    NSString * cityId;
    NSString * townId;
}
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)UIButton * okBtn;
@end

@implementation ApplyInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate =(id)self;
    self.view.backgroundColor = UIColorFromRGB(0xEEEEEE);
    self.title = @"申请信息";

    _okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _okBtn.frame = CGRectMake(10, UIScreenH-64, UIScreenW-20, 44);
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _okBtn.layer.cornerRadius = 5.0f;
    _okBtn.layer.masksToBounds = YES;
    [_okBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    _okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_okBtn setBackgroundColor:UIColorFromRGB(0xffb400)];
    [self.view addSubview:_okBtn];
    [_okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self tableview];
    //添加手势，为了关闭键盘的操作
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
    
}
-(void)okBtnClick:(UIButton *)button{
    NSIndexPath *  indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ApplyInformationOneTableViewCell * cell = [_tableview cellForRowAtIndexPath:indexPath];
    NSIndexPath *  indexPaths = [NSIndexPath indexPathForRow:0 inSection:1];
    ApplyInformationTwoTableViewCell * cells = [_tableview cellForRowAtIndexPath:indexPaths];
    if ([[Command convertNull:cell.nameTexfield.text] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写姓名", 1);
        return;
    }
    if ([[Command convertNull:cell.telphoneTextfield.text] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写手机号", 1);
        return;
    }
    if (![Command isMobileNumber:[Command convertNull:cell.telphoneTextfield.text]]) {
        jxt_showToastTitle(@"请填写正确的手机号", 1);
        return;
    }
    if ([[Command convertNull:provinceId] isEqualToString:@""]) {
        jxt_showToastTitle(@"请选择省", 1);
        return;
    }
    if ([[Command convertNull:cityId] isEqualToString:@""]) {
        jxt_showToastTitle(@"请选择市", 1);
        return;
    }
    if ([[Command convertNull:townId] isEqualToString:@""]) {
        jxt_showToastTitle(@"请选择区", 1);
        return;
    }
    
    if ([[Command convertNull:cells.detailAddressTf.text] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写详细地址", 1);
        return;
    }
    [self addCustAddress:cell andSecondCell:cells];
}
//添加电桩请求
-(void)addCustAddress:(ApplyInformationOneTableViewCell*)cell andSecondCell:(ApplyInformationTwoTableViewCell *)secondCell{
    NSString *URLStr = @"/mbtwz/elecar?action=addMyEle";
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"address\":\"%@\",\"status\":\"%@\",\"custname\":\"%@\",\"custphone\":\"%@\",\"reson\":\"%@\"}",provinceId,cityId,townId,secondCell.detailAddressTf.text,@"0",cell.nameTexfield.text,cell.telphoneTextfield.text,secondCell.postCodeTf.text]};
    NSLog(@"%@",params);
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
        
        NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
        
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            jxt_showToastTitle(@"操作失败", 1);
        }else{
            jxt_showToastTitle(@"操作成功", 1);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    } fail:^(NSError *error) {
        
    }];
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, UIScreenW, UIScreenH-64-64) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
    }
    return _tableview;
    
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120;
    }else{
        
        return 200;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        static NSString * stringCell = @"ApplyInformationTwoTableViewCell";
        ApplyInformationTwoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
            
        }
        //        __weak typeof(self) weakSelf = self;
        __weak ApplyInformationTwoTableViewCell * weakCell = cell;
        //省份选择
        [cell setProvenceBtnBlock:^{
            
            [self loadProvince:weakCell];
            
            
            
        }];
        //城市选择
        [cell setCityBtnBlock:^{
            //如果没有传入provinceId 则城市选择不能选择
            if (![[Command convertNull:provinceId] isEqualToString:@""]) {
                [self loadCity:weakCell];
                
            }
        }];
        //县区选择
        [cell setTownBtnBlock:^{
            //如果没有传入cityId 则区选择不能选择
            if (![[Command convertNull:cityId] isEqualToString:@""]) {
                [self loadCountry:weakCell];
            }
        }];
        
        cell.bgview.backgroundColor = [UIColor whiteColor];
        cell.bgview.layer.cornerRadius = 8.0f;
        cell.provenceBtn.layer.cornerRadius = 14.0;//2.0是圆角的弧度，根据需求自己更改
        cell.provenceBtn.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;//设置边框颜色
        cell.provenceBtn.layer.borderWidth = 0.5f;//设置边缘宽度
        
        cell.cityBtn.layer.cornerRadius = 14.0;
        cell.cityBtn.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        cell.cityBtn.layer.borderWidth = 0.5f;
        
        cell.townBtn.layer.cornerRadius = 14.0;
        cell.townBtn.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        cell.townBtn.layer.borderWidth = 0.5f;
        
        cell.detailAddressTf.layer.cornerRadius = 16;
        cell.detailAddressTf.layer.borderWidth = 0.5;
        cell.detailAddressTf.layer.masksToBounds = YES;
        cell.detailAddressTf.layer.borderColor = (UIColorFromRGB(0xcccccc)).CGColor;
        
        cell.postCodeTf.layer.cornerRadius = 16;
        cell.postCodeTf.layer.borderWidth = 0.5;
        cell.postCodeTf.layer.masksToBounds = YES;
        cell.postCodeTf.layer.borderColor = (UIColorFromRGB(0xcccccc)).CGColor;
        cell.backgroundColor = UIColorFromRGB(0xEEEEEE);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        static NSString * stringCell = @"ApplyInformationOneTableViewCell";
        ApplyInformationOneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
            
        }
        cell.bgview.backgroundColor = [UIColor whiteColor];
        cell.bgview.layer.cornerRadius = 8.0f;
        cell.nameTexfield.layer.cornerRadius = 16;
        cell.nameTexfield.layer.borderWidth = 0.5;
        cell.nameTexfield.layer.masksToBounds = YES;
        cell.nameTexfield.layer.borderColor = (UIColorFromRGB(0xcccccc)).CGColor;
        
        
        cell.telphoneTextfield.layer.cornerRadius = 16;
        cell.telphoneTextfield.layer.borderWidth = 0.5;
        cell.telphoneTextfield.layer.masksToBounds = YES;
        cell.telphoneTextfield.layer.borderColor = (UIColorFromRGB(0xcccccc)).CGColor;
        cell.backgroundColor = UIColorFromRGB(0xEEEEEE);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)loadProvince:(ApplyInformationTwoTableViewCell *)cell{
    provinceNameArr = [NSMutableArray array];
    provinceIdArr = [NSMutableArray array];
    [cell.cityBtn setTitle:@"市" forState:UIControlStateNormal];
    [cell.townBtn setTitle:@"区/县" forState:UIControlStateNormal];
    cityId = @"";
    townId = @"";
    [dropDown2 hideDropDown:cell.cityBtn];
    [dropDown3 hideDropDown:cell.townBtn];
    NSString *URLStr = @"/mbtwz/address?action=loadProvince";
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:nil success:^(id response) {
        NSArray* reArr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSSLog(@"设置省份地址%@",reArr);
        for (NSMutableDictionary * dic in reArr) {
            [provinceNameArr addObject:[dic objectForKey:@"areaname"]];
            [provinceIdArr addObject:[dic objectForKey:@"areaid"]];
            
        }
        NSArray * arrImage = [[NSArray alloc] init];
        arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], nil];
        if(dropDown1 == nil) {
            CGFloat f = 200*MYWIDTH;
            dropDown1 = [[NIDropDown alloc]showDropDown:cell.provenceBtn :&f :provinceNameArr :arrImage :@"down"];
            dropDown1.delegate = self;
            
        }
        else {
            [dropDown1 hideDropDown:cell.provenceBtn];
            [self rel1];
        }
    } fail:^(NSError *error) {
        
    }];
}
-(void)loadCity:(ApplyInformationTwoTableViewCell *)cell{
    cityNameArr = [NSMutableArray array];
    cityIdArr = [NSMutableArray array];
    [cell.townBtn setTitle:@"区/县" forState:UIControlStateNormal];
    townId = @"";
    [dropDown1 hideDropDown:cell.provenceBtn];
    [dropDown3 hideDropDown:cell.townBtn];
    NSString *URLStr = @"/mbtwz/address?action=loadCity";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"provinceid\":\"%@\"}",provinceId]};
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
        NSArray* reArr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //                NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
        NSSLog(@"设置城市%@",reArr);
        for (NSMutableDictionary * dic in reArr) {
            [cityNameArr addObject:[dic objectForKey:@"areaname"]];
            [cityIdArr addObject:[dic objectForKey:@"areaid"]];
        }
        NSArray * arrImage = [[NSArray alloc] init];
        arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], nil];
        if(dropDown2 == nil) {
            CGFloat f = 200*MYWIDTH;
            dropDown2 = [[NIDropDown alloc]showDropDown:cell.cityBtn :&f :cityNameArr :arrImage :@"down"];
            dropDown2.delegate = self;
            
        }
        else {
            [dropDown2 hideDropDown:cell.cityBtn];
            [self rel2];
        }
    } fail:^(NSError *error) {
        
    }];
    
    
}
-(void)loadCountry:(ApplyInformationTwoTableViewCell *)cell{
    townNameArr = [NSMutableArray array];
    townIdArr = [NSMutableArray array];
    [dropDown2 hideDropDown:cell.cityBtn];
    [dropDown1 hideDropDown:cell.provenceBtn];
    NSString *URLStr = @"/mbtwz/address?action=loadCountry";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"cityid\":\"%@\"}",cityId]};
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
        NSArray* reArr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //                NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
        NSSLog(@"设置区%@",reArr);
        for (NSMutableDictionary * dic in reArr) {
            [townNameArr addObject:[dic objectForKey:@"areaname"]];
            [townIdArr addObject:[dic objectForKey:@"areaid"]];
        }
        NSArray * arrImage = [[NSArray alloc] init];
        arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], nil];
        if(dropDown3 == nil) {
            CGFloat f = 200*MYWIDTH;
            dropDown3 = [[NIDropDown alloc]showDropDown:cell.townBtn :&f :townNameArr :arrImage :@"down"];
            dropDown3.delegate = self;
            
        }
        else {
            [dropDown3 hideDropDown:cell.townBtn];
            [self rel3];
        }
    } fail:^(NSError *error) {
        
    }];
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender index:(NSInteger)index{
    
    //    _orderselectFlag = [NSString stringWithFormat:@"%li",(long)index];
    //    NSLog(@"点击了那个id%@",_orderstatuIdArray[index]);
    //    _orderselect = YES;
    
    if (sender == dropDown1) {
        provinceId = [NSString stringWithFormat:@"%@",provinceIdArr[index]];
    }
    if (sender == dropDown2) {
        cityId = [NSString stringWithFormat:@"%@",cityIdArr[index]];
        
    }
    if (sender == dropDown3) {
        
        townId = [NSString stringWithFormat:@"%@",townIdArr[index]];
    }
    [self rel1];
    [self rel2];
    [self rel3];
}

-(void)rel1{
    dropDown1 = nil;
}
-(void)rel2{
    dropDown2 = nil;
}
-(void)rel3{
    dropDown3 = nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
