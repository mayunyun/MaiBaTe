//
//  ZhongDuanViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZhongDuanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "chargeTypeViewController.h"
#import "MBTNavigationController.h"
@interface ZhongDuanViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    BOOL isLightOn;
    AVCaptureDevice *device;
    UITextField *_textField;
    UILabel *_numerTS;
    UIImagePickerController *_myPicker;

}
@property BOOL isLightOn;

@end

@implementation ZhongDuanViewController
@synthesize isLightOn;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setSaoMaShiLi];
}


//视图将要消失时关闭手电筒
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (isLightOn) {
        [self turnOffLed:YES];
    }
    
}
- (void)setSaoMaShiLi{
    //获取提示的终端编号
    ZZNetworkTools *manager = [ZZNetworkTools sharedNetworkTools];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *URLStr = @"/mbtwz/cdxt?action=getZuiJinOrderSBM";
    [manager POST:[NSString stringWithFormat:@"%@%@",DATA_ADDRESS,URLStr] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (!IsEmptyValue(str)) {
            NSString *str1 = [str substringFromIndex:1];
            
            NSString *str2 = [str1 substringToIndex:str1.length-1];
            _numerTS.text = str2;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0x666666);
    [self upAVCaptureDevice];
    [self setOverlayPickerView];
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
- (void)upAVCaptureDevice{
    //AVCaptureDevice代表抽象的硬件设备
    // 找到一个合适的AVCaptureDevice
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![device hasTorch]) {//判断是否有闪光灯
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前设备没有闪光灯，不能提供手电筒功能" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alter show];
    }
    
    isLightOn = NO;
}
//
- (void)deviceClicked:(UIButton *)but{
    isLightOn = 1-isLightOn;
    if (isLightOn) {
        [self turnOnLed:YES];
        but.selected = YES;
    }else{
        [self turnOffLed:YES];
        but.selected = NO;
    }
}
//打开手电筒
-(void) turnOnLed:(bool)update
{
    [device lockForConfiguration:nil];
    [device setTorchMode:AVCaptureTorchModeOn];
    [device unlockForConfiguration];
}

//关闭手电筒
-(void) turnOffLed:(bool)update
{
    [device lockForConfiguration:nil];
    [device setTorchMode: AVCaptureTorchModeOff];
    [device unlockForConfiguration];
}
- (void)setOverlayPickerView{
    //页面返回按钮
    CGRect leftFrame;
    leftFrame = CGRectMake(-2, 10, 120, 60);
    UIButton *leftButton= [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame =leftFrame;
    [leftButton addTarget:self action:@selector(dismissOverlayView:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"  扫码充电" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [leftButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [self.view addSubview:leftButton];
    
    CGRect rightFrame;
    rightFrame = CGRectMake(UIScreenW-58, 10, 60, 60);
    UIButton *rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame =rightFrame;
    [rightButton addTarget:self action:@selector(xiangceView:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"相册"] forState:UIControlStateNormal];
    [self.view addSubview:rightButton];
    
    UIImageView *tiaoxingma = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW/2-80*MYWIDTH, UIScreenH/2-UIScreenW/2, 160*MYWIDTH, 135*MYWIDTH)];
    tiaoxingma.image = [UIImage imageNamed:@"条形码"];
    [self.view addSubview:tiaoxingma];
    UIImageView *biankuang = [[UIImageView alloc]initWithFrame:CGRectMake(20, tiaoxingma.height - 21, tiaoxingma.width-40, 20)];
    biankuang.image = [UIImage imageNamed:@"红边框"];
    [tiaoxingma addSubview:biankuang];
    
    _numerTS = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tiaoxingma.width-40, 20)];
    _numerTS.text = @"";
    _numerTS.textColor = [UIColor blackColor];
    _numerTS.font = [UIFont systemFontOfSize:12];
    _numerTS.textAlignment = NSTextAlignmentCenter;
    [biankuang addSubview:_numerTS];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(30*MYWIDTH, tiaoxingma.bottom + 40*MYWIDTH, UIScreenW - 60*MYWIDTH, 50*MYWIDTH)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.placeholder = @"请输入终端编号(如上图红色区域)";
    _textField.textAlignment =  NSTextAlignmentCenter;
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.textColor = [UIColor blackColor];
    [self.view addSubview:_textField];
    
    UIButton *deterBut = [[UIButton alloc]initWithFrame:CGRectMake(30*MYWIDTH, _textField.bottom + 20*MYWIDTH, UIScreenW - 60*MYWIDTH, 50*MYWIDTH)];
    [deterBut setBackgroundImage:[UIImage imageNamed:@"buttonBG"] forState:UIControlStateNormal];
    [deterBut setTitle:@"确定" forState:UIControlStateNormal];
    [deterBut addTarget:self action:@selector(deterButClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deterBut];
    
    //手电筒
    UIButton *devicebtn = [[UIButton alloc]init];
    [devicebtn setFrame:CGRectMake(UIScreenW/2-30*MYWIDTH, deterBut.bottom+20, 60*MYWIDTH, 60*MYWIDTH)];
    [devicebtn setImage:[UIImage imageNamed:@"手电筒"] forState:UIControlStateNormal];
    [devicebtn setImage:[UIImage imageNamed:@"手电筒亮"] forState:UIControlStateSelected];
    [devicebtn addTarget:self action:@selector(deviceClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:devicebtn];

    //底层按钮
    UIView *blackBG = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenH-100*MYWIDTH, UIScreenW, 100*MYWIDTH)];
    blackBG.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackBG];
    
    NSArray *labArr = @[@"扫码",@"输入终端编号"];
    NSArray *imageArr = @[@"扫描二维码_1",@"输入_1"];
    for (int i=0; i<2; i++) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW/4-15*MYWIDTH + UIScreenW/2*i, 20*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
        image.image = [UIImage imageNamed:imageArr[i]];
        [blackBG addSubview:image];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW/4-50*MYWIDTH + UIScreenW/2*i, image.bottom+5, 100*MYWIDTH, 20)];
        lab.text = labArr[i];
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:12];
        lab.textAlignment = NSTextAlignmentCenter;
        [blackBG addSubview:lab];
    }
    
    UIButton *SaoMabut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, UIScreenW/2, blackBG.height)];
    [SaoMabut addTarget:self action:@selector(saoMaClick) forControlEvents:UIControlEventTouchUpInside];
    [blackBG addSubview:SaoMabut];
}

