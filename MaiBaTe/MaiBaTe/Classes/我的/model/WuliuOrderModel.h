//
//  WuliuOrderModel.h
//  MaiBaTe
//
//  Created by 钱龙 on 2018/1/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface WuliuOrderModel : JSONModel
@property (nonatomic,strong)NSString *siji_money;
@property (nonatomic,strong)NSString *driver_custid;//司机id
@property (nonatomic,strong)NSString *total_mileage;//总里程
@property (nonatomic,strong)NSString *owner_address;//起点
@property (nonatomic,strong)NSString *money_status;
@property (nonatomic,strong)NSString *driver_orderstatus;//司机端订单状态
@property (nonatomic,strong)NSString *owner_starting_price;//起步价
@property (nonatomic,strong)NSString *latitude;
@property (nonatomic,strong)NSString *send_longitude;
@property (nonatomic,strong)NSString *cust_orderstatus;//货主端订单状态
@property (nonatomic,strong)NSString *owner_paymethod;//支付类型
@property (nonatomic,strong)NSString *pay_no;
@property (nonatomic,strong)NSString *owner_custid;//客户id
@property (nonatomic,strong)NSString *id;//主键id
@property (nonatomic,strong)NSString *owner_note;//订单备注
@property (nonatomic,strong)NSString *owner_createtime;
@property (nonatomic,strong)NSString *owner_send_address;//目的地
@property (nonatomic,strong)NSString *owner_sendtime;//货主发货时间
@property (nonatomic,strong)NSString *owner_totalprice;//订单总价
@property (nonatomic,strong)NSString *longitude;
@property (nonatomic,strong)NSString *send_latitude;
@property (nonatomic,strong)NSString *owner_orderno;//订单号
@property (nonatomic,strong)NSString *owner_link_phone;//联系人电话
@property (nonatomic,strong)NSString *pingtai_money;
@property (nonatomic,strong)NSString *car_type;//车型
@property (nonatomic,strong)NSString *owner_mileage_price;//超出历程价格
@property (nonatomic,strong)NSString *siji_findtime;//司机接单时间
@property (nonatomic,strong)NSString *driver_phone;//司机联系方式
@property (nonatomic,strong)NSString *driver_name;//司机姓名
@property (nonatomic,strong)NSString *owner_link_name;//联系人名字
@property (nonatomic,strong)NSString *owner_cartype_id;//车型id
@property (nonatomic,strong)NSString *owner_ispay;//支付是否完成 0否 1是
@property (nonatomic,strong)NSString *folder;
@property (nonatomic,strong)NSString *autoname;

@property (nonatomic,strong)NSString *orderno;
@property (nonatomic,strong)NSString *contactname;
@property (nonatomic,strong)NSString *contactphone;
@property (nonatomic,strong)NSString *cargotypenames;
@property (nonatomic,strong)NSString *sposition;
@property (nonatomic,strong)NSString *startaddress;
@property (nonatomic,strong)NSString *endaddress;
@property (nonatomic,strong)NSString *createtime;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *appointmenttime;
@property (nonatomic,strong)NSString *floorhousenumber;
@property (nonatomic,strong)NSString *headimg;
@property (nonatomic,strong)NSString *volume;
@property (nonatomic,strong)NSString *remarks;
@property (nonatomic,strong)NSArray *imgList;
@property (nonatomic,strong)NSString *drivername;
@property (nonatomic,strong)NSString *driverphone;


@end
