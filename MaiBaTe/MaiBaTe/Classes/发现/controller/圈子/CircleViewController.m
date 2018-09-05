//
//  CircleViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/10/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CircleViewController.h"

@interface CircleViewController ()


//返回按钮
@property (nonatomic, strong) UIBarButtonItem *barButtonBack;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;
@end

@implementation CircleViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.delegate = self;
    [self loadHTML:self.htmlUrl];

}

@end
