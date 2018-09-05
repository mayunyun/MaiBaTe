//
//  NewMyCarViewController.m
//  MaiBaTe
//
//  Created by LONG on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewMyCarViewController.h"
#import "AddMyCarViewController.h"
@interface NewMyCarViewController ()
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation NewMyCarViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"NarBg"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self scrollView];
    for(UIView *subv in [_scrollView subviews])
    {
        [subv removeFromSuperview];
    }
    [self loadNew];
    
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的车辆Nar.png"]];
    titleImage.frame = CGRectMake(5, 3, 17, 19);
    [titleView addSubview:titleImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 75, 25)];
    titleLab.text = @"我的车辆";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    self.navigationItem.titleView = titleView;

}
#pragma 在这里面请求数据
- (void)loadNew
{
    
    [_dataArr removeAllObjects];
    NSString *URLStr = @"/mbtwz/elecar?action=getMyCarSelf";
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:nil success:^(id response) {
        
        _dataArr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        //NSMutableArray *mutableArr = [[NSMutableArray alloc]initWithArray:arr];
        NSSLog(@"xilie%@",_dataArr);
        if (_dataArr.count) {
            _dataArr=(NSMutableArray *)[[_dataArr reverseObjectEnumerator] allObjects];
            
            self.scrollView.contentSize = CGSizeMake(_dataArr.count * UIScreenW, 0);

            for (int i = 0; i<_dataArr.count; i++) {
                [self addViewDataint:i];
            }
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
        
    } fail:^(NSError *error) {
        
    }];
}

- (UIScrollView *)scrollView
{
    if(_scrollView==nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, UIScreenW, UIScreenH - 64 - 50*MYWIDTH)];
        if (statusbarHeight>20) {
            _scrollView.frame = CGRectMake(0, 88, UIScreenW, UIScreenH - 88 - 50*MYWIDTH);
        }
        _scrollView.delegate=self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(UIScreenW, 0);
        _scrollView.bounces = NO;
        [self.view addSubview:_scrollView];
        
        UIButton *addCarBut =[[UIButton alloc]initWithFrame:CGRectMake(0, _scrollView.bottom, UIScreenW, 50*MYWIDTH)];
        [addCarBut setTitle:@"添加车辆" forState:UIControlStateNormal];
        [addCarBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addCarBut.backgroundColor = UIColorFromRGB(0xFF7E00);
        addCarBut.titleLabel.font = [UIFont systemFontOfSize:16];
        [addCarBut addTarget:self action:@selector(addCarButClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: addCarBut];
    }
    return _scrollView;
}

