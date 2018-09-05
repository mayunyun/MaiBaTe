//
//  chargeTypeViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/8/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "chargeTypeViewController.h"
#import "ChongZhiViewController.h"
#import "MBTTabBarController.h"
#import "CarChargeViewController.h"
@interface chargeTypeViewController ()<UITextFieldDelegate>
{
    UILabel* _moneyLabel;
    NSString * _numerStr;//充电数量、金额、时间
    UITextField *_textField;
    NSString *_YuENumer;
    long _integerType;
    UITextField *textField1;
}
@property(nonatomic,weak) UIButton *selectedBtn;

@property(nonatomic,strong) NSMutableArray *btns;

@end

@implementation chargeTypeViewController
- (NSMutableArray *)btns
{
    if(_btns==nil)
    {
        _btns =[NSMutableArray array];
    }
    return _btns;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"NarBg"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [self dataYeE];

}
//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [IQKeyboardManager sharedManager].enable = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"电桩申请Nar.png"]];
    titleImage.frame = CGRectMake(5, 3, 17, 19);
    [titleView addSubview:titleImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 75, 25)];
    titleLab.text = @"充电方式";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    [self creatUI];
}

- (void)creatUI{
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(30, 70+64, UIScreenW - 60, 0.8*(UIScreenW - 60))];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    NSArray* titleArr = @[@"按时间充",@"按电量充",@"按金额充",@"充满"];
    NSArray* imgArr = @[@"chargetime",@"chargecharge",@"chargemoney",@"chargetotal"];
    for (int i = 0; i < 2; i ++) {//列
        for (int j = 0; j < 2; j ++) {//行
            UIImageView* imgView = [[UIImageView alloc]init];
            CGFloat w = 0.5*bgView.width;
            CGFloat h = 0.5*bgView.height;
            imgView.frame = CGRectMake(j*w+(w-35)*0.5, i*h+(h-35-40)*0.5, 35, 35);
            imgView.tag = 100+i*2+j;
//            imgView.backgroundColor = [UIColor redColor];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.image = [UIImage imageNamed:imgArr[i*2+j]];
            imgView.userInteractionEnabled = YES;
            [bgView addSubview:imgView];
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTapClick:)];
            [imgView addGestureRecognizer:tap];
            
            UIButton *titleBut = [[UIButton alloc]init];
            titleBut.frame = CGRectMake(j*w+(w-50)*0.5, i*h+(h-40-40)*0.5+60, 50, 20);
            [titleBut setTitle:titleArr[i*2+j] forState:UIControlStateNormal];
            [titleBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            titleBut.titleLabel.font = [UIFont systemFontOfSize:12];
            titleBut.tag = 100+i*2+j;
            [titleBut addTarget:self action:@selector(titleButClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:titleBut];
        }

    }
    UIView* vline = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5*bgView.height -0.375, bgView.width, 0.75)];
    vline.backgroundColor = COLOR(215, 215, 215, 1);
    [bgView addSubview:vline];
    UIView* hline = [[UIView alloc]initWithFrame:CGRectMake(0.5*bgView.width - 0.375, 0, 0.75, bgView.height)];
    hline.backgroundColor = COLOR(215, 215, 215, 1);
    [bgView addSubview:hline];
    
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, UIScreenH - 140, UIScreenW, 20)];
    _moneyLabel.text = @"当前账户金额0.00元  立即充值>";
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    _moneyLabel.font = [UIFont systemFontOfSize:16];
    _moneyLabel.textColor = UIColorFromRGB(0x333333);
    [self changeTextColor:_moneyLabel Txt:_moneyLabel.text changeTxt:@"立即充值>"];
    [self.view addSubview:_moneyLabel];
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreeTapGesture:)];
    _moneyLabel.userInteractionEnabled = YES;
    [_moneyLabel addGestureRecognizer:aTap];
    

}
//改变某字符串的颜色
- (void)changeTextColor:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
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
        [str1 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(MYOrange) range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
}


