//
//  DianZSQTableViewCell.h
//  MaiBaTe
//
//  Created by 邱 德政 on 17/10/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DianZSQModel.h"
@interface DianZSQTableViewCell : UITableViewCell
@property (nonatomic,strong)void(^btnClickBlock)();
@property(nonatomic,strong)DianZSQModel * data;
@property(nonatomic,strong) UIView *bgview;//背景
@property(nonatomic,strong) UIImageView *cornerImageView;//人物头像
@property(nonatomic,strong) UIImageView *addressImageView;//地址头像
@property(nonatomic,strong) UILabel *titleView;//预约车型
@property(nonatomic,strong) UILabel *statusLabel;//审核状态
@property(nonatomic,strong) UIView *line1View;//分割线1
@property(nonatomic,strong) UILabel *nameLabel;//预约姓名
@property(nonatomic,strong) UILabel *telphoneLabel;//联系电话
//@property(nonatomic,strong) UILabel *timeLabel;//到店时间
@property(nonatomic,strong) UIView *line2View;//分割线2
@property(nonatomic,strong) UILabel *annotateLabel;//注解
@property(nonatomic,strong) UIButton *delBtn;//删除按钮
@property(nonatomic,strong) UIButton *bigdelBtn;//删除按钮

@end
