//
//  WuLiuSJRZViewController.m
//  MaiBaTe
//
//  Created by LONG on 2018/1/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WuLiuSJRZViewController.h"
#import "WuLiuSJRZViewCell.h"
#import "WuLiuSJRZPhoneCell.h"
#import "WuLiuSjrzIngViewController.h"
@interface WuLiuSJRZViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *imageArr;
@property(nonatomic,strong)NSMutableDictionary *dataDic;

@end

@implementation WuLiuSJRZViewController
{
    int page;
    UIButton *foodBut;
    NSString * yzmCode;
}

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
    titleLab.text = @"司机认证";
    titleLab.textColor = UIColorFromRGB(0x333333);
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.imageArr = [[NSMutableArray alloc]init];
    self.dataDic = [[NSMutableDictionary alloc]init];
    for (int i=0; i<6; i++) {
        UIImage *image = [[UIImage alloc]init];
        image = [UIImage imageNamed:@"tianjiashili"];
        [self.imageArr addObject:image];
        
    }
    [self.dataDic setValue:@"" forKey:@"driver_name"];
    [self.dataDic setValue:@"" forKey:@"driver_phone"];
    [self.dataDic setValue:@"" forKey:@"driver_car_number"];
    [self.dataDic setValue:@"" forKey:@"driver_checkno"];

    self.navigationItem.titleView = titleView;
    
    [self tableview];
    
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH) style:UITableViewStyleGrouped];
        if (statusbarHeight>20) {
            _tableview.frame = CGRectMake(0, 0, UIScreenW, UIScreenH-34);
            
        }
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        UIView *foodview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 130*MYWIDTH)];
        _tableview.tableFooterView = foodview;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
        tapGestureRecognizer.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        [_tableview addGestureRecognizer:tapGestureRecognizer];
        foodBut = [[UIButton alloc]initWithFrame:CGRectMake(15*MYWIDTH, 30*MYWIDTH, UIScreenW-30*MYWIDTH, 50*MYWIDTH)];
        [foodBut setBackgroundColor:UIColorFromRGB(MYColor)];
        [foodBut setTitle:@"确认提交" forState:UIControlStateNormal];
        foodBut.layer.cornerRadius = 8;
        [foodBut addTarget:self action:@selector(foodButClick) forControlEvents:UIControlEventTouchUpInside];
        [foodview addSubview:foodBut];
    }
    return _tableview;
    
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0||UIScreenW==320) {
        return 233;
    }
    
    return 240*MYWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * stringCell = @"WuLiuSJRZViewCell";
        WuLiuSJRZViewCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameField.delegate = self;
        cell.carPField.delegate = self;
        cell.phoneField.delegate = self;
        cell.yzmField.delegate = self;
        cell.nameField.layer.cornerRadius = 16.f;
        cell.nameField.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.nameField.layer.borderWidth = 1.0f;
        cell.nameField.layer.masksToBounds = YES;
        cell.carPField.layer.cornerRadius = 16.f;
        cell.carPField.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.carPField.layer.borderWidth = 1.0f;
        cell.carPField.layer.masksToBounds = YES;
        cell.phoneField.layer.cornerRadius = 16.f;
        cell.phoneField.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.phoneField.layer.borderWidth = 1.0f;
        cell.phoneField.layer.masksToBounds = YES;
        cell.yzmField.layer.cornerRadius = 16.f;
        cell.yzmField.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cell.yzmField.layer.borderWidth = 1.0f;
        cell.yzmField.layer.masksToBounds = YES;
        NSLog(@">>>>>>%@",_dataDic);
        cell.nameField.text = [self.dataDic objectForKey:@"driver_name"];
        cell.phoneField.text = [self.dataDic objectForKey:@"driver_phone"];
        cell.carPField.text = [self.dataDic objectForKey:@"driver_car_number"];
        cell.yzmField.text = [self.dataDic objectForKey:@"driver_checkno"];
        [cell setYzmCodeBlock:^(NSString * yzmcode) {
            yzmCode = yzmcode;
        }];
        return cell;
        
    }else{
        static NSString * stringCell = @"WuLiuSJRZPhoneCell";
        WuLiuSJRZPhoneCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringCell owner:nil options:nil]lastObject];
        }
        [cell setUpData:indexPath.section];
        NSLog(@"%@  %zd",self.imageArr,indexPath.section);

        UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTapClick:)];
        cell.oneImage.tag = 1100+indexPath.section;//1101//1102
        [cell.oneImage addGestureRecognizer:tap1];
        cell.oneImage.image = self.imageArr[indexPath.section-1];

        UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTapClick:)];
        cell.twoImage.tag = 1102+indexPath.section;//1103//1104
        [cell.twoImage addGestureRecognizer:tap2];
        cell.twoImage.image = self.imageArr[indexPath.section+1];

        
        UITapGestureRecognizer* tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTapClick:)];
        cell.threeImage.tag = 1104+indexPath.section;//1105//1106
        [cell.threeImage addGestureRecognizer:tap3];
        cell.threeImage.image = self.imageArr[indexPath.section+3];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{//头视图
    return 10;

}
//头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)foodButClick{
    if ([[self.dataDic objectForKey:@"driver_name"] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写您的姓名", 1);
        return;
    }else if([[self.dataDic objectForKey:@"driver_car_number"] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写您的车牌号", 1);
        return;
    }
//    else if(![Command checkCarID:[self.dataDic objectForKey:@"driver_car_number"]]) {
//        jxt_showToastTitle(@"请填写正确的车牌号", 1);
//        return;
//    }
    else if([[self.dataDic objectForKey:@"driver_phone"] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写您的手机号", 1);
        return;
    }else if([[self.dataDic objectForKey:@"driver_checkno"] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写验证码", 1);
        return;
    }else if(![[self.dataDic objectForKey:@"driver_checkno"] isEqualToString:yzmCode]) {
        jxt_showToastTitle(@"请填写正确验证码", 1);
        return;
    }else if([self.imageArr[0] isEqual:[UIImage imageNamed:@"tianjiashili"]]) {
        jxt_showToastTitle(@"上传的图片信息不完整!", 1);
        return;
    }else if([self.imageArr[2] isEqual:[UIImage imageNamed:@"tianjiashili"]]) {
        jxt_showToastTitle(@"上传的图片信息不完整!", 1);
        return;
    }else if([self.imageArr[4] isEqual:[UIImage imageNamed:@"tianjiashili"]]) {
        jxt_showToastTitle(@"上传的图片信息不完整!", 1);
        return;
    }else if([self.imageArr[1] isEqual:[UIImage imageNamed:@"tianjiashili"]]) {
        jxt_showToastTitle(@"上传的图片信息不完整!", 1);
        return;
    }else if([self.imageArr[3] isEqual:[UIImage imageNamed:@"tianjiashili"]]) {
        jxt_showToastTitle(@"上传的图片信息不完整!", 1);
        return;
    }else if([self.imageArr[5] isEqual:[UIImage imageNamed:@"tianjiashili"]]) {
        jxt_showToastTitle(@"上传的图片信息不完整!", 1);
        return;
    }
    
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"driver_name\":\"%@\",\"driver_phone\":\"%@\",\"driver_car_number\":\"%@\",\"driver_checkno\":\"%@\"}",[self.dataDic objectForKey:@"driver_name"],[self.dataDic objectForKey:@"driver_phone"],[self.dataDic objectForKey:@"driver_car_number"],[self.dataDic objectForKey:@"driver_checkno"]]};
    
    NSLog(@"%@",params);
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在提交..."];
    
    foodBut.hidden = YES;
    [HTNetWorking postWithUrl:@"/mbtwz/drivercertification?action=insertDriverCertificationInfo" refreshCache:YES params:params success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"余额支付状态%@",str);
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            [SVProgressHUD dismiss];

            jxt_showAlertOneButton(@"提示", @"基本信息提交失败", @"确定", ^(NSInteger buttonIndex) {
            });
        }else{
            page=0;
            NSString *str1 = [str substringFromIndex:1];
            //图片标识（0：手持身份证照，1：身份证正面照,2:身份证反面照 3:驾驶证 4:行驶证 5:车辆照片）
            [self requestPortal:nil img:self.imageArr[0] idStr:[str1 substringToIndex:str1.length-1] driver_img_type:@"1"];
            [self requestPortal:nil img:self.imageArr[1] idStr:[str1 substringToIndex:str1.length-1] driver_img_type:@"3"];
            [self requestPortal:nil img:self.imageArr[2] idStr:[str1 substringToIndex:str1.length-1] driver_img_type:@"2"];
            [self requestPortal:nil img:self.imageArr[3] idStr:[str1 substringToIndex:str1.length-1] driver_img_type:@"4"];
            [self requestPortal:nil img:self.imageArr[4] idStr:[str1 substringToIndex:str1.length-1] driver_img_type:@"0"];
            [self requestPortal:nil img:self.imageArr[5] idStr:[str1 substringToIndex:str1.length-1] driver_img_type:@"5"];
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}

- (void)imgViewTapClick:(UITapGestureRecognizer*)tap{
    UIActionSheet* sheet = [[UIActionSheet alloc
                             ]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册里选择照片", @"现在就拍一张", nil];
    UIImageView *image = (UIImageView *)[tap view];
    sheet.tag = image.tag-1000;
    [sheet showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (0 == buttonIndex) {
        [self LocalPhoto:actionSheet.tag];
    } else if (1 == buttonIndex) {
        [self takePhoto:actionSheet.tag];
    }
    
}

//开始拍照
-(void)takePhoto:(NSInteger)tager
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.view.tag = tager-101;
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        // DLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
//打开本地相册
-(void)LocalPhoto:(NSInteger)tager
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.view.tag = tager-101;
    NSLog(@"%zd",tager-1);
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSLog(@"%zd",picker.view.tag);
//        UIImageView *imageImage = [self.view viewWithTag:1101];
//        imageImage.image = image;
        
//        NSData *data;
//        if (UIImagePNGRepresentation(image) == nil)
//        {
//            data = UIImageJPEGRepresentation(image, 1.0);
//        }
//        else
//        {
//            data = UIImagePNGRepresentation(image);
//        }
        
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self.imageArr replaceObjectAtIndex:picker.view.tag withObject:image];

        [_tableview reloadData];
    }
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //DLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestPortal:(NSData*)imgData img:(UIImage*)img idStr:(NSString *)idStr driver_img_type:(NSString *)driver_img_type{
    //NSData 转 Base64
    //    NSString* imgStr = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //        NSLog(@"上传图片的请求imgStr%@",imgStr);
#pragma mark 上传图片的请求
    //    [_headerBtn setImage:img forState:UIControlStateNormal];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/mbtwz/drivercertification?action=insertDCUploadImg"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    NSDictionary* params = @{@"driverid":idStr,
                             @"driver_img_type":driver_img_type};
    [HTNetWorking uploadWithImage:img url:urlStr filename:fileName name:@"img" mimeType:@"image/jpeg" parameters:params progress:^(int64_t bytesWritten, int64_t totalBytesWritten) {
        
    } success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"上传返回%@",str);
        
