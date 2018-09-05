//
//  ShopCarViewController.m
//  MaiBaTe
//
//  Created by 钱龙 on 17/10/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ShopCarViewController.h"
#import "ShopCarTableViewCell.h"
#import "SABookModel.h"
#import "MJExtension.h"
#import "LoginViewController.h"
#import "ShopOrderViewController.h"
@interface ShopCarViewController ()<UITableViewDelegate,UITableViewDataSource>{
    double _xiaoji;
    UIView * footerView;
    UIButton * allSelectBtn;
    UILabel * conutLabel;
    int _goodNum;
    NSMutableArray * typeArr;
   
}
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong) NSMutableArray *  dataArr;
@property (nonatomic,strong) UILabel * totalPriceLabel;

@property (nonatomic,strong)UIButton * buyNowBtn;

@end

@implementation ShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate =(id)self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColorFromRGB(0xEEEEEE);
    self.navigationItem.title = @"购物车";
    _dataArr = [[NSMutableArray alloc]init];
    typeArr = [[NSMutableArray alloc]init];
   // [self totalPrice];
    [self crateBottomView];
    [self loadData];
    [self tableview];
}

-(void)loadData{
        /*以下三行代码是防止下拉刷新购物车时，没能改变总计和商品数量*/
        _xiaoji = 0.0;
        _goodNum = 0;
        conutLabel.text = [NSString stringWithFormat:@"已选%d件商品",_goodNum];
        //给总价文本赋值
        self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:%.2f元",_xiaoji];
        [self changeTextColor:self.totalPriceLabel Txt:self.totalPriceLabel.text changeTxt:[NSString stringWithFormat:@"%.2f",_xiaoji]];
        allSelectBtn.selected = NO;
    
        NSString *URLStr = @"/mbtwz/shoppingcart?action=searchShoppingCart";
        [SVProgressHUD showWithStatus:@"正在加载..."];
        [HTNetWorking postWithUrl:URLStr refreshCache:YES params:nil success:^(id response) {
            [SVProgressHUD dismiss];

            NSArray* reArr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            NSSLog(@"购物车列表%@",reArr);
            NSNumber *selectState = [NSNumber numberWithBool:NO];
            [_dataArr removeAllObjects];
            for (NSMutableDictionary * dic in reArr) {
                [dic setObject: selectState forKey:@"selectState"];
                SABookModel * model = [[SABookModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArr addObject:model];
            }
            if (self.dataArr.count>0) {
                [self.tableview dismissNoView];
                
            }else{
                [self.tableview showNoView:nil image:nil certer:CGPointZero];
                [footerView  removeFromSuperview];
            }
            [self.tableview reloadData];
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
    [_tableview.mj_header endRefreshing];

}
#pragma mark -- 删除商品
-(void)deleteProductAction:(SABookModel *)model{
    NSString *URLStr = @"/mbtwz/shoppingcart?action=deleteShoppingCart";
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\"}",model.id]};
    [SVProgressHUD showWithStatus:@"正在删除..."];
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
        [SVProgressHUD dismiss];

        NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
        NSSLog(@"删除操作%@",str);
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            jxt_showToastTitle(@"删除失败", 1);
        }else{
            jxt_showToastTitle(@"删除成功", 1);
            [self loadData];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}
-(void)crateBottomView{
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenH-60*MYWIDTH, UIScreenW, 60*MYWIDTH)];
    if (statusbarHeight>20) {
        bottomView.frame = CGRectMake(0, UIScreenH-60*MYWIDTH-34, UIScreenW, 60*MYWIDTH);
    }
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    self.totalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 2, 2*UIScreenW/3, bottomView.height-4)];
    self.totalPriceLabel.font = [UIFont systemFontOfSize:16];
    _xiaoji = 0.00;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:%.2f",_xiaoji];
    self.totalPriceLabel.textColor = UIColorFromRGB(0x333333);
    [self changeTextColor:self.totalPriceLabel Txt:self.totalPriceLabel.text changeTxt:[NSString stringWithFormat:@"%.2f",_xiaoji]];
    [bottomView addSubview:self.totalPriceLabel];
    self.buyNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyNowBtn.frame = CGRectMake(self.totalPriceLabel.right, 0, UIScreenW/3, bottomView.height);
    self.buyNowBtn.backgroundColor = [UIColor colorWithRed:1.00 green:0.71 blue:0.00 alpha:1.00];
    [self.buyNowBtn setTitle:@"立即结算" forState:UIControlStateNormal];
    [self.buyNowBtn addTarget:self action:@selector(ShopOrderClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.buyNowBtn];
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH-60*MYWIDTH)];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 0, UIScreenW, UIScreenH-60*MYWIDTH-34);
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        //给表格添加一个尾部视图
        
        _tableview.tableFooterView = [self createFootView];
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 15)];
        _tableview.tableHeaderView = header;

        [self.view addSubview:_tableview];
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    return _tableview;
    
}
-(UIView *)createFootView{
    footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 40)];
    allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allSelectBtn.frame = CGRectMake(12, 2, 80, 36);
    [allSelectBtn setImage:[UIImage imageNamed:@"组-9.png"] forState:UIControlStateNormal];
    [allSelectBtn setImage:[UIImage imageNamed:@"组-7.png"] forState:UIControlStateSelected];
    
    [allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    allSelectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [allSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allSelectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [allSelectBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 50)];
    [allSelectBtn addTarget:self action:@selector(allselectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:allSelectBtn];
    
    _goodNum = 0;
    conutLabel = [[UILabel alloc]initWithFrame:CGRectMake(allSelectBtn.right, 2, UIScreenW-allSelectBtn.width-20, 36)];
    conutLabel.text = [NSString stringWithFormat:@"已选%d件商品",_goodNum];
    conutLabel.font = [UIFont systemFontOfSize:15];
    conutLabel.textAlignment = NSTextAlignmentRight;
    [footerView addSubview:conutLabel];
    return footerView;
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * stringCell = @"ShopCarTableViewCell";
    ShopCarTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
    }
    SABookModel * model = self.dataArr[indexPath.row];
    cell.bookModel = model;
    
    
    if (cell.bookModel.selectState)
    {
        cell.selectState = YES;
        [cell.selectBtn setImage:[UIImage imageNamed:@"组-7.png"] forState:UIControlStateNormal];
    }else{
        cell.selectState = NO;
        [cell.selectBtn setImage:[UIImage imageNamed:@"组-9.png"] forState:UIControlStateNormal];
    }
    [cell setSelectBtnClickBlock:^{
        /**
         *  判断当前是否为选中状态，如果选中状态点击则更改成未选中，如果未选中点击则更改成选中状态
         */
        
        SABookModel *model = self.dataArr[indexPath.row];
        if (model.selectState)
        {
            model.selectState = NO;
            
        }
        else
        {
            model.selectState = YES;
            
        }
        //刷新当前行
        [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self totalPrice];
        
        allSelectBtn.selected=YES;
        for (SABookModel *model in self.dataArr) {
            if (model.selectState==NO) {
                allSelectBtn.selected=NO;
            }
        }
    }];
    [cell setDelBtnClickBlock:^{
        jxt_showAlertTwoButton(@"您确定删除当前选中商品", @"是否考虑清楚", @"再想一下", ^(NSInteger buttonIndex) {
            
        }, @"立即删除", ^(NSInteger buttonIndex) {
            [self deleteProductAction:model];
        });
    }];
    [cell setUpBtnClickBlock:^{

        [self totalPrice];
        self.buyNowBtn.enabled = YES;
        
    }];
    [cell setDownBtnClickBlock:^{
        
        [self totalPrice];
    }];
    cell.backgroundColor = UIColorFromRGB(0xeeeeee);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    SABookModel * model = self.dataArr[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        jxt_showAlertTwoButton(@"您确定删除当前选中商品", @"是否考虑清楚", @"再想一下", ^(NSInteger buttonIndex) {
            
        }, @"立即删除", ^(NSInteger buttonIndex) {
            [self deleteProductAction:model];
        });
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)allselectBtnClicked:(UIButton *)button{
    
    button.selected = !button.selected;

    //改变单元格选中状态
    for (int i=0; i<self.dataArr.count; i++)
    {
        SABookModel *model = [self.dataArr objectAtIndex:i];
        model.selectState = button.selected;
    }
    //计算价格
    [self totalPrice];
    //刷新表格
    [self.tableview reloadData];
}
#pragma mark -- 计算价格
-(void)totalPrice
{
    //遍历整个数据源，然后判断如果是选中的商品，就计算价格（单价 * 商品数量）
    for ( int i =0; i<self.dataArr.count; i++)
    {
        SABookModel *model = [self.dataArr objectAtIndex:i];
        if (model.selectState)
        {
            _xiaoji = _xiaoji + model.count *[model.price doubleValue];
            _goodNum = model.count + _goodNum;
        }
    }
    conutLabel.text = [NSString stringWithFormat:@"已选%d件商品",_goodNum];
    //给总价文本赋值
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:%.2f",_xiaoji];
    [self changeTextColor:self.totalPriceLabel Txt:self.totalPriceLabel.text changeTxt:[NSString stringWithFormat:@"%.2f",_xiaoji]];
    
    //每次算完要重置为0，因为每次的都是全部循环算一遍
    _xiaoji = 0.0;
    _goodNum = 0;
}

//改变某字符串的颜色
- (void)changeTextColor:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变颜色
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ffb400"] range:NSMakeRange(location, length)];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
}
//立即购买
- (void)ShopOrderClick{
    
    //每次点击提交订单的时候，清空一下typeArr;
    [typeArr removeAllObjects];
    //遍历整个数据源，然后判断选中的商品有没有积分商品
    for ( int i =0; i<self.dataArr.count; i++)
    {
        SABookModel *model = [self.dataArr objectAtIndex:i];
        if (model.selectState)
        {
            if (model.type) {
                
                //逐个将type放入到typeArr里面
                [typeArr addObject:model.type];
            }
            
        }
    }
    NSLog(@"%@",typeArr);
        [Command isloginRequest:^(bool str) {
        if (str) {
            if ([typeArr containsObject:@1]&&[typeArr containsObject:@2]) {
                jxt_showToastTitle(@"积分商品和普通商品不能同时结算", 2);
            }else{
                
                NSMutableString* mustr = [[NSMutableString alloc]init];
                NSInteger totalcount = 0;
                CGFloat totalmoney = 0.0;
                NSString *type;
                for (SABookModel* model in _dataArr) {
                    if (model.selectState)
                    {
                        NSString* str = [NSString stringWithFormat:@"{\"proname\":\"%@\",\"proid\":\"%@\",\"specification\":\"%@\",\"color\":\"%@\",\"table\":\"mall_pro_orderdetail\",\"count\":\"%d\",\"price\":\"%@\",\"money\":\"%@\"},",model.proname,model.proid,model.fitcar,model.color,model.count,model.price,model.money];
                        [mustr appendString:str];
                        totalcount += [[NSString stringWithFormat:@"%d",model.count] integerValue];
                        totalmoney += [[NSString stringWithFormat:@"%.2f",[model.price floatValue]*model.count] floatValue];
                        type = [NSString stringWithFormat:@"%@",model.type];
                    }
                }
                if ([[Command convertNull:mustr] isEqualToString:@""]) {
                    jxt_showToastTitle(@"请选择商品", 1);
                    return ;
                }
                NSString* prostr = mustr;
                if (prostr.length!=0) {
                    NSRange range = {0,prostr.length - 1};
                    prostr = [prostr substringWithRange:range];
                }
                NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"table\":\"mall_pro_order\",\"totalmoney\":\"%@\",\"totalcount\":\"%@\",\"type\":\"%@\",\"proList\":[%@]}",[NSString stringWithFormat:@"%.2f",totalmoney],[NSString stringWithFormat:@"%li",(long)totalcount],type,prostr]};
                
                NSLog(@"%@",params);
                NSString *URLStr = @"/mbtwz/scshop?action=addMyOrder";
                [SVProgressHUD showWithStatus:@"正在结算..."];
                
                [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
                    [SVProgressHUD dismiss];
                    
                    NSString *str0 = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
                    NSLog(@"UUIL：%@",str0);
                    NSString *str1 = [str0 substringFromIndex:1];
                    
                    NSString *str2 = [str1 substringToIndex:str1.length-1];
                    if ([str2 rangeOfString:@"false"].location!=NSNotFound) {
                        jxt_showToastTitle(@"购买操作失败", 1);
                    }else{
                        ShopOrderViewController *shoporder = [[ShopOrderViewController alloc]init];
                        shoporder.uuid = str2;
                        shoporder.type = type;                        [self.navigationController pushViewController:shoporder animated:YES];
                    }
                    
                } fail:^(NSError *error) {
                    [SVProgressHUD dismiss];
                    
                }];

            }
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginViewController* vc = [[LoginViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }
    }];
    
}
@end
