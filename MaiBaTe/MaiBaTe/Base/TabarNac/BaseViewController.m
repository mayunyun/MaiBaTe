//
//  BaseViewController.m
//  MaiBaTe
//
//  Created by apple on 17/8/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backToLastViewController:)];
    [self.navigationItem.leftBarButtonItem setTintColor:NavBarItemColor];
    self.view.backgroundColor = UIColorFromRGB(0xEEEEEE);
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x333333);


}

- (void)backToLastViewController:(UIButton *)button
{
    //[Public hideLoadingView];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backBarTitleButtonItemTarget:(id)target action:(SEL)action text:(NSString*)str
{
    UIButton* leftBarBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBarBtn.frame = CGRectMake(10, 0, UIScreenW/2, 40);
    UIImageView* leftBarimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 15, 25)];
    [leftBarimgView setImage:[UIImage imageNamed:@"arrow"]];
    [leftBarBtn addSubview:leftBarimgView];
    UILabel* leftBarLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftBarimgView.right+10, 0, leftBarBtn.width - leftBarimgView.width, 40)];
    leftBarLabel.text = [NSString stringWithFormat:@"%@",str];
    leftBarLabel.textColor = [UIColor whiteColor];
    [leftBarBtn addSubview:leftBarLabel];
    [leftBarBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = left;
    
}


- (void)rightBarTitleButtonTarget:(id)target action:(SEL)action text:(NSString*)str{
    
    NSDictionary* atrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize size1 =  [str boundingRectWithSize:CGSizeMake(UIScreenW - 20.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:atrDict context:nil].size;
    //NSLog(@"size.width=%f, size.height=%f", size1.width, size1.height);
    UIButton* rightBarBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBarBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBarBtn.frame = CGRectMake(0, 0, size1.width, 30);
    [rightBarBtn setTitle:str forState:UIControlStateNormal];
    [rightBarBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
    [rightBarBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* right = [[UIBarButtonItem alloc]initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = right;
}
#pragma mark - 根据字符串计算label高度
- (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(width, 2000);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:10];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat height = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    
    return height;
}




@end
