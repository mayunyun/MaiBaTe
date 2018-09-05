//
//  GetCarInfoView.h
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetCarInfoView : UITableViewHeaderFooterView
@property (nonatomic,strong)void(^moreBtnBlock)(void);
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
@end
