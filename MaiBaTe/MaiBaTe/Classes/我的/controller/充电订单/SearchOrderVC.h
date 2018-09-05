//
//  SearchOrderVC.h
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchOrderVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *orderNumTf;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UIButton *timeBut;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (nonatomic,strong)NSString * orderstatus;
@property (nonatomic,strong)void(^searchDataBlock)(NSMutableArray *);
@end
