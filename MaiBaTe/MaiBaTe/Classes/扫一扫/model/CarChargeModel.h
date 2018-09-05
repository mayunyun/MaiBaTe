//
//  CarChargeModel.h
//  MaiBaTe
//
//  Created by LONG on 17/9/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CarChargeModel : JSONModel
@property (nonatomic,strong)NSString *orderid;
@property (nonatomic,strong)NSString *orderno;
@property (nonatomic,strong)NSString *createtime;
@property (nonatomic,strong)NSString *electricsbm;
@property (nonatomic,strong)NSString *electricno;
@property (nonatomic,strong)NSString *count;
@property (nonatomic,strong)NSString *realmoney;

/*
 [{"orderid":128,"orderno":"DD201709060027","createtime":"2017-09-06 14:54:55","electricsbm":"sbm0001","electricno":"865067024562509","count":0,"realmoney":0}]
 */

@end
