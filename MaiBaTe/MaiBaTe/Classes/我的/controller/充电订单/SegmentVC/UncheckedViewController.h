//
//  UncheckedViewController.h
//  MaiBaTe
//
//  Created by 钱龙 on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface UncheckedViewController : BaseViewController
@property(nonatomic,strong)void(^hidenSegmentBlock)(NSInteger );
@end
