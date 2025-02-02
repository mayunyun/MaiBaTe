//
//  WLQROrderViewController.m
//  MaiBaTe
//
//  Created by LONG on 2018/1/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WLQROrderViewController.h"
#import "WLPriceMXViewController.h"
#import "WLAddNeedViewController.h"
#import "WLTYProtocolViewController.h"
#import "AllWuliuOrderListVC.h"
#import "WLAddNeedModel.h"
#import "Paydetail.h"
#import "WuLiuFHViewController.h"

@interface WLQROrderViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    UITextField *_firstField;
    UITextField *_secondField;
    UITextField *_threeField;
    UITextView *_otherView;
    UILabel *_timeLab;
    UILabel *_youhuiNumer;
    NSString *_youhuiprice;
    NSMutableArray *_needArr;
    NSString *_PayUUid;
    UIButton *_xuqiuBut;
    UIView *bgview;
    
    // TextView的输入框
    UITextField * jkTextField;
    UITextView *jkTextView;
    // 输入框没有内容的提示语言
    UILabel *labeltextView;
    BOOL _wasKeyboardManagerEnabled;
    // 黑色的背景
    UIButton * backBtn;
    UIImageView *cardBackView;
    // 整个弹出框
    UIView *applyInputView;
}
@end

@implementation WLQROrderViewController

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
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    titleLab.text = @"确认订单";
    titleLab.textColor = UIColorFromRGB(0x333333);
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    
    _needArr = [[NSMutableArray alloc]init];
    
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChange1:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self setWithUIview];
    [self loadNewData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBaseAliPayTrue:) name:AliPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBaseWXPayTrue:) name:WXPayTrue object:nil];
    
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
- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXPayTrue object:nil];
}
- (void)loadNewData{
    //
    NSString *XWURLStr = @"/mbtwz/logisticssendwz?action=searchCarServices";
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [HTNetWorking postWithUrl:XWURLStr refreshCache:YES params:nil success:^(id response) {
        [SVProgressHUD dismiss];
        
        NSArray *Arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        
        NSLog(@">>%@",Arr);
        if (Arr.count) {
            //建立模型
            for (NSDictionary*dic in Arr ) {
                WLAddNeedModel *model=[[WLAddNeedModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                if ([[NSString stringWithFormat:@"%@",model.service_price] isEqualToString:@"0"]) {
                    model.need=@"1";
                    [_needArr addObject:model];
                }else{
                    model.need=@"0";
                }
            }
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
    
}
-(void)setWithUIview{
    UIView *bgview1 = [[UIView alloc]initWithFrame:CGRectMake(0, 64, UIScreenW, 200*MYWIDTH)];
    if (statusbarHeight>20) {
        bgview1.frame = CGRectMake(0, 88, UIScreenW, 200*MYWIDTH);
    }
    bgview1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview1];
    
    NSArray *imageArr = @[@"日期时间",@"WL姓名",@"WL电话",@"楼层"];
    NSArray *titleArr = @[@"用车时间",@"联系人",@"联系电话",@"楼层及门牌号"];
    for (int i=0; i<imageArr.count; i++) {
        UIImageView * carimage = [[UIImageView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 15*MYWIDTH + 50*MYWIDTH*i, 18*MYWIDTH, 20*MYWIDTH)];
        carimage.image = [UIImage imageNamed:imageArr[i]];
        [bgview1 addSubview:carimage];
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(carimage.right+10*MYWIDTH, carimage.top, 120*MYWIDTH, 20*MYWIDTH)];
        titleLab.text = titleArr[i];
        titleLab.textColor = UIColorFromRGB(0x222222);
        titleLab.font = [UIFont systemFontOfSize:14];
        [bgview1 addSubview:titleLab];
        if (i<imageArr.count-1) {
            UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 49*MYWIDTH + 50*MYWIDTH*i, bgview1.width-30*MYWIDTH, 1)];
            xian.backgroundColor = UIColorFromRGB(0xEEEEEE);
            [bgview1 addSubview:xian];
        }
    }
    //当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(120*MYWIDTH, 0, bgview1.width-155*MYWIDTH, 49*MYWIDTH)];
    _timeLab.text = dateTime;
    if (![[Command convertNull:self.time] isEqualToString:@""]) {
        _timeLab.text = self.time;
    }
    _timeLab.textAlignment = NSTextAlignmentRight;
    _timeLab.textColor = UIColorFromRGB(0x222222);
    _timeLab.font = [UIFont systemFontOfSize:14];
    [bgview1 addSubview:_timeLab];
    
    _firstField = [[UITextField alloc]initWithFrame:CGRectMake(_timeLab.left, 50*MYWIDTH, _timeLab.width, 50*MYWIDTH)];
    _firstField.delegate = self;
    _firstField.placeholder = @"必填";
    _firstField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _firstField.textAlignment = NSTextAlignmentRight;
    _firstField.textColor = UIColorFromRGB(0x333333);
    [bgview1 addSubview:_firstField];
    [Command placeholderColor:_firstField str:_firstField.placeholder color:UIColorFromRGB(0x888888)];
    
    _secondField = [[UITextField alloc]initWithFrame:CGRectMake(_timeLab.left, 100*MYWIDTH, _timeLab.width, 50*MYWIDTH)];
    _secondField.delegate = self;
    _secondField.placeholder = @"必填";
    _secondField.keyboardType = UIKeyboardTypeNumberPad;
    _secondField.textAlignment = NSTextAlignmentRight;
    _secondField.textColor = UIColorFromRGB(0x333333);
    _secondField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [bgview1 addSubview:_secondField];
    [Command placeholderColor:_secondField str:_secondField.placeholder color:UIColorFromRGB(0x888888)];
    
    _threeField = [[UITextField alloc]initWithFrame:CGRectMake(_timeLab.left, 150*MYWIDTH, _timeLab.width, 50*MYWIDTH)];
    _threeField.delegate = self;
    _threeField.placeholder = @"选填";
    _threeField.textAlignment = NSTextAlignmentRight;
    _threeField.textColor = UIColorFromRGB(0x333333);
    _threeField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [bgview1 addSubview:_threeField];
    [Command placeholderColor:_threeField str:_threeField.placeholder color:UIColorFromRGB(0x888888)];
    
    UIView *bgview2 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, bgview1.bottom+15*MYWIDTH, UIScreenW-30*MYWIDTH, 165*MYWIDTH)];
    bgview2.backgroundColor = [UIColor whiteColor];
    bgview2.layer.cornerRadius = 10;
    [self.view addSubview:bgview2];
    
    UILabel *titleLab1 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 0, 80*MYWIDTH, 45*MYWIDTH)];
    titleLab1.text = @"额外需求";
    titleLab1.textColor = UIColorFromRGB(0x333333);
    titleLab1.font = [UIFont systemFontOfSize:14];
    [bgview2 addSubview:titleLab1];
    
    _xuqiuBut = [[UIButton alloc]initWithFrame:CGRectMake(titleLab1.right, 0, bgview2.width-titleLab1.right-15*MYWIDTH, 45*MYWIDTH)];
    [_xuqiuBut setTitleColor:UIColorFromRGB(MYColor) forState:UIControlStateNormal];
    [_xuqiuBut setTitle:@"是否需要搬运、回单等服务 >" forState:UIControlStateNormal];
    _xuqiuBut.titleLabel.font = [UIFont systemFontOfSize:14];
    _xuqiuBut.titleLabel.textAlignment = NSTextAlignmentRight;
    [_xuqiuBut addTarget:self action:@selector(xuqiuButClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview2 addSubview:_xuqiuBut];
    
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, titleLab1.bottom, bgview2.width-30*MYWIDTH, 1)];
    xian1.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [bgview2 addSubview:xian1];
    
    UILabel *titleLab2 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian1.bottom, 80*MYWIDTH, 45*MYWIDTH)];
    titleLab2.text = @"订单备注";
    titleLab2.textColor = UIColorFromRGB(0x333333);
    titleLab2.font = [UIFont systemFontOfSize:14];
    [bgview2 addSubview:titleLab2];
    
    UILabel *titleLabOther = [[UILabel alloc]initWithFrame:CGRectMake(titleLab2.right, xian1.bottom, bgview2.width-titleLab2.right-15*MYWIDTH, 45*MYWIDTH)];
    titleLabOther.text = @"如货物类别及跟车人数";
    titleLabOther.textColor = UIColorFromRGB(0x888888);
    titleLabOther.font = [UIFont systemFontOfSize:14];
    titleLabOther.textAlignment = NSTextAlignmentRight;
    [bgview2 addSubview:titleLabOther];
    
    _otherView = [[UITextView alloc]initWithFrame:CGRectMake(15*MYWIDTH, titleLab2.bottom, bgview2.width-30*MYWIDTH, 60*MYWIDTH)];
    _otherView.backgroundColor = [UIColor whiteColor];
    _otherView.delegate = self;
    _otherView.font = [UIFont systemFontOfSize:13];
    _otherView.textColor = UIColorFromRGB(0x666666);
    _otherView.layer.cornerRadius = 3;
    _otherView.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;//设置边框颜色
    _otherView.layer.borderWidth = 1.0f;//设置边框颜色
    [bgview2 addSubview:_otherView];
    
    UILabel *titleLabOther0 = [[UILabel alloc]initWithFrame:CGRectMake(0, bgview2.bottom+20*MYWIDTH, UIScreenW, 20*MYWIDTH)];
    titleLabOther0.text = @"若产生高速费、停车费和搬运费，请用户额外支付";
    titleLabOther0.textColor = UIColorFromRGB(0x333333);
    titleLabOther0.font = [UIFont systemFontOfSize:12];
    titleLabOther0.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabOther0];
    
    UILabel *titleLabOther1 = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabOther0.bottom, UIScreenW, 30*MYWIDTH)];
    titleLabOther1.userInteractionEnabled = YES;
    titleLabOther1.text = @"        我已阅读并同意《货物托运服务协议》";
    titleLabOther1.textColor = UIColorFromRGB(0x333333);
    [self changeTextColor:titleLabOther1 Txt:titleLabOther1.text changeTxt:@"《货物托运服务协议》"];
    titleLabOther1.font = [UIFont systemFontOfSize:12];
    titleLabOther1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabOther1];
    
    UIButton *xZimageBut = [[UIButton alloc]initWithFrame:CGRectMake(55*MYWIDTH, titleLabOther0.bottom, 30*MYWIDTH, 30*MYWIDTH)];
    [xZimageBut setImage:[UIImage imageNamed:@"xuanzhong_1"] forState:UIControlStateNormal];
    [xZimageBut setImage:[UIImage imageNamed:@"xuanzhong_2"] forState:UIControlStateSelected];
    xZimageBut.tag = 12139;
    [xZimageBut addTarget:self action:@selector(xZimageButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xZimageBut];
    
    UIButton *Other1But = [[UIButton alloc]initWithFrame:CGRectMake(50*MYWIDTH, 0, titleLabOther1.width-50*MYWIDTH, 30*MYWIDTH)];
    [Other1But addTarget:self action:@selector(Other1ButButClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleLabOther1 addSubview:Other1But];
    
    UIButton *newBut = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bottom-55*MYWIDTH, UIScreenW, 55*MYWIDTH)];
    newBut.backgroundColor = UIColorFromRGB(MYColor);
    [newBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newBut setTitle:@"下一步" forState:UIControlStateNormal];
    newBut.titleLabel.font = [UIFont systemFontOfSize:20];
    [newBut addTarget:self action:@selector(newButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newBut];
    
    UIImageView *baiNar = [[UIImageView alloc]initWithFrame:CGRectMake(0, newBut.top-60*MYWIDTH, UIScreenW, 60*MYWIDTH)];
    baiNar.image = [UIImage imageNamed:@"白Bar"];
    baiNar.userInteractionEnabled = YES;
    [self.view addSubview:baiNar];
    
    _youhuiNumer = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 60*MYWIDTH)];
    _youhuiNumer.textColor = UIColorFromRGB(0x333333);
    _youhuiNumer.font = [UIFont systemFontOfSize:18];
    _youhuiNumer.text = [NSString stringWithFormat:@"优惠价 ￥%.2f",[self.zongPrice floatValue]];
    _youhuiNumer.textAlignment = NSTextAlignmentCenter;
    _youhuiprice = self.zongPrice;
    [self changeTextfont:_youhuiNumer Txt:_youhuiNumer.text changeTxt:@"优惠价 ￥"];
    [baiNar addSubview:_youhuiNumer];
    
    UIButton *mingxiBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW-90*MYWIDTH, 17.5*MYWIDTH, 80*MYWIDTH, 25*MYWIDTH)];
    mingxiBut.backgroundColor = [UIColor whiteColor];
    [mingxiBut setTitleColor:UIColorFromRGB(MYColor) forState:UIControlStateNormal];
    [mingxiBut setTitle:@"价格明细" forState:UIControlStateNormal];
    mingxiBut.titleLabel.font = [UIFont systemFontOfSize:12];
    [mingxiBut addTarget:self action:@selector(mingxiButClick) forControlEvents:UIControlEventTouchUpInside];
    mingxiBut.layer.cornerRadius = mingxiBut.height*0.5;
    mingxiBut.layer.borderColor = UIColorFromRGB(MYColor).CGColor;//设置边框颜色
    mingxiBut.layer.borderWidth = 1.0f;//设置边框颜色
    [baiNar addSubview:mingxiBut];
}
//改变某字符串
- (void)changeTextfont:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    //    NSString *str =  @"35";
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
        //[str1 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(MYOrange) range:NSMakeRange(location, length)];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(location, length)];
        
        //赋值
        label.attributedText = str1;
    }
}
-(void)xZimageButClick:(UIButton *)but{
    but.selected = !but.selected;
}
- (void)Other1ButButClick:(UIButton *)but{
    WLTYProtocolViewController *Protocol = [[WLTYProtocolViewController alloc]init];
    [self presentViewController:Protocol animated:YES completion:nil];
}
- (void)newButClick:(UIButton *)but{
    UIButton *But = [self.view viewWithTag:12139];
    if (But.selected) {
        jxt_showToastTitle(@"请同意货物托运服务协议", 1);
        return;
    }
    if ([[Command convertNull:_firstField.text] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写联系人", 1);
        return;
    }
    if ([[Command convertNull:_secondField.text] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写联系电话", 1);
        return;
    }
    if (![Command isMobileNumber:[Command convertNull:_secondField.text]]) {
        jxt_showToastTitle(@"请填写正确的联系电话", 1);
        return;
    }
    
    NSString *XWURLStr = @"/mbtwz/logisticssendwz?action=addSendCarOrder";
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:@"logistics_owner_order" forKey:@"table"];
    [param setValue:[NSString stringWithFormat:@"%@",_firstField.text] forKey:@"owner_link_name"];
    [param setValue:[NSString stringWithFormat:@"%@",_secondField.text] forKey:@"owner_link_phone"];
    [param setValue:[NSString stringWithFormat:@"%@",_threeField.text] forKey:@"door_number"];
    [param setValue:[NSString stringWithFormat:@"%@",_otherView.text] forKey:@"owner_note"];
    [param setValue:[NSString stringWithFormat:@"%@",_timeLab.text] forKey:@"owner_sendtime"];
    [param setValue:[NSString stringWithFormat:@"%@",_youhuiprice] forKey:@"owner_totalprice"];
    [param setValue:[NSString stringWithFormat:@"%@",self.model.car_id] forKey:@"owner_cartype_id"];
    [param setValue:[NSString stringWithFormat:@"%@",self.model.starting_price] forKey:@"owner_starting_price"];
    [param setValue:[NSString stringWithFormat:@"%@",self.model.mileage_price] forKey:@"owner_mileage_price"];
    [param setValue:[NSString stringWithFormat:@"%@",self.zongMileage] forKey:@"total_mileage"];
    [param setValue:[NSString stringWithFormat:@"%@",self.qiAddress] forKey:@"owner_address"];
    [param setValue:[NSString stringWithFormat:@"%@",self.zhongAddress] forKey:@"owner_send_address"];
    [param setValue:[NSString stringWithFormat:@"%f",self.Qlocation.longitude] forKey:@"longitude"];
    [param setValue:[NSString stringWithFormat:@"%f",self.Qlocation.latitude] forKey:@"latitude"];
    [param setValue:[NSString stringWithFormat:@"%f",self.Zlocation.longitude] forKey:@"send_longitude"];
    [param setValue:[NSString stringWithFormat:@"%f",self.Zlocation.latitude] forKey:@"send_latitude"];

    NSMutableArray *proList = [[NSMutableArray alloc]init];
    if (_needArr.count) {
        for (WLAddNeedModel *model in _needArr) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:@"logistics_owner_orderDetails" forKey:@"table"];
            [dict setValue:[NSString stringWithFormat:@"%@",model.id] forKey:@"owner_service_id"];
//            [_zongPrice floatValue]*[model.service_price floatValue]
            [dict setValue:[NSString stringWithFormat:@"%.2f",            [_zongPrice floatValue]*[model.service_price floatValue]
] forKey:@"owner_service_price"];
            [proList addObject:dict];
        }
    }
    [param setValue:proList forKey:@"proList"];
    
    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:param]};//

    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    [HTNetWorking postWithUrl:XWURLStr refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        
        NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];

        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            jxt_showAlertOneButton(@"提示", @"订单提交失败", @"确定", ^(NSInteger buttonIndex) {
            });
        }else{
            [self setSMAlertWithView];
            NSString *str1 = [str substringFromIndex:1];
            
            _PayUUid = [str1 substringToIndex:str1.length-1];
        }
        NSLog(@">>%@",str);
        
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
//支付方式弹框
- (void)setSMAlertWithView{
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];
    
    
    bgview = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 0, UIScreenW-60*MYWIDTH, 240*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    for (int i=0; i<2; i++) {
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 80*MYWIDTH+80*MYWIDTH*i, bgview.width-60*MYWIDTH, 1)];
        xian.backgroundColor = UIColorFromRGB(MYLine);
        [bgview addSubview:xian];
    }
    NSArray *imageArr = @[@"单选_选中",@"单选_未选中",@"单选_未选中"];
    for (int i=0; i<imageArr.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(45*MYWIDTH, 30*MYWIDTH+i*80*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
        imageview.image = [UIImage imageNamed:imageArr[i]];
        imageview.tag = 115+i;
        [bgview addSubview:imageview];
    }
    NSArray *imageArr1 = @[@"未标题-5.1",@"未标题-5.2",@"未标题-5.3"];
    for (int i=0; i<imageArr1.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.width/3, 25*MYWIDTH+i*80*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
        imageview.image = [UIImage imageNamed:imageArr1[i]];
        [bgview addSubview:imageview];
    }
    NSArray *titleArr = @[@"支付宝支付",@"微信支付",@"余额支付"];
    for (int i=0; i<titleArr.count; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(bgview.width/2-10, 25*MYWIDTH+i*80*MYWIDTH, 200, 30*MYWIDTH)];
        lab.text = titleArr[i];
        lab.font = [UIFont systemFontOfSize:15*MYWIDTH];
        lab.textColor = UIColorFromRGB(0x333333);
        [bgview addSubview:lab];
    }
    for (int i=0; i<3; i++) {
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, i*80*MYWIDTH, bgview.width, 80*MYWIDTH)];
        but.tag = 550+i;
        [but addTarget:self action:@selector(zhifuButClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:but];
    }
    [SMAlert showCustomView:bgview];
    [SMAlert hideCompletion:^{
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"uuid\":\"%@\"}",_PayUUid]};

        [HTNetWorking postWithUrl:@"/mbtwz/logisticssendwz?action=deleteShipperSendOrder" refreshCache:YES params:params success:^(id response) {
            NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"取消订单%@",str);
            

        } fail:^(NSError *error) {

        }];
    }];
}
- (void)zhifuButClicked:(UIButton *)button{
    UIImageView *image = [bgview viewWithTag:115];
    image.image = [UIImage imageNamed:@"单选_未选中"];
    UIImageView *image1 = [bgview viewWithTag:116];
    image1.image = [UIImage imageNamed:@"单选_未选中"];
    UIImageView *image2 = [bgview viewWithTag:117];
    image2.image = [UIImage imageNamed:@"单选_未选中"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    if (button.tag == 550) {//支付宝
        UIImageView *image = [bgview viewWithTag:115];
        image.image = [UIImage imageNamed:@"单选_选中"];
        jxt_showAlertTwoButton(@"提示", @"您确定使用支付宝支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            
            [Paydetail zhiFuBaoname:@"测试" titile:@"测试" price:_youhuiprice orderId:[NSString stringWithFormat:@"%@_%@",_PayUUid,[user objectForKey:USERID]] notice:@"2"];
            
            
        });
        
        
    }else if (button.tag == 551){//微信支付
        UIImageView *image = [bgview viewWithTag:116];
        image.image = [UIImage imageNamed:@"单选_选中"];
        jxt_showAlertTwoButton(@"提示", @"您确定使用微信支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            [Paydetail wxname:@"麦巴特充值" titile:@"麦巴特充值" price:_youhuiprice orderId:[NSString stringWithFormat:@"%@_%@",_PayUUid,[user objectForKey:USERID]] notice:@"2"];
        });
        
        
    }else if (button.tag == 552){//余额支付
        UIImageView *image = [bgview viewWithTag:117];
        image.image = [UIImage imageNamed:@"单选_选中"];
        jxt_showAlertTwoButton(@"提示", @"您确定使用余额支付吗", @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            //验证密码是否正确
            NSDictionary* password = @{@"data":[NSString stringWithFormat:@"{\"\":\"%@\"}",@""]};
            NSString *passwordURLStr = @"/mbtwz/logisticssendwz?action=checkZhiFuPassword";
            [HTNetWorking postWithUrl:passwordURLStr refreshCache:YES params:password success:^(id response) {
                [SVProgressHUD dismiss];
                NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
                if ([str rangeOfString:@"false"].location!=NSNotFound) {
                    jxt_showAlertOneButton(@"温馨提示", @"请到：个人中心-设置-安全中心-设置支付密码中进行设置", @"确定", ^(NSInteger buttonIndex) {
                        
                    });
                }else{
                    [self createUI];
                    [self pushApplyCase];
                }
            } fail:^(NSError *error) {
                [SVProgressHUD dismiss];
            }];

            
        });
    }
    
}
-(void)backClicked{
    NSLog(@"终于点击到我了");
}
#pragma mark UI的设置
-(void)createUI{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0,0, UIScreenW,UIScreenH);
    backBtn.backgroundColor = [UIColor cyanColor];
    [backBtn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    backBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    backBtn.alpha = 0.2;
    [window addSubview:backBtn];
    
    
    applyInputView = [[UIView alloc]initWithFrame:CGRectMake(25*MYWIDTH, (UIScreenH-175*MYWIDTH)/2, UIScreenW-50*MYWIDTH, 175*MYWIDTH)];
    applyInputView.alpha = 0;
    applyInputView.backgroundColor = [UIColor whiteColor];
    applyInputView.layer.cornerRadius = 10.f;
    applyInputView.clipsToBounds = NO;
    [window addSubview:applyInputView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20*MYWIDTH, 10*MYWIDTH, UIScreenW-40, 18*MYWIDTH)];
    title.text = @"余额支付";
    title.font = [UIFont systemFontOfSize:16.f*MYWIDTH];
    [applyInputView addSubview:title];
    
    UILabel *lines = [[UILabel alloc]initWithFrame:CGRectMake(0, title.bottom+10*MYWIDTH, applyInputView.width, 1)];
    lines.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [applyInputView addSubview:lines];
    UILabel * tfLabel = [[UILabel alloc]initWithFrame:CGRectMake(24*MYWIDTH, lines.bottom+15*MYWIDTH, applyInputView.width-48*MYWIDTH, 42*MYWIDTH)];
    tfLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tfLabel.userInteractionEnabled = YES;
    [applyInputView addSubview:tfLabel];
    jkTextField = [[UITextField alloc]initWithFrame:CGRectMake(10*MYWIDTH, 8*MYWIDTH, tfLabel.width-20*MYWIDTH,30*MYWIDTH)];
    jkTextField.delegate = self;
    [jkTextField setBorderStyle:UITextBorderStyleNone];
    jkTextField.textColor = TitleBlackCOLOR;
    jkTextField.placeholder = @"输入支付密码";
    jkTextField.secureTextEntry = YES;
    jkTextField.textAlignment = NSTextAlignmentRight;
    jkTextField.font = [UIFont systemFontOfSize:14.f*MYWIDTH];
    [tfLabel addSubview:jkTextField];

    CGFloat btnWidth = (applyInputView.width-60*MYWIDTH)/2;
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(20*MYWIDTH, tfLabel.bottom+25*MYWIDTH, btnWidth, 35*MYWIDTH)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16.f*MYWIDTH];
    [sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setBackgroundColor:UIColorFromRGB(0xFFB400)];
    sureButton.layer.cornerRadius = 6.f;
    sureButton.clipsToBounds = YES;
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyInputView addSubview:sureButton];
    
    UIButton *canleButton = [[UIButton alloc]initWithFrame:CGRectMake(sureButton.right+20*MYWIDTH, tfLabel.bottom+25*MYWIDTH, btnWidth, 35*MYWIDTH)];
    [canleButton setTitle:@"取消" forState:UIControlStateNormal];
    [canleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [canleButton setBackgroundColor:UIColorFromRGB(0xCDCDCD)];
    canleButton.titleLabel.font = [UIFont systemFontOfSize:16.f*MYWIDTH];
    canleButton.layer.cornerRadius = 6.f;
    canleButton.clipsToBounds = YES;
    [canleButton addTarget:self action:@selector(canle) forControlEvents:UIControlEventTouchUpInside];
    [applyInputView addSubview:canleButton];
}
#pragma mark 取消
-(void)canle{
    [applyInputView removeFromSuperview];
    [backBtn removeFromSuperview];
}

