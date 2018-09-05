//
//  CarNumerModel.h
//  MaiBaTe
//
//  Created by LONG on 17/9/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CarNumerModel : JSONModel
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString *totalcount;
@property (nonatomic,strong)NSString *totalrealmoney;
/*
 {
 time = 0;
 totalcount = "0.0000";
 totalrealmoney = "0.0000";
 }
 */


@end
