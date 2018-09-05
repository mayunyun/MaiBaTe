//
//  ChargingModel.h
//  MaiBaTe
//
//  Created by LONG on 17/8/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ChargingModel : JSONModel

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *uuid;
@property (nonatomic,strong)NSString *orderstatus;//订单状态(0：正在充电  1：充电完成)
@property (nonatomic,strong)NSString *createtime;//创建时间
@property (nonatomic,strong)NSString *endtime;//充电结束时间
@property (nonatomic,strong)NSString *count;//充电度数
@property (nonatomic,strong)NSString *custid;//客户ID
@property (nonatomic,strong)NSString *orderno;//订单号
@property (nonatomic,strong)NSString *electricsbm;//充电口识别码
@property (nonatomic,strong)NSString *totalmoney;//总钱数
@property (nonatomic,strong)NSString *realmoney;//实际钱数
@property (nonatomic,strong)NSString *note;//备注

/*
 {
 uuid = "";
 orderstatus = 1;
 id = 4;
 createtime = "2017-09-01 01:00:43";
 note = "3";
 count = 1111;
 endtime = "2017-09-01 11:43:11";
 electricname = "";
 custid = 62;
 orderno = "525K632G500";
 maxcount = 0;
 totalmoney = 12222;
 electricsbm = "525K632G111";
 realmoney = 2222
	}
 */
@end
