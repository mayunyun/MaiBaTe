//
//  GetCarInfoView.m
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "GetCarInfoView.h"

@implementation GetCarInfoView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *headerID = @"GetCarInfoView";
    GetCarInfoView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (headerView == nil) {
        
        headerView = [[GetCarInfoView alloc]initWithReuseIdentifier:headerID];
        
    }
    return headerView;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        //添加头(尾)视图中的控件
        UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 40)];
        footerView.backgroundColor = [UIColor whiteColor];
        footerView.layer.cornerRadius = 8.f;
        footerView.layer.masksToBounds = YES;
        [self addSubview:footerView];
        UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0, 0, footerView.width, footerView.height);
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setTitle:@"查看更多" forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:15];
        [but addTarget:self action:@selector(moreClicked) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:but];
    }
    return self;
}
-(void)moreClicked{
    if (_moreBtnBlock) {
        self.moreBtnBlock();
    }
}
@end
