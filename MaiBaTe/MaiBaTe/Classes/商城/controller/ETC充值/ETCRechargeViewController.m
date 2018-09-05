//
//  ETCRechargeViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/11/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ETCRechargeViewController.h"

@interface ETCRechargeViewController ()<UIWebViewDelegate>
{
    UIWebView* _webView;
}


@end

@implementation ETCRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"ETC充值";

    [self creatUI];
}

- (void)creatUI{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSString* baseurl = @"http://124.128.225.21:28003/WebRoot/sglzfp.jsp";
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:baseurl]]];
    
}



- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [SVProgressHUD dismiss];
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

@end