- (void)addCarButClick{
    [Command isloginRequest:^(bool str) {
        if (str) {
            AddMyCarViewController *addCar = [[AddMyCarViewController alloc]init];
            [self.navigationController pushViewController:addCar animated:YES];
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginViewController* vc = [[LoginViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }
    }];
    
}
- (void)addViewDataint:(NSUInteger)intger{
    CGFloat margin = 10*MYWIDTH;
    NSDictionary *dataDic = _dataArr[intger];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(10*MYWIDTH +UIScreenW*intger, 15*MYWIDTH, UIScreenW-20*MYWIDTH, _scrollView.height-30*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.layer.cornerRadius = 10;
    [_scrollView addSubview:bgview];
    
    UIImageView *iconView =[[UIImageView alloc]initWithFrame:CGRectMake(margin, margin, 20*MYWIDTH, 20*MYWIDTH)];
    iconView.image = [UIImage imageNamed:@"汽车"];
    [bgview addSubview:iconView];
    
    UIButton *deleteBut =[[UIButton alloc]initWithFrame:CGRectMake(bgview.width-60*MYWIDTH, 0, 60*MYWIDTH, 40*MYWIDTH)];
    [deleteBut setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBut setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    deleteBut.titleLabel.font = [UIFont systemFontOfSize:13];
    deleteBut.tag = intger;
    [deleteBut addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview: deleteBut];
    
    UILabel *titleView =[[UILabel alloc]initWithFrame:CGRectMake(iconView.right+15*MYWIDTH, margin, deleteBut.left-iconView.right-20, 20*MYWIDTH)];
    titleView.font = [UIFont systemFontOfSize:13];
    titleView.textColor = UIColorFromRGB(0x333333);
    titleView.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"chepaihao"]];
    [bgview addSubview: titleView];
    
    UIView *xianview =[[UIView alloc]initWithFrame:CGRectMake(0, titleView.bottom+margin, bgview.width, 1)];
    xianview.backgroundColor = UIColorFromRGB(MYColor);
    [bgview addSubview:xianview];
    
    UIImageView *carImageView = [[UIImageView alloc]initWithFrame:CGRectMake(bgview.width/2-60*MYWIDTH, bgview.height/2-118*MYWIDTH, 120*MYWIDTH, 236*MYWIDTH)];
    carImageView.image = [UIImage imageNamed:@"汽车俯视图"];
    [bgview addSubview:carImageView];
    
    UIImageView *greenView = [[UIImageView alloc]initWithFrame:CGRectMake(10*MYWIDTH, carImageView.top+10*MYWIDTH, carImageView.left-10*MYWIDTH, 10*MYWIDTH)];
    greenView.image = [UIImage imageNamed:@"绿"];
    [bgview addSubview:greenView];
    
    UIImageView *yellowView = [[UIImageView alloc]initWithFrame:CGRectMake(carImageView.right, carImageView.top+10*MYWIDTH, greenView.width, 10*MYWIDTH)];
    yellowView.image = [UIImage imageNamed:@"黄"];
    [bgview addSubview:yellowView];
    
    UIImageView *blueView = [[UIImageView alloc]initWithFrame:CGRectMake(10*MYWIDTH, carImageView.bottom-60*MYWIDTH, greenView.width, 10*MYWIDTH)];
    blueView.image = [UIImage imageNamed:@"蓝"];
    [bgview addSubview:blueView];
    
    UIImageView *redView = [[UIImageView alloc]initWithFrame:CGRectMake(carImageView.right, carImageView.bottom-60*MYWIDTH, greenView.width, 10*MYWIDTH)];
    redView.image = [UIImage imageNamed:@"红"];
    [bgview addSubview:redView];
    
    //转速
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(5*MYWIDTH, greenView.top-35*MYWIDTH, 13*MYWIDTH, 13*MYWIDTH)];
    image1.image = [UIImage imageNamed:@"1电机转速"];
    [bgview addSubview:image1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(image1.right+2*MYWIDTH, image1.top-6*MYWIDTH, greenView.width, 40*MYWIDTH)];
    if ([[dataDic objectForKey:@"dianjizhuansu"] intValue]==65535) {
        label1.text = [NSString stringWithFormat:@"电机转速:\n%@",@"无效"];
    }else if ([[dataDic objectForKey:@"dianjizhuansu"] intValue]==65535){
        label1.text = [NSString stringWithFormat:@"电机转速:\n%@",@"异常"];
    }else if ([[dataDic objectForKey:@"dianjizhuansu"] isEqualToString:@""]){
        label1.text = [NSString stringWithFormat:@"电机转速:\n%@",@"无"];
    }else{
        label1.text = [NSString stringWithFormat:@"电机转速:\n%@r/min",[dataDic objectForKey:@"dianjizhuansu"]];
    }
    label1.numberOfLines = 2;
    label1.textColor = UIColorFromRGB(0x6DB207);
    label1.font = [UIFont systemFontOfSize:13*MYWIDTH];
    [bgview addSubview:label1];
    
    //转速
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(5*MYWIDTH, greenView.bottom+4*MYWIDTH, 13*MYWIDTH, 13*MYWIDTH)];
    image2.image = [UIImage imageNamed:@"2车速"];
    [bgview addSubview:image2];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(image2.right+2*MYWIDTH, image2.top-6*MYWIDTH, greenView.width, 40*MYWIDTH)];
    if ([[dataDic objectForKey:@"chesu"] intValue]==65535) {
        label2.text = [NSString stringWithFormat:@"车速:\n%@",@"无效"];
    }else if ([[dataDic objectForKey:@"chesu"] intValue]==65535){
        label2.text = [NSString stringWithFormat:@"车速:\n%@",@"异常"];
    }else if ([[dataDic objectForKey:@"chesu"] isEqualToString:@""]){
        label2.text = [NSString stringWithFormat:@"车速:\n%@",@"无"];
    }else{
        label2.text = [NSString stringWithFormat:@"车速:\n%@km/h",[dataDic objectForKey:@"chesu"]];
    }
    label2.numberOfLines = 2;
    label2.textColor = UIColorFromRGB(0x6DB207);
    label2.font = [UIFont systemFontOfSize:13*MYWIDTH];
    [bgview addSubview:label2];
    
    //里程
    UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(5*MYWIDTH, blueView.top-35*MYWIDTH, 13*MYWIDTH, 13*MYWIDTH)];
    image3.image = [UIImage imageNamed:@"5累计里程"];
    [bgview addSubview:image3];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(image3.right+2*MYWIDTH, image3.top-6*MYWIDTH, blueView.width, 40*MYWIDTH)];
    if ([[dataDic objectForKey:@"licheng"] isEqualToString:@"4294967295"]) {
        label3.text = [NSString stringWithFormat:@"累计里程:\n%@",@"无效"];
    }else if ([[dataDic objectForKey:@"licheng"] isEqualToString:@"4294967294"]){
        label3.text = [NSString stringWithFormat:@"累计里程:\n%@",@"异常"];
    }else if ([[dataDic objectForKey:@"licheng"] isEqualToString:@""]){
        label3.text = [NSString stringWithFormat:@"累计里程:\n%@",@"无"];
    }else{
        label3.text = [NSString stringWithFormat:@"累计里程:\n%@km",[dataDic objectForKey:@"licheng"]];
    }
    label3.numberOfLines = 2;
    label3.textColor = UIColorFromRGB(0x7497FF);
    label3.font = [UIFont systemFontOfSize:13*MYWIDTH];
    [bgview addSubview:label3];
    
    //档位
    UIImageView *image4 = [[UIImageView alloc]initWithFrame:CGRectMake(5*MYWIDTH, blueView.bottom+4*MYWIDTH, 13*MYWIDTH, 13*MYWIDTH)];
    image4.image = [UIImage imageNamed:@"6档位信息"];
    [bgview addSubview:image4];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(image4.right+2*MYWIDTH, image4.top-6*MYWIDTH, blueView.width, 40*MYWIDTH)];
    label4.numberOfLines = 2;
    label4.textColor = UIColorFromRGB(0x7497FF);
    label4.font = [UIFont systemFontOfSize:13*MYWIDTH];
    [bgview addSubview:label4];
    NSString *dangStr =  [self getBinaryByDecimal:[[dataDic objectForKey:@"dangwei"] integerValue]];
    if (dangStr.length<8) {
        for (int i=0; 8-dangStr.length; i++) {
            dangStr = [NSString stringWithFormat:@"0%@",dangStr];
        }
    }
    dangStr = [dangStr substringFromIndex:4];
    if ([dangStr isEqualToString:@"0000"]){
        label4.text = [NSString stringWithFormat:@"档位信息:\n%@",@"空挡"];
    }else if ([dangStr isEqualToString:@"0001"]){
        label4.text = [NSString stringWithFormat:@"档位信息:\n%@",@"1档"];
    }else if ([dangStr isEqualToString:@"0010"]){
        label4.text = [NSString stringWithFormat:@"档位信息:\n%@",@"2档"];
    }else if ([dangStr isEqualToString:@"0011"]){
        label4.text = [NSString stringWithFormat:@"档位信息:\n%@",@"3档"];
    }else if ([dangStr isEqualToString:@"0100"]){
        label4.text = [NSString stringWithFormat:@"档位信息:\n%@",@"4档"];
    }else if ([dangStr isEqualToString:@"0101"]){
        label4.text = [NSString stringWithFormat:@"档位信息:\n%@",@"5档"];
    }else if ([dangStr isEqualToString:@"0110"]){
        label4.text = [NSString stringWithFormat:@"档位信息:\n%@",@"6档"];
    }else if ([dangStr isEqualToString:@"1101"]){
        label4.text = [NSString stringWithFormat:@"档位信息:\n%@",@"倒档"];
    }else if ([dangStr isEqualToString:@"1110"]){
        label4.text = [NSString stringWithFormat:@"档位信息:\n%@",@"自动D档"];
    }else if ([dangStr isEqualToString:@"1111"]){
        label4.text = [NSString stringWithFormat:@"档位信息:\n%@",@"停车P档"];
    }else{
        label4.text = [NSString stringWithFormat:@"档位信息:\n%@",@"其他"];
    }
    //电压
    UIImageView *image5 = [[UIImageView alloc]initWithFrame:CGRectMake(carImageView.right+25*MYWIDTH, yellowView.top-35*MYWIDTH, 13*MYWIDTH, 13*MYWIDTH)];
    image5.image = [UIImage imageNamed:@"3电压"];
    [bgview addSubview:image5];
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(image5.right+2*MYWIDTH, image5.top-6*MYWIDTH, yellowView.width, 40*MYWIDTH)];
    if ([[dataDic objectForKey:@"zongdianya"] intValue]==65535) {
        label5.text = [NSString stringWithFormat:@"总电压:\n%@",@"无效"];
    }else if ([[dataDic objectForKey:@"zongdianya"] intValue]==65535){
        label5.text = [NSString stringWithFormat:@"总电压:\n%@",@"异常"];
    }else if ([[dataDic objectForKey:@"zongdianya"] isEqualToString:@""]){
        label5.text = [NSString stringWithFormat:@"总电压:\n%@",@"无"];
    }else{
        label5.text = [NSString stringWithFormat:@"总电压:\n%@V",[dataDic objectForKey:@"zongdianya"]];
    }
    label5.numberOfLines = 2;
    label5.textColor = UIColorFromRGB(MYColor);
    label5.font = [UIFont systemFontOfSize:13*MYWIDTH];
    [bgview addSubview:label5];
    
    //电流
    UIImageView *image6 = [[UIImageView alloc]initWithFrame:CGRectMake(carImageView.right+25*MYWIDTH, yellowView.bottom+4*MYWIDTH, 13*MYWIDTH, 13*MYWIDTH)];
    image6.image = [UIImage imageNamed:@"4电流"];
    [bgview addSubview:image6];
    
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(image6.right+2*MYWIDTH, image6.top-6*MYWIDTH, yellowView.width, 40*MYWIDTH)];
    if ([[dataDic objectForKey:@"zongdianliu"] intValue]==65535) {
        label6.text = [NSString stringWithFormat:@"总电流:\n%@",@"无效"];
    }else if ([[dataDic objectForKey:@"zongdianliu"] intValue]==65535){
        label6.text = [NSString stringWithFormat:@"总电流:\n%@",@"异常"];
    }else if ([[dataDic objectForKey:@"zongdianliu"] isEqualToString:@""]){
        label6.text = [NSString stringWithFormat:@"总电流:\n%@",@"无"];
    }else{
        label6.text = [NSString stringWithFormat:@"总电流:\n%@A",[dataDic objectForKey:@"zongdianliu"]];
    }
    label6.numberOfLines = 2;
    label6.textColor = UIColorFromRGB(MYColor);
    label6.font = [UIFont systemFontOfSize:13*MYWIDTH];
    [bgview addSubview:label6];
    
    //电机温度
    UIImageView *image7 = [[UIImageView alloc]initWithFrame:CGRectMake(carImageView.right+25*MYWIDTH, redView.top-35*MYWIDTH, 13*MYWIDTH, 13*MYWIDTH)];
    image7.image = [UIImage imageNamed:@"7电机温度"];
    [bgview addSubview:image7];
    
    UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(image7.right+2*MYWIDTH, image7.top-6*MYWIDTH, redView.width, 40*MYWIDTH)];
    if ([[dataDic objectForKey:@"dianjiwendu"] intValue]==255) {
        label7.text = [NSString stringWithFormat:@"电机温度:\n%@",@"无效"];
    }else if ([[dataDic objectForKey:@"dianjiwendu"] intValue]==254){
        label7.text = [NSString stringWithFormat:@"电机温度:\n%@",@"异常"];
    }else if ([[dataDic objectForKey:@"dianjiwendu"] isEqualToString:@""]){
        label7.text = [NSString stringWithFormat:@"电机温度:\n%@",@"无"];
    }else{
        label7.text = [NSString stringWithFormat:@"电机温度:\n%@℃",[dataDic objectForKey:@"dianjiwendu"]];
    }
    label7.numberOfLines = 2;
    label7.textColor = UIColorFromRGB(0xF94932);
    label7.font = [UIFont systemFontOfSize:13*MYWIDTH];
    [bgview addSubview:label7];
    
    //SOC
    UIImageView *image8 = [[UIImageView alloc]initWithFrame:CGRectMake(carImageView.right+25*MYWIDTH, redView.bottom+4*MYWIDTH, 13*MYWIDTH, 13*MYWIDTH)];
    image8.image = [UIImage imageNamed:@"8soc"];
    [bgview addSubview:image8];
    
    UILabel *label8 = [[UILabel alloc]initWithFrame:CGRectMake(image8.right+2*MYWIDTH, image8.top-6*MYWIDTH, yellowView.width, 40*MYWIDTH)];
    if ([[dataDic objectForKey:@"soc"] intValue]==255) {
        label8.text = [NSString stringWithFormat:@"SOC:\n%@",@"无效"];
    }else if ([[dataDic objectForKey:@"soc"] intValue]==254){
        label8.text = [NSString stringWithFormat:@"SOC:\n%@",@"异常"];
    }else if ([[dataDic objectForKey:@"soc"] isEqualToString:@""]){
        label8.text = [NSString stringWithFormat:@"SOC:\n%@",@"无"];
    }else{
        label8.text = [NSString stringWithFormat:@"SOC:\n%@%%",[dataDic objectForKey:@"soc"]];
    }
    label8.numberOfLines = 2;
    label8.textColor = UIColorFromRGB(0xF94932);
    label8.font = [UIFont systemFontOfSize:13*MYWIDTH];
    [bgview addSubview:label8];
    
    UILabel *zuixin = [[UILabel alloc]initWithFrame:CGRectMake(0, carImageView.bottom+40*MYWIDTH, bgview.width, 20*MYWIDTH)];
    zuixin.text = [NSString stringWithFormat:@"%@",@"最新状态"];
    zuixin.textColor = UIColorFromRGB(0xFF7E00);
    zuixin.font = [UIFont systemFontOfSize:13*MYWIDTH];
    zuixin.textAlignment = NSTextAlignmentCenter;
    [bgview addSubview:zuixin];
    
    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, zuixin.bottom+10*MYWIDTH, bgview.width, 20*MYWIDTH)];
    timeLab.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"createtime"]];
    timeLab.textColor = [UIColor blackColor];
    timeLab.font = [UIFont systemFontOfSize:13*MYWIDTH];
    timeLab.textAlignment = NSTextAlignmentCenter;
    [bgview addSubview:timeLab];
    
    UIButton *zuoBut = [[UIButton alloc]initWithFrame:CGRectMake(120*MYWIDTH, timeLab.bottom+10*MYWIDTH, 25*MYWIDTH, 25*MYWIDTH)];
    [zuoBut setImage:[UIImage imageNamed:@"zuojiantou_2"] forState:UIControlStateNormal];
    zuoBut.tag = 10+intger;
    [zuoBut addTarget:self action:@selector(zuoClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:zuoBut];
    
    UIButton *youBut = [[UIButton alloc]initWithFrame:CGRectMake(bgview.width-145*MYWIDTH, timeLab.bottom+10*MYWIDTH, 25*MYWIDTH, 25*MYWIDTH)];
    [youBut setImage:[UIImage imageNamed:@"youjiantou_2"] forState:UIControlStateNormal];
    youBut.tag = 20+intger;
    [youBut addTarget:self action:@selector(youButClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:youBut];
}
- (void)zuoClick:(UIButton *)but{
    if (but.tag-10>0) {
        [_scrollView setContentOffset:CGPointMake((but.tag-11) * UIScreenW, 0) animated:YES];
    }else{
        jxt_showToastTitle(@"第一辆", 0.5);
    }
    
}
- (void)youButClick:(UIButton *)but{
    if (but.tag-20<_dataArr.count-1) {
        [_scrollView setContentOffset:CGPointMake((but.tag-19) * UIScreenW, 0) animated:YES];
    }else{
        jxt_showToastTitle(@"最后一辆", 0.5);
    }
    
}
- (void)deleteClick:(UIButton *)but{
    
    jxt_showAlertTwoButton(@"提示", @"您确定要删除吗？", @"取消", ^(NSInteger buttonIndex) {
        
    }, @"确定", ^(NSInteger buttonIndex) {
        NSDictionary *dataDic = _dataArr[but.tag];

        NSString *URLStr = @"/mbtwz/elecar?action=delMyCar";
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\"}",[dataDic objectForKey:@"id"]]};
        [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
            
            NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
            NSLog(@"%@",str);
            if ([str rangeOfString:@"false"].location!=NSNotFound) {
                jxt_showToastTitle(@"删除失败", 1);
            }else if([str rangeOfString:@"true"].location!=NSNotFound){
                jxt_showToastTitle(@"删除成功", 1);
                for(UIView *subv in [_scrollView subviews])
                {
                    [subv removeFromSuperview];
                }
                [self loadNew];
            }
            
        } fail:^(NSError *error) {
            
        }];
    });
    
}
//十进制转二进制
- (NSString *)getBinaryByDecimal:(NSInteger)decimal {
    
    NSString *binary = @"";
    while (decimal) {
        
        binary = [[NSString stringWithFormat:@"%ld", decimal % 2] stringByAppendingString:binary];
        if (decimal / 2 < 1) {
            
            break;
        }
        decimal = decimal / 2 ;
    }
    if (binary.length % 4 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {
            
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    return binary;
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
