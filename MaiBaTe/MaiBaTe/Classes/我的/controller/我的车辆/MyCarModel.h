//
//  MyCarModel.h
//  MaiBaTe
//
//  Created by LONG on 2017/10/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MyCarModel : JSONModel
@property (nonatomic,strong)NSString *maxway;
@property (nonatomic,strong)NSString *engine;
@property (nonatomic,strong)NSString *note;
@property (nonatomic,strong)NSString *cartype;
@property (nonatomic,strong)NSString *custid;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *custphone;
@property (nonatomic,strong)NSString *power;
@property (nonatomic,strong)NSString *maxspeed;
@property (nonatomic,strong)NSString *maxpeople;
@property (nonatomic,strong)NSString *chesu;
@property (nonatomic,strong)NSString *zongdianya;
@property (nonatomic,strong)NSString *zongdianliu;
@property (nonatomic,strong)NSString *wendu;

/*
{
 maxpeople = "奥迪";
 maxspeed = "0";
 id = 44;
 zongdianliu = 0;
 note = "0";
 chesu = 0;
 engine = "0";
 custid = 62;
 zongdianya = 0;
 cartype = "鲁A.88888";
 power = "0";
 carno = "";
 wendu = 0;
 custphone = "17663080550";
 maxway = "0"
}
 */
@end
