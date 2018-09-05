//
//  OrderDetailHeadCell.h
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *OrderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *OrderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *needCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sanjaoImageV;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property(nonatomic,strong)NSDictionary * dic;

@end
