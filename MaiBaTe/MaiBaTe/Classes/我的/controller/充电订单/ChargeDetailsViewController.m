//
//  ChargeDetailsViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ChargeDetailsViewController.h"

@interface ChargeDetailsViewController ()
{
    UILabel *_dushu;
}

@end

@implementation ChargeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"账单详情";
    [self setChargeDetailsUIView];

}
- (void)setChargeDetailsUIView{
    
    UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, UIScreenW, 250*MYWIDTH)];
    bgimage.image = [UIImage imageNamed:@"余额背景"];
    [self.view addSubview:bgimage];
    
    UIImageView *headBg = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW/2 - bgimage.height/4, bgimage.height/4, bgimage.height/2, bgimage.height/2)];
    headBg.image = [UIImage imageNamed:@"dushuBG"];
    [bgimage addSubview:headBg];
    
    //
    _dushu = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, headBg.width, headBg.height)];
    _dushu.text = [NSString stringWithFormat:@" %@°",_model.count];
    _dushu.textColor = UIColorFromRGB(MYColor);
    _dushu.font = [UIFont systemFontOfSize:40*MYWIDTH];
    _dushu.textAlignment = NSTextAlignmentCenter;
    [headBg addSubview:_dushu];
    //
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, bgimage.bottom, UIScreenW, 30*MYWIDTH)];
    grayView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:grayView];
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(UIScreenW/2, 3, 0.5, 30*MYWIDTH-6)];
    xian.backgroundColor = UIColorFromRGB(0xF4F4F4);
    [grayView addSubview:xian];
    
    NSString *dushuStr = [NSString stringWithFormat:@"充电%@度",_model.count];
    NSString *timeStr = [NSString stringWithFormat:@"%@",_model.createtime];
    NSArray *strArr = @[dushuStr,timeStr];
    for (int i=0; i<2; i++) {
        UILabel *strLab = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW/2*i, 0, UIScreenW/2, 30*MYWIDTH)];
        strLab.text = strArr[i];
        strLab.textColor = [UIColor whiteColor];
        strLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
        strLab.textAlignment = NSTextAlignmentCenter;
        [grayView addSubview:strLab];
    }
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, UIScreenH/5*3, UIScreenW-60*MYWIDTH, 150*MYWIDTH)];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 8.0;
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    NSArray *titleArr = @[@"订单号:",@"终端设备号:",@"充电时间:"];
    for (int i=0; i<titleArr.count; i++) {
        UILabel *strLab = [[UILabel alloc]initWithFrame:CGRectMake(25*MYWIDTH, whiteView.height/3*i, 80*MYWIDTH, 50*MYWIDTH)];
        strLab.text = titleArr[i];
        strLab.textColor = UIColorFromRGB(0x333333);
        strLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
        [whiteView addSubview:strLab];
    }
    for (int i=1; i<3; i++) {
        UILabel *xianLab = [[UILabel alloc]initWithFrame:CGRectMake(30*MYWIDTH, whiteView.height/3*i, UIScreenW-120*MYWIDTH, 1)];
        xianLab.backgroundColor = UIColorFromRGB(0xF4F4F4);
        [whiteView addSubview:xianLab];
    }
    
    NSString *dingdanStr = [NSString stringWithFormat:@"%@",_model.orderno];
    NSString *zhongdaunStr = [NSString stringWithFormat:@"%@",_model.electricsbm];
    NSString *createtime = [NSString stringWithFormat:@"%@",_model.createtime];
    NSString *endtime = [NSString stringWithFormat:@"%@",_model.endtime];
    NSUInteger timeInteger = [self getCountDownStringWithCreateTime:createtime EndTime:endtime];
    NSString *time;
    if (timeInteger/60) {
        time = [NSString stringWithFormat:@"%zd小时%zd分钟",timeInteger/60,timeInteger%60];
    }else{
        time = [NSString stringWithFormat:@"%zd分钟",timeInteger];
    }
    NSArray *otherArr = @[dingdanStr,zhongdaunStr,time];
    for (int i=0; i<otherArr.count; i++) {
        UILabel *strLab = [[UILabel alloc]initWithFrame:CGRectMake(110*MYWIDTH, whiteView.height/3*i, UIScreenW-190*MYWIDTH, 50*MYWIDTH)];
        strLab.text = otherArr[i];
        strLab.textColor = UIColorFromRGB(0x333333);
        strLab.textAlignment = NSTextAlignmentRight;
        strLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
        [whiteView addSubview:strLab];
    }
    
}
/**
 *  计算剩余时间
 *
 *  @param endTime   结束日期
 *
 *  @return 剩余时间
 */
-(NSUInteger )getCountDownStringWithCreateTime:(NSString *)createTime EndTime:(NSString *)endTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];//设置时区
    
    NSDate *createDate = [dateFormatter dateFromString:createTime];
    NSInteger createInterval = [zone secondsFromGMTForDate: createDate];
    NSDate *create = [createDate dateByAddingTimeInterval: createInterval];

    NSDate *endDate = [dateFormatter dateFromString:endTime];
    NSInteger endInterval = [zone secondsFromGMTForDate: endDate];
    NSDate *end = [endDate dateByAddingTimeInterval: endInterval];
    NSUInteger voteCountTime = ([end timeIntervalSinceDate:create])/60;
    
    return voteCountTime;
}
/*
 -(NSString *)getCountDownStringWithCreateTime:(NSString *)createTime EndTime:(NSString *)endTime {
 
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 NSTimeZone *zone = [NSTimeZone systemTimeZone];//设置时区
 
 NSDate *createDate = [[NSDate alloc]init];
 NSInteger interval = [zone secondsFromGMTForDate: createDate];
 createDate = [dateFormatter dateFromString:createTime];
 NSDate *create = [createDate  dateByAddingTimeInterval: interval];
 NSTimeInterval _createDate = [create timeIntervalSince1970]*1;
 
 NSDate *endDate = [[NSDate alloc]init];
 NSInteger interval1 = [zone secondsFromGMTForDate: createDate];
 endDate = [dateFormatter dateFromString:endTime];
 NSDate *end = [endDate  dateByAddingTimeInterval: interval1];
 NSTimeInterval _endDate = [end timeIntervalSince1970]*1;
 
 NSUInteger voteCountTime = (_endDate - _createDate) / 3600 / 24;
 NSString *timeStr = [NSString stringWithFormat:@"%d", (int)voteCountTime];
 
 NSLog(@">>>%f %f %lu",_endDate,_createDate,(unsigned long)voteCountTime);
 
 return timeStr;
 }
 */

@end
