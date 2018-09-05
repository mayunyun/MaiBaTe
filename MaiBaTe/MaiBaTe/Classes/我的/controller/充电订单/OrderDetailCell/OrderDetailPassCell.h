//
//  OrderDetailPassCell.h
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailPassCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic,strong)NSDictionary * dic;
@end
