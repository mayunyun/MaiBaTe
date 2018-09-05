//
//  AddCarZLViewController2.m
//  MaiBaTe
//
//  Created by LONG on 2017/12/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AddCarZLViewController2.h"
#import "AddCarZLViewController3.h"
@interface AddCarZLViewController2 ()<UITextFieldDelegate>{
    UITextField *_firstField;
    UITextField *_secondField;
    UITextField *_threeField;

}

@end

@implementation AddCarZLViewController2

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
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [IQKeyboardManager sharedManager].enable = NO;
}
//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [IQKeyboardManager sharedManager].enable = YES;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    [self setUIview];
}
- (void)setUIview{
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 64, UIScreenW, 130*MYWIDTH)];
    if (statusbarHeight>20) {
        head.frame = CGRectMake(0, 88, UIScreenW, 130*MYWIDTH);
    }
    head.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:head];
    
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(33*MYWIDTH, 22*MYWIDTH, 12*MYWIDTH, 12*MYWIDTH)];
    image1.image = [UIImage imageNamed:@"租车小点_1"];
    [head addSubview:image1];
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW/2-6*MYWIDTH, 18*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH)];
    image2.image = [UIImage imageNamed:@"租车大点"];
    [head addSubview:image2];
    UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW - 47*MYWIDTH, 22*MYWIDTH, 12*MYWIDTH, 12*MYWIDTH)];
    image3.image = [UIImage imageNamed:@"租车小点"];
    [head addSubview:image3];
    
    UIView *xuxian = [[UIView alloc]initWithFrame:CGRectMake(image1.right, 27*MYWIDTH, image2.left-image1.right, 1*MYWIDTH)];
    xuxian.backgroundColor = UIColorFromRGB(0xCCCCCC);
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
    
    UILabel *city = [[UILabel alloc]initWithFrame:CGRectMake(16*MYWIDTH, xian.bottom+17*MYWIDTH, 80, 20*MYWIDTH)];
    city.text = @"企业名称";
    city.textColor = UIColorFromRGB(0x222222);
    city.font = [UIFont systemFontOfSize:14];
    [head addSubview:city];
    
    UITextField *qiyeText = [[UITextField alloc]initWithFrame:CGRectMake(UIScreenW-115, xian.bottom, 100, 50*MYWIDTH)];
    qiyeText.delegate = self;
    qiyeText.placeholder = @"填写企业名称";
    qiyeText.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    qiyeText.textAlignment = NSTextAlignmentRight;
    qiyeText.textColor = UIColorFromRGB(0x333333);
    [head addSubview:qiyeText];
    [Command placeholderColor:qiyeText str:qiyeText.placeholder color:UIColorFromRGB(0x888888)];
    
    UIView *baiBG = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, head.bottom+20*MYWIDTH, UIScreenW-30*MYWIDTH, 165*MYWIDTH)];
    baiBG.backgroundColor = [UIColor whiteColor];
    baiBG.layer.cornerRadius = 10;
    [self.view addSubview:baiBG];
    
    UIImageView *xing1 = [[UIImageView alloc]initWithFrame:CGRectMake(12*MYWIDTH, 23*MYWIDTH, 10*MYWIDTH, 10*MYWIDTH)];
    xing1.image = [UIImage imageNamed:@"星号"];
    [baiBG addSubview:xing1];
    
    UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(xing1.right+10*MYWIDTH, 0, 80, 55*MYWIDTH)];
    nameLabel.textColor = UIColorFromRGB(0x222222);
    nameLabel.text=@"联系人姓名";
    nameLabel.font = [UIFont systemFontOfSize:14];
    [baiBG addSubview:nameLabel];
    
    _firstField = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right, nameLabel.top, baiBG.width - nameLabel.right-14*MYWIDTH, nameLabel.height)];
    _firstField.delegate = self;
    _firstField.placeholder = @"请填写联系人姓名";
    _firstField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _firstField.textAlignment = NSTextAlignmentRight;
    _firstField.textColor = UIColorFromRGB(0x333333);
    [baiBG addSubview:_firstField];
    [Command placeholderColor:_firstField str:_firstField.placeholder color:UIColorFromRGB(0x888888)];
    
    UIView* lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, nameLabel.bottom, baiBG.width, 0.5)];
    lineView1.backgroundColor = UIColorFromRGB(MYLine);
    [baiBG addSubview:lineView1];
    
    UIImageView *xing2 = [[UIImageView alloc]initWithFrame:CGRectMake(12*MYWIDTH, lineView1.bottom + 23*MYWIDTH, 10*MYWIDTH, 10*MYWIDTH)];
    xing2.image = [UIImage imageNamed:@"星号"];
    [baiBG addSubview:xing2];
    
    UILabel* phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, lineView1.bottom, nameLabel.width, nameLabel.height)];
    phoneLabel.text = @"联系人手机";
    phoneLabel.textColor = nameLabel.textColor;
    phoneLabel.font = nameLabel.font;
    [baiBG addSubview:phoneLabel];
    
    _secondField = [[UITextField alloc]initWithFrame:CGRectMake(phoneLabel.right, phoneLabel.top, _firstField.width, _firstField.height)];
    _secondField.delegate = self;
    _secondField.placeholder = @"请填写联系人手机";
    _secondField.keyboardType = UIKeyboardTypeNumberPad;
    _secondField.textAlignment = NSTextAlignmentRight;
    _secondField.textColor = UIColorFromRGB(0x333333);
    _secondField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [baiBG addSubview:_secondField];
    [Command placeholderColor:_secondField str:_secondField.placeholder color:UIColorFromRGB(0x888888)];
    
    UIView* lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, phoneLabel.bottom, baiBG.width, 0.5)];
    lineView2.backgroundColor = UIColorFromRGB(MYLine);
    [baiBG addSubview:lineView2];
    
    UILabel* emlLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, lineView2.bottom, nameLabel.width, nameLabel.height)];
    emlLabel.text = @"电子邮箱";
    emlLabel.textColor = nameLabel.textColor;
    emlLabel.font = nameLabel.font;
    [baiBG addSubview:emlLabel];
    
    _threeField = [[UITextField alloc]initWithFrame:CGRectMake(emlLabel.right, emlLabel.top, _firstField.width, _firstField.height)];
    _threeField.delegate = self;
    _threeField.placeholder = @"请填写电子邮箱";
    _threeField.textAlignment = NSTextAlignmentRight;
    _threeField.textColor = UIColorFromRGB(0x333333);
    _threeField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [baiBG addSubview:_threeField];
    [Command placeholderColor:_threeField str:_threeField.placeholder color:UIColorFromRGB(0x888888)];
    
    UILabel* zhuLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, baiBG.bottom, UIScreenW-30*MYWIDTH, 45*MYWIDTH)];
    zhuLabel.text = @"带'*'的选项为必填项";
    zhuLabel.textAlignment = NSTextAlignmentRight;
    zhuLabel.textColor = UIColorFromRGB(0x888888);
    zhuLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:zhuLabel];
    
    UIButton *upBut = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bottom-55*MYWIDTH, UIScreenW, 55*MYWIDTH)];
    [upBut setTitle:@"提交" forState:UIControlStateNormal];
    upBut.titleLabel.font = [UIFont systemFontOfSize:20];
    [upBut setBackgroundColor:UIColorFromRGB(MYColor)];
    [upBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [upBut addTarget:self action:@selector(upviewCilck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upBut];
}
- (void)upviewCilck{
    if ([[Command convertNull:_firstField.text] isEqualToString:@""]) {
        jxt_showAlertTitle(@"请填写联系人姓名");
        return;
    }
    if ([[Command convertNull:_secondField.text] isEqualToString:@""]) {
        jxt_showAlertTitle(@"请填写联系人手机号");
        return;
    }
    if (![Command isMobileNumber:_secondField.text]) {
        jxt_showAlertTitle(@"请填写正确的手机号");
        return;
    }
    if (![[Command convertNull:_threeField.text] isEqualToString:@""]) {
        if (![Command isValidateEmail:_threeField.text]) {
            jxt_showAlertTitle(@"请填写正确的电子邮箱");
            return;
        }
    }
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    [dataDic setValue:@"" forKey:@"note"];
    [dataDic setValue:_firstField.text forKey:@"link_name"];
    [dataDic setValue:_secondField.text forKey:@"link_phone"];
    [dataDic setValue:_threeField.text forKey:@"link_email"];
    [dataDic setValue:self.time forKey:@"take_time"];
    //[dataDic setValue:self.city forKey:@"shijiquche_address"];
    [dataDic setValue:@"lease_order" forKey:@"table"];
    [dataDic setValue:self.carArr forKey:@"lease_order_detailList"];
    NSLog(@">>>%@",dataDic);
    [SVProgressHUD showWithStatus:@"正在提交..."];

    NSDictionary* KCparams = @{@"data":[Command dictionaryToJson:dataDic]};//
    [HTNetWorking postWithUrl:@"/mbtwz/leaseorderwz?action=addLeaseOrder" refreshCache:YES params:KCparams success:^(id response) {
        [SVProgressHUD dismiss];
        NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
        
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            AddCarZLViewController3 *addcar = [[AddCarZLViewController3 alloc]init];
            [self.navigationController pushViewController:addcar animated:YES];
        }else{
            jxt_showAlertTitle(@"提交请求错误");
        }
        
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];

    
    
    
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
