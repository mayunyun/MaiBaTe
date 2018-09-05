//
//  WLAddNeedViewController.h
//  MaiBaTe
//
//  Created by LONG on 2018/1/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface WLAddNeedViewController : BaseViewController
@property (nonatomic, copy) void (^needBlock)(NSMutableArray* Arr);
@property (nonatomic,strong)NSArray *needArr;
@end
