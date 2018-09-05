//
//  WLTYProtocolViewController.m
//  MaiBaTe
//
//  Created by LONG on 2018/1/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WLTYProtocolViewController.h"

@interface WLTYProtocolViewController ()<UIWebViewDelegate>

@end

@implementation WLTYProtocolViewController{
    UIWebView *_webView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 64)];
    bgview.userInteractionEnabled = YES;
    bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, UIScreenW, 44)];
    titleLab.text = @"货物托运服务协议";
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.userInteractionEnabled = YES;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = UIColorFromRGB(0x333333);
    [bgview addSubview:titleLab];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(18, 15, 15, 15)];
    imageview.image = [UIImage imageNamed:@"关闭_1"];
    imageview.userInteractionEnabled = YES;
    [titleLab addSubview:imageview];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    [but addTarget:self action:@selector(butClick) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:but];
    
    [self loadNew];
}
#pragma 刷新(在这里面发送请求，刷新数据)
- (void)loadNew
{
    
    //
    NSString *XWURLStr = @"/mbtwz/logisticssendwz?action=searchCarDeal";
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [HTNetWorking postWithUrl:XWURLStr refreshCache:YES params:nil success:^(id response) {
        [SVProgressHUD dismiss];
        
        NSArray *Arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@">>%@",Arr);
        if (Arr.count) {
            
            [self PageViewDidLoad1:[Arr[0] objectForKey:@"content"]];
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
    
    
}
- (void)PageViewDidLoad1:(NSString *)content
{
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(15*MYWIDTH, 64+15*MYWIDTH, UIScreenW-30*MYWIDTH, UIScreenH-64-30*MYWIDTH)];
    if (statusbarHeight>20) {
        bgview.frame = CGRectMake(15*MYWIDTH, 88+15*MYWIDTH, UIScreenW-30*MYWIDTH, UIScreenH-88-30*MYWIDTH);
    }
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.layer.cornerRadius = 10; 
    bgview.layer.masksToBounds = YES;
    [self.view addSubview:bgview];
    
    NSString* linkCss = @"<style type=\"text/css\"> img {"
    "width:100%;"
    "height:auto;"
    "}"
    "</style>";
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, bgview.width, bgview.height)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
//    NSString* baseurl = [NSString stringWithFormat:@"%@/mbtwz/logisticssendwz?action=searchCarDeal",WEB_ADDRESS];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:baseurl]]];
    [_webView loadHTMLString:[NSString stringWithFormat:@"%@%@",content,linkCss] baseURL:[NSURL URLWithString:WEB_ADDRESS]];

    [bgview addSubview:_webView];
    
    
    
    
}
//设置字体大小

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];

    //修改百分比即可
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '40%'"];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //    NSLog(@"webViewDidStartLoad");
    //进度HUD
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nonnull NSError *)error
{
    //    NSLog(@"didFailLoadWithError===%@", error);
    
}
- (void)butClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
