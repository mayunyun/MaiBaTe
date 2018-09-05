//
//  ChargeSouSuoViewController.h
//  MaiBaTe
//
//  Created by LONG on 17/9/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface ChargeSouSuoViewController : BaseViewController

@property (nonatomic, copy)void(^block)(NSString *createtime,NSString *endtime);

@end
