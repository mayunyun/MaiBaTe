//
//  CarRentalViewController.m
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CarRentalViewController.h"
#import "JohnTopTitleView.h"
#import "UncheckedViewController.h"
#import "CheckedViewController.h"
#import "SearchOrderVC.h"
@interface CarRentalViewController ()
@property (nonatomic,strong) JohnTopTitleView *titleView;
@property (nonatomic,strong)NSString * orderStatus;
@property (nonatomic,assign)NSInteger index;
@end

@implementation CarRentalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"租赁订单";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"1.3"] style:UIBarButtonItemStylePlain target:self action:@selector(rightToLastViewController)];
    [self.navigationItem.rightBarButtonItem setTintColor:UIColorFromRGB(0xFFFFFF)];
    [self createUI];
    [_titleView setIndexPageBlock:^(NSInteger index) {
        _index = index;
        
    }];
    
}
- (void)createUI{
    NSArray *titleArray = [NSArray arrayWithObjects:@"未审核",@"已审核", nil];
    self.titleView.title = titleArray;
//    self.titleView.titleSegment.selectedSegmentIndex = 0;
    [self.titleView setupViewControllerWithFatherVC:self childVC:[self setChildVC]];
    [self.view addSubview:self.titleView];
}

- (NSArray <UIViewController *>*)setChildVC{
    UncheckedViewController * vc1 = [[UncheckedViewController alloc]init];
//    [vc1 setHidenSegmentBlock:^(NSInteger index) {
//        
//    }];
    CheckedViewController *vc2 = [[CheckedViewController alloc]init];
    NSArray *childVC = [NSArray arrayWithObjects:vc1,vc2, nil];
    return childVC;
}
#pragma mark - getter
- (JohnTopTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[JohnTopTitleView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _titleView;
}
-(void)rightToLastViewController{
    SearchOrderVC * vc = [[SearchOrderVC alloc]init];
    vc.orderstatus = [NSString stringWithFormat:@"%zd",_index];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)backToLastViewController:(UIButton *)button{
    if ([self.push isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