- (void)titleButClick:(UIButton *)but{
    [self titleImgViewTapClick:but.tag];
}
- (void)imgViewTapClick:(UITapGestureRecognizer*)tap{
    [self titleImgViewTapClick:tap.view.tag];
}
- (void)titleImgViewTapClick:(long)integer{
    NSLog(@"点击的，，，，%ld",integer);
    _integerType = integer;
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];
    [SMAlert setTouchToHide:NO];
    
    //充电密码
    CGFloat width = 300*MYWIDTH;
    UIView *customView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 210*MYWIDTH)];
    customView1.backgroundColor = [UIColor whiteColor];
    //customView1.layer.cornerRadius = 15;
    
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 45*MYWIDTH)];
    [title1 setFont:[UIFont systemFontOfSize:15]];
    [title1 setTextColor:[UIColor whiteColor]];
    title1.textAlignment = NSTextAlignmentCenter;
    title1.backgroundColor = UIColorFromRGB(MYColor);
    title1.text = @"请输入充电密码";
    [customView1 addSubview:title1];
    
    textField1 = [[UITextField alloc]initWithFrame:CGRectMake(10*MYWIDTH, title1.bottom, width-20*MYWIDTH, 50*MYWIDTH)];
//    textField1.layer.cornerRadius = 3;
//    textField1.layer.borderWidth = 0.5;
//    textField1.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
//    textField1.backgroundColor = UIColorFromRGB(0xF4F4F4);
    textField1.backgroundColor = [UIColor whiteColor];
    textField1.placeholder = @"请在此输入你的充电密码,才可以充电奥！";
