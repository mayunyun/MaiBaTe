//
//  SearchWuliuOrderVC.h
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchWuliuOrderVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITextField *orderNo;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UIButton *orderType;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (nonatomic,strong)NSString * orderTypeString;
@property (nonatomic,assign)int  carTypeint;

@end
