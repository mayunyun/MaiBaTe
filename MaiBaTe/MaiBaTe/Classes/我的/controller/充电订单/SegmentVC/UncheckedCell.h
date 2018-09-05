//
//  UncheckedCell.h
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UncheckedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *needLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sanjiaoImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,strong)NSDictionary * dataDic;
@end
