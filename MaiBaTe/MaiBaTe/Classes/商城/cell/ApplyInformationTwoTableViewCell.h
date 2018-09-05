//
//  ApplyInformationTwoTableViewCell.h
//  MaiBaTe
//
//  Created by 邱 德政 on 17/10/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyInformationTwoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *provenceBtn;
@property (strong, nonatomic) IBOutlet UIButton *cityBtn;
@property (strong, nonatomic) IBOutlet UIButton *townBtn;
@property (strong, nonatomic) IBOutlet UITextField *detailAddressTf;
@property (strong, nonatomic) IBOutlet UITextField *postCodeTf;
@property (strong, nonatomic) IBOutlet UIView *bgview;

@property(nonatomic,strong)void(^provenceBtnBlock)();
@property (nonatomic,strong)void(^cityBtnBlock)();
@property(nonatomic,strong)void(^townBtnBlock)();
@end
