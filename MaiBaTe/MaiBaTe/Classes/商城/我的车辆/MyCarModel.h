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

/*
{
    maxway = "35";
    engine = "1563ygdty";
    note = "";
    cartype = "济南";
    custid = 62;
    id = 9;
    custphone = "17663080550";
    power = "13";
    maxspeed = "12";
    maxpeople = "2"
}
 */
@end
