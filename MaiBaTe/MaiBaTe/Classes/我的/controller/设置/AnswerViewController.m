//
//  AnswerViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/9/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AnswerViewController.h"

@interface AnswerViewController ()
{
    UITextView* _qusTextView;
}
@end

@implementation AnswerViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"NarBg"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
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
    self.navigationItem.title = @"意见和建议";
    [self creatUI];
}
- (void)creatUI{
    UIScrollView* bgsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
    bgsView.contentSize = CGSizeMake(UIScreenW, 500*GMYWIDTH);
    bgsView.backgroundColor = [UIColor clearColor];
    bgsView.bounces = NO;
    bgsView.showsVerticalScrollIndicator = NO;
    bgsView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bgsView];
    
    UIImageView* headerimgView = [[UIImageView alloc]initWithFrame:CGRectMake((UIScreenW - 192*GMYWIDTH)*0.5, 48*GMYWIDTH, 192*GMYWIDTH, 12*GMYWIDTH)];
    headerimgView.backgroundColor = [UIColor clearColor];
    headerimgView.contentMode = UIViewContentModeScaleAspectFit;
    headerimgView.image = [UIImage imageNamed:@"意见与建议"];
    [bgsView addSubview:headerimgView];
    UIImageView* orimgView = [[UIImageView alloc]initWithFrame:CGRectMake((UIScreenW - 13*GMYWIDTH)*0.5,headerimgView.bottom + 15*GMYWIDTH, 13*GMYWIDTH, 4*GMYWIDTH)];
    orimgView.backgroundColor = UIColorFromRGB(0xffb400);
    [bgsView addSubview:orimgView];
    
    UIImageView* upView = [[UIImageView alloc]initWithFrame:CGRectMake((UIScreenW - 301.5*GMYWIDTH)*0.5, orimgView.bottom+15*GMYWIDTH, 301.5*GMYWIDTH, 274*GMYWIDTH)];
    upView.userInteractionEnabled = YES;
    upView.layer.masksToBounds = YES;
    upView.layer.cornerRadius = 7.5*GMYWIDTH;
    upView.backgroundColor = UIColorFromRGB(0xffffff);
    [bgsView addSubview:upView];
    
    _qusTextView = [[UITextView alloc]initWithFrame:CGRectMake((upView.width - 270*GMYWIDTH)*0.5, (upView.height - 220*GMYWIDTH)*0.5, 270*GMYWIDTH, 220*GMYWIDTH)];
    _qusTextView.font = [UIFont systemFontOfSize:13*GMYWIDTH];
    _qusTextView.layer.borderWidth = 1;
    _qusTextView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    [upView addSubview:_qusTextView];
    
    UIButton* okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    okBtn.frame = CGRectMake((UIScreenW - 230*GMYWIDTH)*0.5, upView.bottom+34*GMYWIDTH, 230*GMYWIDTH, 41*GMYWIDTH);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setBackgroundColor:UIColorFromRGB(0xffb400)];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16*GMYWIDTH];
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.cornerRadius = 3;
    [bgsView addSubview:okBtn];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    

}

- (void)okBtnClick:(UIButton*)sender{
    if (!IsEmptyValue(_qusTextView.text)) {
        [self dataRequest];
    }else{
        jxt_showToastTitle(@"提交问题为空哦", 1);
    }

}

- (void)dataRequest{
    /*
     /mbtwz/wxcustomer?action=addAdvice
     参数：content  custphone   放在data中
     */
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSString* phone= [[NSUserDefaults standardUserDefaults]objectForKey:USERPHONE];
    NSString* urlstr = @"/mbtwz/wxcustomer?action=addAdvice";
    _qusTextView.text = [Command convertNull:_qusTextView.text];
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"content\":\"%@\",\"custphone\":\"%@\"}",_qusTextView.text,phone]};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id response) {
        [SVProgressHUD dismiss];
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSSLog(@"意见提交>>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            jxt_showToastTitle(@"意见提交失败", 1);
        }
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end
