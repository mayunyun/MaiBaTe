//
//  YuYueTableViewCell.h
//  MaiBaTe
//
//  Created by 钱龙 on 17/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyApplyModel.h"
@interface YuYueTableViewCell : UITableViewCell
@property (nonatomic,strong)void(^btnClickBlock)();
@property(nonatomic,strong)MyApplyModel * data;
@property(nonatomic,strong) UIView *bgview;//背景
@property(nonatomic,strong) UILabel *cornerLabel;//圆点
@property(nonatomic,strong) UILabel *titleView;//预约车型
@property(nonatomic,strong) UILabel *statusLabel;//审核状态
@property(nonatomic,strong) UIView *line1View;//分割线1
@property(nonatomic,strong) UILabel *nameLabel;//预约姓名
@property(nonatomic,strong) UILabel *telphoneLabel;//联系电话
@property(nonatomic,strong) UILabel *timeLabel;//到店时间
@property(nonatomic,strong) UIView *line2View;//分割线2
@property(nonatomic,strong) UILabel *annotateLabel;//注解
//@property(nonatomic,strong) UIButton *delBtn;//删除按钮

@end