//        if ([str rangeOfString:@"true"].location != NSNotFound) {
//            page++;
//            [Command customAlert:@"上传成功"];
//        }else{
//            [SVProgressHUD dismiss];
//            jxt_showToastTitle(@"提交失败", 1);
//        }
        page++;
//        [Command customAlert:@"上传成功"];
        if (page==6) {
            [SVProgressHUD dismiss];
            [self setWithSeccessView];

        }

    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
    
    
}
- (void)setWithSeccessView{
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:NO];
    [SMAlert setcontrolViewbackgroundColor:[UIColor clearColor]];
    
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 220*MYWIDTH, 220*MYWIDTH)];
    imageview.userInteractionEnabled = YES;
    imageview.image = [UIImage imageNamed:@"提交成功"];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 105*MYWIDTH, imageview.width, 20*MYWIDTH)];
    lab.text = @"认证提交成功";
    lab.font = [UIFont systemFontOfSize:14*MYWIDTH];
    lab.textColor = UIColorFromRGB(0x333333);
    lab.textAlignment = NSTextAlignmentCenter;
    [imageview addSubview:lab];
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, lab.bottom+5, imageview.width, 20*MYWIDTH)];
    lab1.text = @"请您等待审核";
    lab1.font = [UIFont systemFontOfSize:14*MYWIDTH];
    lab1.textColor = UIColorFromRGB(0x333333);
    lab1.textAlignment = NSTextAlignmentCenter;
    [imageview addSubview:lab1];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(60*MYWIDTH, lab1.bottom+15*MYWIDTH, 100*MYWIDTH, 35*MYWIDTH)];
    [but setTitle:@"确定" forState:UIControlStateNormal];
    [but setTitleColor:UIColorFromRGB(MYColor) forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    but.backgroundColor = [UIColor whiteColor];
    but.layer.masksToBounds = YES;
    but.layer.cornerRadius = 5;
    but.layer.borderColor = UIColorFromRGB(MYColor).CGColor;//设置边框颜色
    but.layer.borderWidth = 1;//设置边缘宽度
    [but addTarget:self action:@selector(butHideClick) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:but];
    [SMAlert showCustomView:imageview];

}
- (void)butHideClick{
    [SMAlert hide:NO];
    WuLiuSjrzIngViewController *sjrz = [[WuLiuSjrzIngViewController alloc]init];
    [self.navigationController pushViewController:sjrz animated:YES];
}
//以下两个代理方法可以防止键盘遮挡textview
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
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
- (void)textFieldDidEndEditing:(UITextField *)textField{
    float offset = 0.0f;
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;
    
    CGRect rect = CGRectMake(0.0f, offset , width, height);
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    WuLiuSJRZViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    if (textField==cell.nameField) {
        [self.dataDic setValue:textField.text forKey:@"driver_name"];
    }else if (textField==cell.carPField){
        [self.dataDic setValue:textField.text forKey:@"driver_car_number"];
    }else if (textField==cell.phoneField){
        [self.dataDic setValue:textField.text forKey:@"driver_phone"];
    }else if (textField==cell.yzmField){
        [self.dataDic setValue:textField.text forKey:@"driver_checkno"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    WuLiuSJRZViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    if (textField==cell.nameField) {
        [self.dataDic setValue:textField.text forKey:@"driver_name"];
    }else if (textField==cell.carPField){
        [self.dataDic setValue:textField.text forKey:@"driver_car_number"];
    }else if (textField==cell.phoneField){
        [self.dataDic setValue:textField.text forKey:@"driver_phone"];
    }else if (textField==cell.yzmField){
        [self.dataDic setValue:textField.text forKey:@"driver_checkno"];
    }
    return [textField resignFirstResponder];
}
//取消键盘的响应
-(void)hideKeyBoard{
    [_tableview endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backToLastViewController:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
