//
//  NewAllViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NewAllViewController.h"
#import "ZZNetworkTools.h"

@interface NewAllViewController ()<UIWebViewDelegate>

@end

@implementation NewAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.type == 1) {
        self.title = @"新闻详情";
    }else if (self.type == 2){
        self.title = @"活动详情";
    }
    //[self dataRequest];
    [self PageViewDidLoad1];
}
//- (void)dataRequest{
//    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\"}",_model.id]};
//    if (self.type == 2){
//        params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\"}",_huomodel.id]};
//    }
//    NSLog(@">>>%@",params);
//    NSString *XWURLStr;
//    if (self.type == 1) {
//        XWURLStr = @"/mbtwz/index?action=getNewsDetail";
//    }else if (self.type == 2){
//        XWURLStr = @"/mbtwz/index?action=getActivityDetail";
//    }
//    [Command loadDataWithParams:params withPath:XWURLStr completionBlock:^(id responseObject, NSError *error) {
//        NSLog(@"最新%@",responseObject);
//        if (responseObject) {
//
//        }
//
//    } autoShowError:YES];
//
//
//}
- (void)PageViewDidLoad1
{
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, UIScreenW, 50)];
    if (statusbarHeight>20) {
        self.titleLab.frame = CGRectMake(0, 88, UIScreenW, 50);
    }
    self.titleLab.numberOfLines = 0;
    self.titleLab.font = [UIFont boldSystemFontOfSize:17];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLab];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, self.titleLab.bottom, UIScreenW, UIScreenH-self.titleLab.height-64)];
    if (statusbarHeight>20) {
        _webView.frame = CGRectMake(0, self.titleLab.bottom, UIScreenW, UIScreenH-self.titleLab.height-88);
    }
    [self.view addSubview:_webView];
    
    NSString* linkCss = @"<style type=\"text/css\"> img {"
    "width:100%;"
    "height:auto;"
    "}"
    "</style>";
    
    if (self.type == 1) {
        self.titleLab.text = _model.title;
        [_webView loadHTMLString:[NSString stringWithFormat:@"%@%@",self.model.note,linkCss] baseURL:[NSURL URLWithString:WEB_ADDRESS]];
    }else if (self.type == 2){
        
        self.titleLab.text = [NSString stringWithFormat:@"%@",self.huomodel.activityname];
        [_webView loadHTMLString:[NSString stringWithFormat:@"%@%@",self.huomodel.note,linkCss] baseURL:[NSURL URLWithString:WEB_ADDRESS]];
    }
    
    self.webView.delegate = self;
    //新闻内容的Label的自适应大小
    [self.webView sizeToFit];
    self.webView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    
    
}
//设置字体大小

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //修改百分比即可
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '40%'"];
    
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

