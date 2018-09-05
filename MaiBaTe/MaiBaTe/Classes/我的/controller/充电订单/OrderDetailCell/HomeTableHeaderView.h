//
//  HomeTableHeaderView.h
//  BasicFramework
//
//  Created by 钱龙 on 17/12/5.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableHeaderView : UITableViewHeaderFooterView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
@property (nonatomic,assign)NSInteger count;
@property (nonatomic,strong)UILabel * label;
@property (nonatomic,strong)NSString * status;
@property (nonatomic,strong)NSString * wuliu;
@end
