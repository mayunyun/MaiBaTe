//
//  AppDelegate.m
//  MaiBaTe
//
//  Created by apple on 17/8/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "MBTTabBarController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AlipaySDK/AlipaySDK.h>//支付宝
#import "WXApi.h"//微信
#import "WXApiManager.h"
#import "Reachability.h"

#import <TencentOpenAPI/TencentOAuth.h>

#import <AdSupport/AdSupport.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>
{
    //int _num;

}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 创建Reachability
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    // 开始监控网络(一旦网络状态发生改变, 就会发出通知kReachabilityChangedNotification)
    [reachability startNotifier];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController =[[MBTTabBarController alloc]init];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    [self initAppearence];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [AMapServices sharedServices].apiKey = GaoDeMapKey;

    // 设置服务器环境 01:生产环境  00:测试环境
    [HTServerConfig setHTConfigEnv:@"01"];
    
    //向微信注册
    [WXApi registerApp:WXPay_APPID withDescription:@"demo 2.0"];
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //_num = 0;
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:nil
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];

    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);

        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    return YES;
}

- (void)initAppearence
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBarTintColor:UIColorFromRGB(0x333333)];
    
    [bar setBarStyle:UIBarStyleBlack];
    [bar setTintColor:[UIColor whiteColor]];
    [bar setTranslucent:NO];
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
    //[rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        //[rootViewController addNotificationCount];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
        //[rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
       // [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:_num + 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];   //清除角标
    [JPUSHService setBadge:0];
    [JPUSHService resetBadge];
    
    //[UMSocialSnsService  applicationDidBecomeActive];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    //NSLog(@"角标个数：%ld",(long)[UIApplication sharedApplication].applicationIconBadgeNumber);
    if ((long)[UIApplication sharedApplication].applicationIconBadgeNumber == 0) {
        
    }else{
        
        //        NSNotification *mynotification = [NSNotification notificationWithName:@"icon" object:self userInfo:nil];
        //        [[NSNotificationCenter defaultCenter] postNotification:mynotification];
    }
    
    
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:_num + 1];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];   //清除角标
//    [JPUSHService setBadge:0];
//    [JPUSHService resetBadge];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}





- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//支付宝回调接口
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    NSLog(@"支付宝回调接口");
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                NSLog(@"支付成功== %@",resultDic);
                //                NSString* str = [resultDic objectForKey:@"result"];
                //                NSArray *array = [str componentsSeparatedByString:@"&"]; //从字符A中分隔成2个元素的数组
                //                NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
                //                NSString*string =array[2];
                //                NSRange range = [string rangeOfString:@"out_trade_no="];//匹配得到的下标
                //                NSLog(@"rang:%@",NSStringFromRange(range));
                //                NSInteger start = range.length - range.location;
                //                string = [string substringFromIndex:start];//截取范围类的字符串
                //                NSLog(@"截取的值为：%@",string);
                //                NSString* fee = array[5];
                //                NSRange range1 = [fee rangeOfString:@"total_fee="];
                //                NSInteger feestart = range1.length - range1.location;
                //                fee = [fee substringFromIndex:feestart];
                //                NSLog(@"截取的值为fee：%@",fee);
                //                NSString* stopstr = [self replaceAllOthers:string];
                //                NSLog(@"最终字符串：%@",stopstr);
                //                [self shangChuan:string paymethod:@"1" money:fee];
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:AliPayTrue object:nil userInfo:resultDic];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }
        }];
    }
    
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    return [TencentOAuth HandleOpenURL:url];
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    NSLog(@"支付宝新的回调接口");
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",[resultDic objectForKey:@"memo"]);
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                NSLog(@"支付成功== %@",resultDic);
                //                NSString* str = [resultDic objectForKey:@"result"];
                //                NSArray *array = [str componentsSeparatedByString:@"&"]; //从字符A中分隔成2个元素的数组
                //                NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
                //                NSString*string =array[2];
                //                NSRange range = [string rangeOfString:@"out_trade_no="];//匹配得到的下标
                //                NSLog(@"rang:%@",NSStringFromRange(range));
                //                NSInteger start = range.length - range.location;
                //                string = [string substringFromIndex:start];//截取范围类的字符串
                //                NSLog(@"截取的值为：%@",string);
                //                NSString* stopstr = [self replaceAllOthers:string];
                //                NSLog(@"最终字符串：%@",stopstr);
                //                NSString* fee = array[5];
                //                NSRange range1 = [fee rangeOfString:@"total_fee="];
                //                NSInteger feestart = range1.length - range1.location;
                //                fee = [fee substringFromIndex:feestart];
                //                NSLog(@"截取的值为fee：%@",fee);
                //                [self shangChuan:string paymethod:@"1" money:fee];
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:AliPayTrue object:nil userInfo:resultDic];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }
        }];
    }
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    return YES;
}
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    NSSLog(@"旧的支付宝成功");
//    if ([url.host isEqualToString:@"safepay"]) {
//        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
//    }
//    return YES;
//}
//
//// NOTE: 9.0以后使用新API接口
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
//    NSSLog(@"新的支付宝接口");
//    if ([url.host isEqualToString:@"safepay"]) {
//        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
//    }
//    return YES;
//}


//请求到的是字符串需要处理一下
- (NSString *)replaceAllOthers:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    return returnString;
}

#pragma mark - - - - - - 微信openURL
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    return [TencentOAuth HandleOpenURL:url];
}


@end
