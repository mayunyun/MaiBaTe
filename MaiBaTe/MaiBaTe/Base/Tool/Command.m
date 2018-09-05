//
//  Command.m
//  BaseFrame
//
//  Created by apple on 17/5/5.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "Command.h"
#import "ZZNetworkTools.h"
#import "JPUSHService.h"

@implementation Command

#pragma mark - 加载网络数据, 通过block拿到返回值
+ (void)loadDataWithParams:(NSDictionary *)params withPath:(NSString *)pathUrl completionBlock:(void (^)(id  responseObject,NSError *error))completionBlock autoShowError:(BOOL)autoShowError{
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    
    // 获得网络管理单例对象
    ZZNetworkTools *manager = [ZZNetworkTools sharedNetworkTools];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:[NSString stringWithFormat:@"%@%@",DATA_ADDRESS,pathUrl] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        completionBlock(arr,nil);

        
//        if ([[responseObject objectForKey:@"status"] intValue] == 1) {
//            completionBlock(responseObject,nil);
//            
//        } else if ([[responseObject objectForKey:@"status"] intValue] == 0){
//            completionBlock(nil,nil);
//            [SVProgressHUD showErrorWithStatus:@"请求错误"];
//            NSLog(@"请求失败：%@\n%@",[responseObject objectForKey:@"info"],responseObject);
//        } else if ([[responseObject objectForKey:@"status"] intValue] == -1){
//            NSLog(@"请登录：%@",responseObject);
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        if (autoShowError) {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];

        }
    }];
    
    
}

//新版正则表达式代码：
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//车牌号的正则表达式
+(BOOL)checkCarID:(NSString *)carID;
{
    if (carID.length!=7) {
        return NO;
    }
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-hj-zA-HJ-Z]{1}[a-hj-zA-HJ-Z_0-9]{4}[a-hj-zA-HJ-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carID];
    
    return YES;
}

//邮箱地址的正则表达式
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


+ (NSString*)convertNull:(id)object{
    
    // 转换空串
    
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if (object==nil){
        return @"";
    }
    return object;
    
}

//请求到的是字符串需要处理一下
+ (NSString *)replaceAllOthers:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return returnString;
}

+(void)isloginRequest:(void(^)(bool))string{
    __block BOOL flag = NO;
    NSString* LoginID= [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    NSString* user= [[NSUserDefaults standardUserDefaults]objectForKey:USERPHONE];
    NSString* pwd= [[NSUserDefaults standardUserDefaults]objectForKey:PASSWORD];

    [HTNetWorking postWithUrl:@"/mbtwz/mallLogin?action=isLogin" refreshCache:YES params:nil success:^(id response) {
        
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"登录状态%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            
            flag = YES;
            string(flag);
            return ;
        }
        
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            if ([[self convertNull:LoginID] isEqualToString:@""]) {
                flag = NO;
                string(flag);
                return ;
            }else{

                /*
                 登录接口：/mbtwz/mallLogin?action=checkMallLogin"+callback1
                 参数：account  ，password放在data中
                 */
                NSString *urlstr = @"/mbtwz/mallLogin?action=checkMallLogin";
                NSDictionary* parmas = @{@"data":[NSString stringWithFormat:@"{\"account\":\"%@\",\"password\":\"%@\"}",user,pwd]};
                [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id response) {
                    [SVProgressHUD dismiss];
                    NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"用户信息%@",array);
                    if (!IsEmptyValue(array)) {
                        
                        flag = YES;
                        [self joinJPush:user];

                    }else{
                        flag = NO;
                    }
                    string(flag);
                    return ;
                } fail:^(NSError *error) {
                    flag = NO;
                    string(flag);
                    return ;
                }];
            }
        }
        
    } fail:^(NSError *error) {
        flag = NO;
        string(flag);
    }];
}
#pragma mark 用户+标签、别名
+(void)joinJPush:(NSString *)tag{
    //    NSLog(@"123");
    //    NSLog(@"%@",tag);
    //[JPUSHService setTags:tag alias:@"yong" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:];
    
    //[JPUSHService setTags:tag aliasInbackground:@"yong"];
    
    //    [JPUSHService setTags:nil alias:tag fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
    //        // NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
    //    }];
    [JPUSHService setAlias:tag completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:0];
}
/**
 *  自定义提示框
 *
 *  @param msg 提示信息
 */
