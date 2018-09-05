//
//  ZuLinCarTableViewCell.h
//  MaiBaTe
//
//  Created by LONG on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZuLinModel.h"
@interface ZuLinCarTableViewCell : UITableViewCell
@property(nonatomic,strong) ZuLinModel *data;
@property(nonatomic,strong) UIButton *xiangqingbut;//详情

- (void)setdata:(ZuLinModel *)data;
@end
