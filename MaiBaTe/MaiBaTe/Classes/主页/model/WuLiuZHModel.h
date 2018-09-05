//
//  WuLiuZHModel.h
//  MaiBaTe
//
//  Created by LONG on 2018/1/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface WuLiuZHModel : JSONModel

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *owner_orderno;
@property (nonatomic,strong)NSString *owner_link_phone;
@property (nonatomic,strong)NSString *owner_totalprice;
@property (nonatomic,strong)NSString *owner_link_name;
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *longitude;
@property (nonatomic,strong)NSString *latitude;
@property (nonatomic,strong)NSString *owner_send_address;
@property (nonatomic,strong)NSString *owner_sendtime;
@property (nonatomic,strong)NSString *car_type;
@property (nonatomic,strong)NSString *owner_address;
@property (nonatomic,strong)NSString *autoname;
@property (nonatomic,strong)NSString *siji_money;

@property (nonatomic,strong)NSString *appointmenttime;
@property (nonatomic,strong)NSString *cargotypenames;
@property (nonatomic,strong)NSString *contactname;
@property (nonatomic,strong)NSString *contactphone;
@property (nonatomic,strong)NSString *endaddress;
@property (nonatomic,strong)NSString *orderno;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *startaddress;
@property (nonatomic,strong)NSString *startlatitude;
@property (nonatomic,strong)NSString *startlongitude;


/*
 {
 id = 172;
 owner_orderno = "SDD201801110014";
 owner_link_phone = "18764028565";
 owner_totalprice = 3.79;
 owner_link_name = "发过火";
 folder = "customerImages";
 longitude = 117.000923;
 latitude = 36.675807;
 owner_send_address = "山东省济南市历下区东关街道东青龙街长盛小区北区";
 owner_sendtime = "2018-01-11 10:45:00";
 car_type = "小面包车";
 owner_address = "山东省济南市天桥区天桥东街街道济南市天桥区物价局";
 autoname = "aaa1699f3a0f4d289a0fa22be92fc343.png"
 }
 */
@end