+ (void)customAlert:(NSString*)msg {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
//        [alert show];
    jxt_showAlertTitle(msg);
}

//校验字符串长度
+ (BOOL)isValidateNmuber:(NSString *)candidate length:(NSInteger) length

{
    NSString *numberRegex =[NSString stringWithFormat:@"\\w{%ld}",(long)length];
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL)isPassword:(NSString *) candidate
{
    NSString *      regex = @"(^[A-Za-z0-9_]{6,15}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:candidate];
}
#pragma 密码验证

+ (BOOL) validatePwd:(NSString *)pwd

{
    NSString *pwdRegex = @"^\\d{6}$";  // (6个连续数字,以数字开头,以数字结尾)
    
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pwdRegex];
    
    BOOL isMatch= [pwdTest evaluateWithObject:pwd];

    if (!isMatch) {
        
        NSLog(@"请输入6位密码");
        
        return NO;
        
    }
    return isMatch;
    
}
//给button上面的字填下划线
+ (void)addUnderline:(UIButton*)button str:(NSString*)str color:(UIColor*)color{
    //button 折行显示设置
    /*
     NSLineBreakByWordWrapping = 0,         // Wrap at word boundaries, default
     NSLineBreakByCharWrapping,     // Wrap at character boundaries
     NSLineBreakByClipping,     // Simply clip 裁剪从前面到后面显示多余的直接裁剪掉
     
     文字过长 button宽度不够时: 省略号显示位置...
     NSLineBreakByTruncatingHead,   // Truncate at head of line: "...wxyz" 前面显示
     NSLineBreakByTruncatingTail,   // Truncate at tail of line: "abcd..." 后面显示
     NSLineBreakByTruncatingMiddle  // Truncate middle of line:  "ab...yz" 中间显示省略号
     */
    //    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //    // you probably want to center it
    //    button.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
    //    button.layer.borderColor = [UIColor blackColor].CGColor;
    //    button.layer.borderWidth = 1.0;
    
    // underline Terms and condidtions
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:str];
    
    //设置下划线...
    /*
     NSUnderlineStyleNone                                    = 0x00, 无下划线
     NSUnderlineStyleSingle                                  = 0x01, 单行下划线
     NSUnderlineStyleThick NS_ENUM_AVAILABLE(10_0, 7_0)      = 0x02, 粗的下划线
     NSUnderlineStyleDouble NS_ENUM_AVAILABLE(10_0, 7_0)     = 0x09, 双下划线
     */
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    //此时如果设置字体颜色要这样
    [tncString addAttribute:NSForegroundColorAttributeName value:color  range:NSMakeRange(0,[tncString length])];
    
    //设置下划线颜色...
    [tncString addAttribute:NSUnderlineColorAttributeName value:color range:(NSRange){0,[tncString length]}];
    [button setAttributedTitle:tncString forState:UIControlStateNormal];
}
//改textField中placeholderColor
+ (void)placeholderColor:(UITextField*)textField str:(NSString*)holderText color:(UIColor*)color{
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:color
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"PingFangSC-Regular" size:13*MYWIDTH]
                        range:NSMakeRange(0, holderText.length)];
    textField.attributedPlaceholder = placeholder;
}

// 解析json数据返回为dict时
+ (id)tryToParseData:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]){
            dic = nil;
        }
    }
    return json;
}
//判断字符串是否是数字
+ (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//json格式字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}
//字典转json格式字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
/**
 *  调整图片尺寸和大小
 *
 *  @param sourceImage  原始图片
 *  @param maxImageSize 新图片最大尺寸
 *  @param maxSize      新图片最大存储大小
 *
 *  @return 新图片imageData
 */
+ (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize
{
    
    if (maxSize <= 0.0) maxSize = 1024.0;
    if (maxImageSize <= 0.0) maxImageSize = 1024.0;
    
    //先调整分辨率
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / maxImageSize;
    CGFloat tempWidth = newSize.width / maxImageSize;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    CGFloat sizeOriginKB = imageData.length / 1024.0;
    
    CGFloat resizeRate = 0.9;
    while (sizeOriginKB > maxSize && resizeRate > 0.1) {
        imageData = UIImageJPEGRepresentation(newImage,resizeRate);
        sizeOriginKB = imageData.length / 1024.0;
        resizeRate -= 0.1;
    }
    
    return imageData;
}

@end