#pragma mark 确定
-(void)sure{
    [jkTextField resignFirstResponder];
    
    if ([jkTextField.text isEqualToString:@""]) {
        jxt_showToastTitle(@"密码不能为空", 1);
    }else{
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"owner_totalprice\":\"%@\",\"uuid\":\"%@\",\"paypassword\":\"%@\"}",_youhuiprice,_PayUUid,jkTextField.text]};
        
        NSLog(@"%@",params);
        [HTNetWorking postWithUrl:@"/mbtwz/logisticssendwz?action=shipperBalancePay" refreshCache:YES params:params success:^(id response) {
            NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"余额支付状态%@",str);
            if([str rangeOfString:@"true"].location!=NSNotFound) {
                [SMAlert hide:NO];
                [backBtn removeFromSuperview];
                [applyInputView removeFromSuperview];
                [self paySuccess];
            }else{
                NSString *str1 = [str substringFromIndex:1];
                
                NSString *str2 = [str1 substringToIndex:str1.length-1];
                jxt_showAlertOneButton(@"提示", str2, @"确定", ^(NSInteger buttonIndex) {
                });
            }
            
        } fail:^(NSError *error) {
            
        }];

    }
}

#pragma mark 弹出申请框
-(void)pushApplyCase{
    
    [UIView animateWithDuration:0.36f animations:^{
        
        backBtn.alpha = 0.48;
        applyInputView.alpha = 1;
        
    }completion:^(BOOL finished) {
        
    }];
}