//    textField1.textAlignment = NSTextAlignmentCenter;
    textField1.secureTextEntry = YES;
    textField1.font = [UIFont systemFontOfSize:14];
    [textField1 setReturnKeyType:UIReturnKeyDone];
    textField1.delegate = self;
    [customView1 addSubview:textField1];
    
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(0, textField1.bottom, width, 1)];
    xian1.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [customView1 addSubview:xian1];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(35*MYWIDTH, xian1.bottom+15*MYWIDTH, width-70*MYWIDTH, 40*MYWIDTH)];
    [but setBackgroundColor:UIColorFromRGB(MYColor)];
    but.layer.cornerRadius = 20*MYWIDTH;
    [but setTitle:@"确定" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(quedingClick) forControlEvents:UIControlEventTouchUpInside];
    [customView1 addSubview:but];
    
    UIButton *counbut = [[UIButton alloc]initWithFrame:CGRectMake(35*MYWIDTH, but.bottom+10*MYWIDTH, width-70*MYWIDTH, 40*MYWIDTH)];
    [counbut setBackgroundColor:[UIColor whiteColor]];
    counbut.layer.cornerRadius = 20*MYWIDTH;
    counbut.layer.borderWidth = 1;
    counbut.layer.borderColor = UIColorFromRGB(0xEEEEEE).CGColor;
    [counbut setTitle:@"取消" forState:UIControlStateNormal];
    [counbut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [counbut addTarget:self action:@selector(counbutClick) forControlEvents:UIControlEventTouchUpInside];
    [customView1 addSubview:counbut];
    
     [SMAlert showCustomView:customView1];
    
}
- (void)quedingClick{
    [SMAlert hide:NO];
    if ([textField1.text isEqualToString:@""]) {
        jxt_showAlertOneButton(@"温馨提示", @"请到我的-设置-安全中心中进行设置", @"确定", ^(NSInteger buttonIndex) {
            
        });
        return ;
    }
    [SVProgressHUD showWithStatus:@"正在加载..."];
    //验证密码是否正确
    NSDictionary* password = @{@"params":[NSString stringWithFormat:@"{\"chongdianpassword\":\"%@\"}",textField1.text]};
    NSString *passwordURLStr = @"/mbtwz/wxorder?action=validateChongdianmima";
    [HTNetWorking postWithUrl:passwordURLStr refreshCache:YES params:password success:^(id response) {
        [SVProgressHUD dismiss];
        NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            //充电方式
            [self chongdianFangShi:_integerType];
        }else{
            jxt_showAlertOneButton(@"温馨提示", @"密码不匹配，请重新确认\n或\n您请到我的-设置-安全中心中进行设置", @"确定", ^(NSInteger buttonIndex) {
                
            });
        }
        
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
- (void)counbutClick{
    [SMAlert hide:NO];
}
//充电方式
- (void)chongdianFangShi:(long)integer{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (integer == 103) {
        
        NSLog(@"?>>>%@",[user objectForKey:ChongDianNumer]);
        //充满
        if ([_YuENumer floatValue] < 0.01) {
            jxt_showAlertTwoButton(@"余额不足",@"请立即充值", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"确定", ^(NSInteger buttonIndex) {
                ChongZhiViewController *chongzhi = [[ChongZhiViewController alloc]init];
                [self.navigationController pushViewController:chongzhi animated:YES];
                
            });
        }else{
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"electricsbm\":\"%@\",\"custid\":\"%@\",\"dianfeitype\":\"%@\",\"yujijine\":\"%@\"}",[user objectForKey:ChongDianNumer],[user objectForKey:USERID],@"0",@"0"]};
            NSLog(@">>>%@",params);
            
            [self chongdianparams:params];
        }
        
        
    }else{
        
        
        CGFloat width = 300*MYWIDTH;
        UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 380*MYWIDTH)];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 50*MYWIDTH)];
        [title setFont:[UIFont systemFontOfSize:15]];
        [title setTextColor:[UIColor whiteColor]];
        title.textAlignment = NSTextAlignmentCenter;
        if (integer == 100) {
            title.text = @"请根据车辆类型选择充电时间";
        }else if (integer == 101){
            title.text = @"请根据车辆类型选择充电电量";
        }else if (integer == 102){
            title.text = @"请根据车辆类型选择充电金额";
        }

        [customView addSubview:title];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(width/2-43*MYWIDTH, title.bottom+10*MYWIDTH, 100*MYWIDTH, 55*MYWIDTH)];
        [customView addSubview:image];
        
        UILabel *titleStr = [[UILabel alloc]initWithFrame:CGRectMake(0, image.bottom+5*MYWIDTH, width, 25*MYWIDTH)];
        [titleStr setFont:[UIFont systemFontOfSize:14]];
        titleStr.textAlignment = NSTextAlignmentCenter;
        [titleStr setTextColor:[UIColor blackColor]];
        [customView addSubview:titleStr];
        
        NSArray *butArr0; NSArray *butArr1; NSArray *butArr2;
        if ([[user objectForKey:ChongDianNumer] rangeOfString:@"sbm"].location!=NSNotFound) {
            title.backgroundColor = UIColorFromRGB(MYColor);
            image.image = [UIImage imageNamed:@"电瓶车_1"];
            titleStr.text = @"电瓶车";
            butArr0 = @[@"0.5小时",@"1小时",@"1.5小时"];
            butArr1 = @[@"1度",@"3度",@"5度"];
            butArr2 = @[@"2元",@"3元",@"5元"];
            image.frame = CGRectMake(width/2-43*MYWIDTH, title.bottom+10*MYWIDTH, 100*MYWIDTH, 55*MYWIDTH);
        }else{
            title.backgroundColor = UIColorFromRGB(0x6db207);
            image.image = [UIImage imageNamed:@"电动车_1"];
            titleStr.text = @"电动车";
            butArr0 = @[@"1小时",@"2小时",@"4小时"];
            butArr1 = @[@"8度",@"18度",@"28度"];
            butArr2 = @[@"10元",@"20元",@"30元",];
            image.frame = CGRectMake(width/2-45*MYWIDTH, title.bottom+15*MYWIDTH, 110*MYWIDTH, 50*MYWIDTH);

        }
        NSArray *butarr = @[butArr0,butArr1,butArr2];
        for (int i=0; i<3; i++) {
            int x = 3;//行
            //int y = 1;//列
            CGFloat w = (width-60*MYWIDTH)/x;//宽
            CGFloat h = 38*MYWIDTH;//高
            UIButton *numerbtn = [[UIButton alloc]init];
            [numerbtn setFrame:CGRectMake(20*MYWIDTH + (10*MYWIDTH+w)*i,titleStr.bottom+20*MYWIDTH, w, h)];
            numerbtn.layer.masksToBounds = YES;
            numerbtn.layer.cornerRadius = 3;
            if ([[user objectForKey:ChongDianNumer] rangeOfString:@"sbm"].location!=NSNotFound) {
                [numerbtn setBackgroundImage:[UIImage imageNamed:@"黄色框"] forState:UIControlStateNormal];
                [numerbtn setBackgroundImage:[UIImage imageNamed:@"黄色"] forState:UIControlStateSelected];
            }else{
                [numerbtn setBackgroundImage:[UIImage imageNamed:@"绿色框"] forState:UIControlStateNormal];
                [numerbtn setBackgroundImage:[UIImage imageNamed:@"绿色"] forState:UIControlStateSelected];
            }
            [numerbtn setTitle:butarr[integer-100][i] forState:UIControlStateNormal];
            numerbtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [numerbtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [numerbtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateSelected];
            [numerbtn addTarget:self action:@selector(numerbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [customView addSubview:numerbtn];
            
            [self.btns addObject:numerbtn];
            
            if (i==0) {
                _numerStr = numerbtn.titleLabel.text;
                
                self.selectedBtn.selected = NO;
                numerbtn.selected = YES;
                self.selectedBtn = numerbtn;
            }
        }
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(20*MYWIDTH, 220*MYWIDTH, width-40*MYWIDTH, 38*MYWIDTH)];
        _textField.layer.cornerRadius = 3;
        _textField.layer.borderWidth = 0.5;
        _textField.delegate = self;
        _textField.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
        _textField.backgroundColor = UIColorFromRGB(0xF4F4F4);
        if (integer == 100) {
            _textField.placeholder = @" 也可自行输入充电时间";
        }else if (integer == 101){
            _textField.placeholder = @" 也可自行输入充电电量";
        }else if (integer == 102){
            _textField.placeholder = @" 也可自行输入充电金额";
        }
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.font = [UIFont systemFontOfSize:13];
        [_textField setReturnKeyType:UIReturnKeyDone];
        _textField.delegate = self;
        [customView addSubview:_textField];
        
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(35*MYWIDTH, _textField.bottom+15*MYWIDTH, width-70*MYWIDTH, 40*MYWIDTH)];
        [but setBackgroundColor:UIColorFromRGB(MYColor)];
        but.layer.cornerRadius = 20*MYWIDTH;
        [but setTitle:@"立即充电" forState:UIControlStateNormal];
        [but addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:but];
        
        if ([[user objectForKey:ChongDianNumer] rangeOfString:@"sbm"].location!=NSNotFound) {
            [but setBackgroundColor:UIColorFromRGB(MYColor)];
        }else{
            [but setBackgroundColor:UIColorFromRGB(0x6db207)];
        }
        
        UIButton *counbut = [[UIButton alloc]initWithFrame:CGRectMake(35*MYWIDTH, but.bottom+10*MYWIDTH, width-70*MYWIDTH, 40*MYWIDTH)];
        [counbut setBackgroundColor:[UIColor whiteColor]];
        counbut.layer.cornerRadius = 20*MYWIDTH;
        counbut.layer.borderWidth = 1;
        counbut.layer.borderColor = UIColorFromRGB(0xEEEEEE).CGColor;
        [counbut setTitle:@"下次再说" forState:UIControlStateNormal];
        [counbut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [counbut addTarget:self action:@selector(counbutClick) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:counbut];
        
        [SMAlert showCustomView:customView];
    
    }
}
- (void)confirmButtonClick{
    [_textField resignFirstResponder];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (_textField.text.length>0) {
        _numerStr = _textField.text;
    }
    //[SMAlert hide:NO];
    if (_numerStr.length<1) {
        _numerStr = @"0";
        jxt_showToastTitle(@"请输入数值", 1);
        return ;
    }
    NSRegularExpression*tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:_numerStr options:NSMatchingReportProgress range:NSMakeRange(0, _numerStr.length)];
    if (tNumMatchCount<1) {
        _numerStr = @"0";
        jxt_showToastTitle(@"请输入数值", 1);
        return ;
    }
    
    
    NSScanner *scanner = [NSScanner scannerWithString:_numerStr];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    
    float number;
    [scanner scanFloat:&number];
    NSString *num=[NSString stringWithFormat:@"%.2f",number];
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>%@",num);
    if (_integerType != 100) {
        if ([num intValue]!=number) {
            jxt_showToastTitle(@"输入数值必须为正整数", 1);
            return ;
        }
    }
    //充电金额充电
    if (_integerType == 102) {
        if ([num intValue]==0) {
            jxt_showToastTitle(@"请选择要充值的金额", 1);
            return ;
        }
        if (number>[_YuENumer floatValue]) {
            jxt_showAlertTwoButton(@"余额不足", [NSString stringWithFormat:@"差%.2f元,请立即充值",number-[_YuENumer floatValue]], @"取消", ^(NSInteger buttonIndex) {
                
            }, @"确定", ^(NSInteger buttonIndex) {
                ChongZhiViewController *chongzhi = [[ChongZhiViewController alloc]init];
                [self.navigationController pushViewController:chongzhi animated:YES];
                
            });
        }else{
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"electricsbm\":\"%@\",\"custid\":\"%@\",\"dianfeitype\":\"%@\",\"yujijine\":\"%d\"}",[user objectForKey:ChongDianNumer],[user objectForKey:USERID],@"2",[num intValue]]};
            NSLog(@">>>%@",params);
            
            [self chongdianparams:params];
        }
        
        
    }
    //按指定电量充电
    else if (_integerType == 101){
        if ([num intValue]==0) {
            jxt_showToastTitle(@"请选择要充值的电量", 1);
            return ;
        }
        NSDictionary* password = @{@"data":[NSString stringWithFormat:@"{\"electricsbm\":\"%@\",\"dushu\":\"%@\"}",[user objectForKey:ChongDianNumer],num]};
        NSString *passwordURLStr = @"/mbtwz/wxorder?action=dushutojine";
        [SVProgressHUD showWithStatus:@"正在加载..."];
        [HTNetWorking postWithUrl:passwordURLStr refreshCache:YES params:password success:^(id response) {
            [SVProgressHUD dismiss];
            NSString* str0 = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
            NSLog(@"%@",str0);
            
            
            if ([str0 floatValue]>[_YuENumer floatValue]) {
                jxt_showAlertTwoButton(@"余额不足", [NSString stringWithFormat:@"差%.2f元,请立即充值",[str0 floatValue]-[_YuENumer floatValue]], @"取消", ^(NSInteger buttonIndex) {
                    
                }, @"确定", ^(NSInteger buttonIndex) {
                    ChongZhiViewController *chongzhi = [[ChongZhiViewController alloc]init];
                    [self.navigationController pushViewController:chongzhi animated:YES];
                    
                });
            }else{
                NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"electricsbm\":\"%@\",\"custid\":\"%@\",\"dianfeitype\":\"%@\",\"yujidushu\":\"%d\"}",[user objectForKey:ChongDianNumer],[user objectForKey:USERID],@"1",[num intValue]]};
                NSLog(@">>>%@",params);
                
                [self chongdianparams:params];
            }
            
        } fail:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
    //按指定时间充电
    else if (_integerType == 100){
        NSLog(@">>>>%@",num);
        if ([num floatValue]*60==0) {
            jxt_showToastTitle(@"请选择要充值的时间", 1);
            return ;
        }
        if ([_YuENumer floatValue] < 0.01) {
            jxt_showAlertTwoButton(@"余额不足",@"请立即充值", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"确定", ^(NSInteger buttonIndex) {
                ChongZhiViewController *chongzhi = [[ChongZhiViewController alloc]init];
                [self.navigationController pushViewController:chongzhi animated:YES];
                
            });
        }else{
            NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"electricsbm\":\"%@\",\"custid\":\"%@\",\"dianfeitype\":\"%@\",\"yujishijian\":\"%@\"}",[user objectForKey:ChongDianNumer],[user objectForKey:USERID],@"3",[NSString stringWithFormat:@"%d",(int)(number*60)]]};
            NSLog(@">>>%@",params);
            
            [self chongdianparams:params];
        }
        
    }
}
- (void)chongdianparams:(NSDictionary *)params{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *URLStr = @"/mbtwz/wxorder?action=addChongDianOrder";
    [SVProgressHUD showWithStatus:@"正在加载..."];

    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
        [SVProgressHUD dismiss];

        NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
        NSLog(@"充电请求>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [SMAlert hide:NO];
            CarChargeViewController *carcharge = [[CarChargeViewController alloc]init];
            [self presentViewController:carcharge animated:YES completion:nil];
        }else{
            NSDictionary* password = @{@"params":[NSString stringWithFormat:@"{\"electricsbm\":\"%@\"}",[user objectForKey:ChongDianNumer]]};
            NSString *passwordURLStr = @"/mbtwz/wxorder?action=getManagePhone";
            [SVProgressHUD showWithStatus:@"正在加载..."];
            [HTNetWorking postWithUrl:passwordURLStr refreshCache:YES params:password success:^(id response) {
                [SVProgressHUD dismiss];
                NSString* str0 = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
                NSLog(@"充电失败%@",str0);
                NSString *str1 = [str0 substringFromIndex:1];
                
                NSString *str2 = [str1 substringToIndex:str1.length-1];
                NSLog(@"%@",str2);
                jxt_showAlertTwoButton(@"充电失败", [NSString stringWithFormat:@"请联系电桩管理员：%@",str2], @"取消", ^(NSInteger buttonIndex) {
                    
                }, @"确定", ^(NSInteger buttonIndex) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",str2]]];
                    
                });
                
                
                
            } fail:^(NSError *error) {
                [SVProgressHUD dismiss];
            }];
        }
        
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}

