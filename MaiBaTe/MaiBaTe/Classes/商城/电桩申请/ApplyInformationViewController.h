//
//  ApplyInformationViewController.h
//  MaiBaTe
//
//  Created by 邱 德政 on 17/10/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "DianZSQModel.h"
@interface ApplyInformationViewController : BaseViewController
@property (nonatomic,strong)NSString * strtitle;
@property (nonatomic,strong)DianZSQModel * model;

@property (nonatomic,strong)NSString * idString;
@property (nonatomic,strong)NSString * provinceName;
@property (nonatomic,strong)NSString * cityName;
@property (nonatomic,strong)NSString * townName;
@end
