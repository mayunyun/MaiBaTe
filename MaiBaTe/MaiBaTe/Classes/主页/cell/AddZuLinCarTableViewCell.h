//
//  AddZuLinCarTableViewCell.h
//  MaiBaTe
//
//  Created by LONG on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddZuLinModel.h"
@interface AddZuLinCarTableViewCell : UITableViewCell

@property(nonatomic,strong)AddZuLinModel *model;
@property(nonatomic,strong) UIButton *deleteBut;//删除
@property(nonatomic,strong) NSMutableArray *CArr;//长租
@property(nonatomic,strong) NSMutableArray *DArr;//短租
@property(nonatomic,strong) NSArray *NameArr;//车辆型号

- (void)setdata:(NSInteger)count;

@end