- (void)getLoadDataBaseAliPayTrue:(NSNotification *)notice{
    NSLog(@"支付结果》》》》%@",notice.userInfo);
    /*
     {
     result = "{"alipay_trade_app_pay_response":{"code":"10000","msg":"Success","app_id":"2016020201135575","auth_app_id":"2016020201135575","charset":"utf-8","timestamp":"2017-09-11 12:07:04","total_amount":"0.01","trade_no":"2017091121001004730285476459","seller_id":"2088911120626880","out_trade_no":"a259a638a2494216bdad-62"},"sign":"avQ9kA4WQR8XqkDbFUPtNgNtSDV79dKGYo4xfxNClRdXolGr5zvDaRS+3zpECgGK9bQIP1/kkTb/T27S3F7JUxd65aMkMarWECIlu31KYqUBso1HQoIInEh+zU/UzWlQWDQgqlI7bXbAmiSnR5mpXWhiT4k0TrqXoa8UH3WZwLI=","sign_type":"RSA"}";
     resultStatus = "9000";
     memo = ""
     }
     
     {
     result = "";
     resultStatus = "6001";
     memo = "用户中途取消"
     }
     */
    if (notice.userInfo) {
        if ([[notice.userInfo objectForKey:@"resultStatus"] intValue] == 9000 ) {
            [SMAlert hide:NO];
            [self paySuccess];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:[notice.userInfo objectForKey:@"memo"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
}
- (void)getLoadDataBaseWXPayTrue:(NSNotification *)notice{
    [SMAlert hide:NO];
    [self paySuccess];
}
-(void)fahuodanButClicked:(UIButton *)but{
    [SMAlert hide:NO];
    //
    AllWuliuOrderListVC *wuliuOrder = [[AllWuliuOrderListVC alloc]init];
    wuliuOrder.isBack = @"2";
    wuliuOrder.type = @"1";
    [self.navigationController pushViewController:wuliuOrder animated:YES];
}
-(void)mingxiButClick{
    WLPriceMXViewController *price = [[WLPriceMXViewController alloc]init];
    price.city = self.city;
    price.dataArr = self.dataArr;
    price.zongMileage = self.zongMileage;
    price.model = self.model;
    price.zongPrice = _youhuiprice;
    [self.navigationController pushViewController:price animated:YES];
}
- (void)xuqiuButClick{
    WLAddNeedViewController *addneed = [[WLAddNeedViewController alloc]init];
    if (_needArr.count) {
        addneed.needArr = _needArr;
    }
    [addneed setNeedBlock:^(NSMutableArray *Arr) {
        _needArr = Arr;
        float zpice = 0;
        NSString *need = @"";
        for (WLAddNeedModel *model in Arr) {
            zpice = zpice +[_zongPrice floatValue]*[model.service_price floatValue];
            if ([need isEqualToString:@""]) {
                need = [NSString stringWithFormat:@"%@",model.service_name];
            }else{
                need = [NSString stringWithFormat:@"%@、%@",need,model.service_name];
            }
        }
        
        _youhuiNumer.text = [NSString stringWithFormat:@"优惠价 ￥%.2f",[_zongPrice floatValue]+zpice];
        [self changeTextfont:_youhuiNumer Txt:_youhuiNumer.text changeTxt:@"优惠价 ￥"];

        _youhuiprice = [NSString stringWithFormat:@"%.2f",[_zongPrice floatValue]+zpice];
        [_xuqiuBut setTitle:need forState:UIControlStateNormal];

    }];
    [self presentViewController:addneed animated:YES completion:nil];
}

- (void)paySuccess{
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];

    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(40*MYWIDTH, 0, UIScreenW-80*MYWIDTH, 200*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.width/2-52.5*MYWIDTH, 20*MYWIDTH, 105*MYWIDTH, 70*MYWIDTH)];
    imageview.image = [UIImage imageNamed:@"支付成功"];
    [bgview addSubview:imageview];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview.bottom+18*MYWIDTH, bgview.width, 30*MYWIDTH)];
    lab.text = @"支付成功";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = UIColorFromRGB(0x333333);
    [bgview addSubview:lab];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, lab.bottom+5*MYWIDTH, bgview.width, 30*MYWIDTH)];
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"点击查看物流发货单"];
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    //此时如果设置字体颜色要这样
    [tncString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(MYColor)  range:NSMakeRange(0,[tncString length])];
    
    //设置下划线颜色...
    [tncString addAttribute:NSUnderlineColorAttributeName value:UIColorFromRGB(MYColor) range:(NSRange){0,[tncString length]}];
    [but setAttributedTitle:tncString forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    [but addTarget:self action:@selector(fahuodanButClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:but];
    
    [SMAlert showCustomView:bgview];
    [SMAlert hideCompletion:^{
        for (UIViewController * controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[WuLiuFHViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
        NSDictionary * dict = @{@"hidden":@"1"};
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"hiddenWindow" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
//        [self.navigationController popToRootViewControllerAnimated:YES]
    }];
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
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
}
//以下两个代理方法可以防止键盘遮挡textview
-(void)textFieldDidBeginEditing:(UITextView *)textView{
    
    //这里的offset的大小是控制着呼出键盘的时候view上移多少。比如上移20，就给offset赋值-20，以此类推。也可以根据屏幕高度的不同做一个if判断。
    
    float offset = 0.0f;
    
    offset = -40;
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;
    
    CGRect rect = CGRectMake(0.0f, offset , width, height);
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
}
//完成编辑的时候下移回来（只要把offset重新设为0就行了）

-(void)textFieldDidEndEditing:(UITextView *)textView{
    
    float offset = 0.0f;
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;
    
    CGRect rect = CGRectMake(0.0f, offset , width, height);
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}
//#pragma mark 监听键盘
////实现接收到通知时的操作
//-(void)keyBoardChange1:(NSNotification *)note
//{
//    //获取键盘弹出或收回时frame
//    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    long   newheight = UIScreenH - keyboardFrame.size.height;
//
//    //获取键盘弹出所需时长
//    float duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//
//    NSLog(@"键盘的弹出的时间=%lf",duration);
//
//    [self setupent:keyboardFrame With:newheight];
//
//}
//
//-(void)setupent:(CGRect)keyboardFrame With:(long)newheight{
//
//    NSLog(@"键盘的高度=%f 键盘的y值=%f 整个的高度=%f",keyboardFrame.size.height,keyboardFrame.origin.y,UIScreenH);
//
//    if (keyboardFrame.origin.y == UIScreenH) {
//
//        [UIView animateWithDuration:0.1 animations:^{
//
//            applyInputView.y = (UIScreenH-applyInputView.height)/2.0;
//        }];
//
//    }else{
//
//        //添加弹出动画
//        [UIView animateWithDuration:0.1 animations:^{
//
//            applyInputView.y = newheight-applyInputView.height-32;
//
//        }completion:^(BOOL finished) {
//
//        }];
//    }
//
//}


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
