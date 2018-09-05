//
//  AllWuLiuZHViewController.m
//  MaiBaTe
//
//  Created by LONG on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AllWuLiuZHViewController.h"
#import "WULiuZHViewController.h"
#import "CarTypeZHViewController.h"
@interface AllWuLiuZHViewController ()

@end

@implementation AllWuLiuZHViewController

- (NSMutableArray *)childViews
{
    if(_childViews==nil)
    {
        _childViews =[NSMutableArray array];
    }
    return _childViews;
}

- (UIScrollView *)scrollView
{
    if(_scrollView==nil)
    {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 104, UIScreenW, UIScreenH -104)];
        if (statusbarHeight>20) {
            _scrollView.frame = CGRectMake(0, 128, UIScreenW, UIScreenH -128);
        }
        _scrollView.delegate=self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(5 * UIScreenW, 0);
        _scrollView.bounces = NO;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}


- (AllWuLiuZHHeadertitleView *)titleView
{
    if(_titleView==nil)
    {
        _titleView =[AllWuLiuZHHeadertitleView new];
        _titleView.delegate=self;
        _titleView.frame = CGRectMake(0, 64, self.view.frame.size.width, 40);
        if (statusbarHeight>20) {
            _titleView.frame = CGRectMake(0, 88, self.view.frame.size.width, 40);
        }
        [self.view addSubview:_titleView];
    }
    return _titleView;
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
    
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"物流找货.png"]];
    titleImage.frame = CGRectMake(5, 3, 17, 19);
    [titleView addSubview:titleImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 75, 25)];
    titleLab.text = @"物流找货";
    titleLab.textColor = UIColorFromRGB(0x333333);
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    //添加头部的view
    [self titleView];
    
    //添加scrollView
    [self scrollView];
    
    //添加各子控制器
    [self setupChildVcs];
    
}
#pragma mark 添加各子控制器
- (void)setupChildVcs
{
    
    WULiuZHViewController *allVc =[WULiuZHViewController new];
    [self addChildViewController:allVc];
    allVc.city = self.city;
    [self.childViews addObject:allVc.view];
    
    
    CarTypeZHViewController *paymentVc =[CarTypeZHViewController new];
    [self addChildViewController:paymentVc];
    paymentVc.city = self.city;
    [self.childViews addObject:paymentVc.view];
    
    for(int i=0;i<self.childViews.count;i++)
    {
        UIView *childV = self.childViews[i];
        CGFloat childVX = UIScreenW * i ;
        childV.frame = CGRectMake(childVX, 0, UIScreenW, self.view.frame.size.height - _titleView.frame.size.height);
        [_scrollView addSubview:childV];
    }
    
    
}


#pragma mark 滚动条
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.view endEditing:YES];
    
    
    if(scrollView==_scrollView)
    {
        if(_scrollView.contentOffset.x / UIScreenW ==0)
        {
            [_titleView wanerSelected:0];
        }
        else if (_scrollView.contentOffset.x / UIScreenW ==1)
        {
            [_titleView wanerSelected:1];
        }
        
    }
}

#pragma mark titleView的方法
- (void)titleView:(AllWuLiuZHHeadertitleView *)titleView scollToIndex:(NSInteger)tagIndex
{
    
    
    [_scrollView setContentOffset:CGPointMake(tagIndex * UIScreenW, 0) animated:YES];
    
}
- (void)backToLastViewController:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];

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
