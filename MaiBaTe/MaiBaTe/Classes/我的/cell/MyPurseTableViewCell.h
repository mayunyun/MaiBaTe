//
//  MyPurseTableViewCell.h
//  MaiBaTe
//
//  Created by LONG on 17/8/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPurseTableViewCell : UITableViewCell
@property(nonatomic,strong) UIImageView *bgview;//背景
@property(nonatomic,strong) UIImageView *iconView;//头像
@property(nonatomic,strong) UILabel *titleView;//标题
@property(nonatomic,strong) UILabel *otherView;//金额

- (void)setdata:(NSString *)title;

@end