- (void)deterButClicked{
    
    if ([_textField.text isEqualToString:@""]) {
        jxt_showToastTitle(@"终端编号不能为空", 1);
        return;
    }
    [self alertMetadataObjectData:_textField.text];
}
/**
 *  @author Whde
 *
 *  处理扫码抢号
 *
 */
- (void)alertMetadataObjectData:(NSString *)data{
    [SVProgressHUD showWithStatus:@"正在加载..."];

    //判断扫码的抢号是否存在
    NSDictionary* parmas = @{@"params":[NSString stringWithFormat:@"{\"electricsbm\":\"%@\"}",data]};
    NSString *URLStr = @"/mbtwz/cdxt?action=checkChongDianQianHao";
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:parmas success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
        NSLog(@"-------------%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {

            //判断此抢号是否在充电
            NSDictionary* parmas = @{@"params":[NSString stringWithFormat:@"{\"electricsbm\":\"%@\"}",data]};
            NSString *URLStr = @"/mbtwz/wxorder?action=checkZhengZaiChongDian";
            [HTNetWorking postWithUrl:URLStr refreshCache:YES params:parmas success:^(id response) {
                [SVProgressHUD dismiss];

                NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
                NSLog(@"正在进行充电>>>>%@",str);
                if ([str rangeOfString:@"true"].location!=NSNotFound) {
                    //字符串中有true串
                    jxt_showToastTitle(@"此充电抢号正在进行充电", 1);
                    
                }else{
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user setObject:_textField.text forKey:ChongDianNumer];
                    [user synchronize];
                    
                    chargeTypeViewController *chargeVC = [[chargeTypeViewController alloc]init];
                    MBTNavigationController *nav = [[MBTNavigationController alloc] initWithRootViewController:chargeVC];
                    [self presentViewController:nav animated:YES completion:nil];
                }
            } fail:^(NSError *error) {
                [SVProgressHUD dismiss];
            }];
            
        }else{
            [SVProgressHUD dismiss];

            jxt_showToastTitle(@"此扫码抢号不存在", 1);
            
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
- (void)saoMaClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)xiangceView:(UIButton *)but{
    NSLog(@"支持图库");
    _myPicker = [[UIImagePickerController alloc] init];
    _myPicker.delegate = self;
    _myPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _myPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _myPicker.allowsEditing = YES;
    [self presentViewController:_myPicker animated:YES completion:nil];
    NSLog(@"选择相册");
}
#pragma mark imagePicker代理方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //取消选取图片
    [self dismissViewControllerAnimated:YES completion:^{
        // NSLog(@"取消选取图片");
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //[_myPicker dismissViewControllerAnimated:YES completion:nil];
    //获取选中的照片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    //初始化  将类型设置为二维码
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //设置数组，放置识别完之后的数据
        NSArray *features = [detector featuresInImage:[CIImage imageWithData:UIImagePNGRepresentation(image)]];
        //判断是否有数据（即是否是二维码）
        if (features.count >= 1) {
            //取第一个元素就是二维码所存放的文本信息
            CIQRCodeFeature *feature = features[0];
            NSString *scannedResult = feature.messageString;
            //通过对话框的形式呈现
            [self alertMetadataObjectData:scannedResult];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"这不是一个二维码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
}
- (void)dismissOverlayView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
