//
//  ZuLinModel.h
//  MaiBaTe
//
//  Created by LONG on 2017/12/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZuLinModel : JSONModel

@property (nonatomic,strong)NSString *battery_type;
@property (nonatomic,strong)NSString *rated_weight;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *electric_mac_type;
@property (nonatomic,strong)NSString *car_price;
@property (nonatomic,strong)NSString *car_space;
@property (nonatomic,strong)NSString *car_outside_color;
@property (nonatomic,strong)NSString *typename;
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *car_inside_color;
@property (nonatomic,strong)NSString *car_drive;
@property (nonatomic,strong)NSString *cityname;
@property (nonatomic,strong)NSString *uuid;
@property (nonatomic,strong)NSString *max_weight;
@property (nonatomic,strong)NSString *car_configure;
@property (nonatomic,strong)NSString *year_price;
@property (nonatomic,strong)NSString *max_power;
@property (nonatomic,strong)NSString *isvalid;
@property (nonatomic,strong)NSString *charge_type;
@property (nonatomic,strong)NSString *autoname;
@property (nonatomic,strong)NSString *picname;
@property (nonatomic,strong)NSString *car_electricity;
@property (nonatomic,strong)NSString *car_weight;
@property (nonatomic,strong)NSString *inside_size;
@property (nonatomic,strong)NSString *outside_size;
@property (nonatomic,strong)NSString *car_load;
@property (nonatomic,strong)NSString *car_type;
@property (nonatomic,strong)NSString *car_people;
@property (nonatomic,strong)NSString *moon_price;
@property (nonatomic,strong)NSString *car_extension_mileage;
@property (nonatomic,strong)NSString *car_name;
@property (nonatomic,strong)NSString *charge_time;
@property (nonatomic,strong)NSString *rated_power;

/*
 battery_type = "锂电池";
 rated_weight = 1500;
 id = 9;
 electric_mac_type = "涡轮增压";
 car_price = 56000;
 car_space = "";
 car_outside_color = "";
 typename = "物流车";
 folder = "leasemodelimages/";
 car_inside_color = "";
 car_drive = "";
 cityname = "济南市";
 uuid = "72dfc2c1-a9d7-461f-8638-a95479615816";
 max_weight = 2000;
 car_configure = "";
 year_price = 5000;
 max_power = 80;
 isvalid = 1;
 charge_type = "直冲";
 autoname = "8c29fb96b5ad4e16838af5ef0ba36188.jpg";
 picname = "banner04.jpg";
 car_electricity = 8900;
 car_weight = 300;
 inside_size = "";
 outside_size = "100*300*800";
 car_load = 0;
 car_type = 6;
 car_people = 0;
 moon_price = 500;
 car_extension_mileage = 1000;
 car_name = "奥迪A8";
 charge_time = 24;
 rated_power = 60
 */
@end