- (void)agreeTapGesture:(UITapGestureRecognizer*)tap
{
    ChongZhiViewController *chongzhi = [[ChongZhiViewController alloc]init];
    [self.navigationController pushViewController:chongzhi animated:YES];
}
- (void)numerbtnClicked:(UIButton *)but{
    
    _textField.text = nil;
    _numerStr = but.titleLabel.text;

    self.selectedBtn.selected = NO;
    but.selected = YES;
    self.selectedBtn = but;

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    kKeyWindow.frame = CGRectMake(0, 0, UIScreenW, UIScreenH);
    [textField resignFirstResponder];
    
    NSLog(@"已经停止编辑");
    if (_textField.text.length>0) {
        self.selectedBtn.selected = NO;
        
    }
    

}
//判断是否为整形：

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    kKeyWindow.frame = CGRectMake(0, -UIScreenH/4, UIScreenW, UIScreenH);
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _textField) {
        self.selectedBtn.selected = NO;
    }
    return YES;
}
- (void)backToLastViewController:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
    kKeyWindow.rootViewController = nil;
    kKeyWindow.rootViewController =[[MBTTabBarController alloc]init];
    [kKeyWindow makeKeyAndVisible];
    
    
}

- (void)dataYeE{
    //加载余额
    NSString *URLStr = @"/mbtwz/cdxt?action=loadCustomerBalance";
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:nil success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
        NSString *str1 = [str substringFromIndex:1];
        
        NSString *str2 = [str1 substringToIndex:str1.length-1];
        NSLog(@"余额>>>>%@",str2);
        _YuENumer = str2;
        _moneyLabel.text = [NSString stringWithFormat:@"当前账户金额%.2f元  立即充值>",[str2 floatValue]];

    } fail:^(NSError *error) {
        
    }];

}



@end
