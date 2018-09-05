//
//  AllWuLiuOrderViewController.m
//  MaiBaTe
//
//  Created by LONG on 2018/4/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AllWuLiuOrderViewController.h"
#import "CarTypeOrderViewController.h"
#import "WuLiuOrderViewController.h"
#import "SearchWuliuOrderVC.h"

@interface AllWuLiuOrderViewController ()

@end

@implementation AllWuLiuOrderViewController
{
    int i;
}
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


- (WuLiuOrderHeaderTitleView *)titleView
{
    if(_titleView==nil)
    {
        _titleView =[WuLiuOrderHeaderTitleView new];
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
    // Do any additional setup after loading the view.
    i=0;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"物流订单Nar.png"]];
    titleImage.frame = CGRectMake(5, 3, 17, 19);
    [titleView addSubview:titleImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 75, 25)];
    titleLab.text = @"物流订单";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    self.navigationItem.titleView = titleView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"1.3"] style:UIBarButtonItemStylePlain target:self action:@selector(rightToLastViewController)];
    [self.navigationItem.rightBarButtonItem setTintColor:UIColorFromRGB(0xFFFFFF)];
    //添加头部的view
    [self titleView];
    
    //添加scrollView
    [self scrollView];
    
    //添加各子控制器
    [self setupChildVcs];
    
}
-(void)rightToLastViewController{
    SearchWuliuOrderVC * vc = [[SearchWuliuOrderVC alloc]init];
    vc.orderTypeString = @"物流发货单";
    vc.carTypeint = i;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 添加各子控制器
- (void)setupChildVcs
{
    
    WuLiuOrderViewController *allVc =[WuLiuOrderViewController new];
    [self addChildViewController:allVc];
    allVc.stitle = self.stitle;
    [self.childViews addObject:allVc.view];
    
    
    CarTypeOrderViewController *paymentVc =[CarTypeOrderViewController new];
    [self addChildViewController:paymentVc];
    paymentVc.stitle = self.stitle;
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
            i=0;
        }
        else if (_scrollView.contentOffset.x / UIScreenW ==1)
        {
            [_titleView wanerSelected:1];
            i=1;
        }
        
    }
}

#pragma mark titleView的方法
- (void)titleView:(WuLiuOrderHeaderTitleView *)titleView scollToIndex:(NSInteger)tagIndex
{
    
    i=tagIndex;
    [_scrollView setContentOffset:CGPointMake(tagIndex * UIScreenW, 0) animated:YES];
    
}
- (void)backToLastViewController:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
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
