//
//  HomeTableHeaderView.m
//  BasicFramework
//
//  Created by 钱龙 on 17/12/5.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import "HomeTableHeaderView.h"

@implementation HomeTableHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *headerID = @"HomeTableHeaderView";
    HomeTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (headerView == nil) {
        
        headerView = [[HomeTableHeaderView alloc]initWithReuseIdentifier:headerID];
        
    }
    return headerView;
}
-(void)setWuliu:(NSString *)wuliu{
    _wuliu = wuliu;
    //    NSLog(@"+++++++++++++%ld",_count);
    _label.text = _wuliu;
    _label.frame = CGRectMake(SCREEN_WIDTH/2-100, 10, 200, 30);
    _label.textAlignment = NSTextAlignmentCenter;
}
-(void)setCount:(NSInteger)count
{
    _count = count;
//    NSLog(@"+++++++++++++%ld",_count);
    _label.text = [NSString stringWithFormat:@"车型需求(%ld)",(long)_count];
}
-(void)setStatus:(NSString *)status{
    _status = status;
    _label.text = [NSString stringWithFormat:@"%@",_status];
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        //添加头(尾)视图中的控件
        _label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 200, 30)];
        _label.text = [NSString stringWithFormat:@"车型需求(%ld)",(long)_count];
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = [UIColor lightGrayColor];
        _label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_label];
    }
    return self;
}
@end
