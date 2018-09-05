//
//  WULiuZHViewCell.h
//  MaiBaTe
//
//  Created by LONG on 2018/1/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WuLiuZHModel.h"
@interface WULiuZHViewCell : UITableViewCell<AMapSearchDelegate>
@property(nonatomic,strong)WuLiuZHModel *dataModel;
@property(nonatomic,strong)UIViewController *controller;
@property (nonatomic, strong) AMapSearchAPI *search;

- (void)setwithDataModel:(WuLiuZHModel *)dataModel locationStr:(CLLocationCoordinate2D)location;

@end
