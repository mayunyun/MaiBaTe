//
//  MyCarTableViewCell.h
//  MaiBaTe
//
//  Created by LONG on 2017/10/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCarModel.h"
@interface MyCarTableViewCell : UITableViewCell
@property(nonatomic,strong) MyCarModel *data;
@property(nonatomic,strong) UIButton *deleteBut;

- (void)setData:(MyCarModel *)data;

@end
