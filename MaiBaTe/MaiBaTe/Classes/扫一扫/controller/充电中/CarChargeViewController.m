//
//  CarChargeViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/9/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CarChargeViewController.h"
#import "HcdProcessView.h"
#import "MBTTabBarController.h"
#import "CarChargeModel.h"
#import "CarNumerModel.h"
#import "ChargeOrderViewController.h"
#import "MBTNavigationController.h"
#import <ImageIO/ImageIO.h>
#import <SocketRocket.h>

@interface CarChargeViewController ()<UITableViewDelegate,UITableViewDataSource,SRWebSocketDelegate>
{
    int numer;//判断结束充电
    //NSTimer *_timer;
    UIImageView *_BGView;
    UILabel *_dushuLab;
    UILabel *_chargeed;
    UILabel *_timeing;

    int _index;
    NSTimer * heartBeat;
    NSTimeInterval reConnectTime;
}

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *totalArr;
@property(nonatomic,strong)NSMutableArray *socketArr;
@property (nonatomic, strong) LLGifImageView *gifImageView;

@property (nonatomic,strong) SRWebSocket *socket;

@end

@implementation CarChargeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    numer = 1;
    [self dataCarCharge];
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self SRWebSocketClose];
    //[_timer invalidate];
    //_timer = nil;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArr = [[NSMutableArray alloc]init];
    _totalArr = [[NSMutableArray alloc]init];

    [self tableView];
    
    [self liebiaoView];
    
    if (self.socket) {
        self.socket = nil;
        return;
    }
    //SRWebSocketUrlString 就是websocket的地址
    self.socket = [[SRWebSocket alloc] initWithURLRequest:
                   [NSURLRequest requestWithURL:[NSURL URLWithString:socket_ADDRESS]]];
    
    self.socket.delegate = self;   //SRWebSocketDelegate 协议
    
}


- (void)dataCarCharge{
    
    [SVProgressHUD showWithStatus:@"正在加载..."];

    //加载
    NSString *URLStr = @"/mbtwz/wxorder?action=getZhengZaiChongDianOrder";
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:nil success:^(id response) {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",arr);
        [SVProgressHUD dismiss];
        if (arr.count) {
            CarChargeModel *model=[[CarChargeModel alloc]init];
            [model setValuesForKeysWithDictionary:arr[0]];
            //追加数据
            [_dataArr addObject:model];
            //[self setCarChargeView1];
            _dushuLab.text = [NSString stringWithFormat:@" %.2f°",[model.count floatValue]];
            _chargeed.text = [NSString stringWithFormat:@"已充:%.2f度电",[model.count floatValue]];
            [_tableView reloadData];
            
            
            [self yanshidingshiqi];
        }
        

    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
    
    //充电度数
    NSDictionary* data = @{@"data":@"{\"createtimeGE\":\"\",\"createtimeLE\":\"\"}"};

    NSString *URLStrNum = @"/mbtwz/wxorder?action=getSumzongdianliangandjine";
    [HTNetWorking postWithUrl:URLStrNum refreshCache:YES params:data success:^(id response) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        if (dic!=nil) {
            CarNumerModel *model=[[CarNumerModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            //追加数据
            [_totalArr addObject:model];
            //[self setCarChargeView1];
            if ([model.time floatValue]<=0) {
                _timeing.text = @"已充:0小时";
            }else{
                _timeing.text = [NSString stringWithFormat:@"已充:%.2f小时",[model.time floatValue]];
            }
            [_tableView reloadData];

            [self.socket open];     //open 就是直接连接了

        }
        

    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)yanshidingshiqi{
    NSLog(@"等待五秒开始");
    //jxt_showToastTitle(@"等待五秒开始", 1);
    //_timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(something) userInfo:nil repeats:NO];

}
//延时操作
//-(void)something{
//    NSLog(@"等待五秒结束");
//    //jxt_showToastTitle(@"等待五秒结束", 1);
//
//    NSString *dushu = [[NSString alloc]init];
//    if (_dataArr.count) {
//        CarChargeModel *model = _dataArr[0];
//        dushu = [NSString stringWithFormat:@"%@",model.count];
//    }
//    if (_socketArr.count) {
//        dushu = [NSString stringWithFormat:@"%@",[_socketArr[0] objectForKey:@"chongdiandushu"]];
//        NSLog(@"%@",[_socketArr[0] objectForKey:@"chongdiandushu"]);
//    }
//
//    if ([dushu floatValue]==0) {
//
//        //
//        NSDictionary *data;
//        if (_dataArr.count) {
//            CarChargeModel *model = _dataArr[0];
//            data = @{@"params":[NSString stringWithFormat:@"{\"orderid\":\"%@\"}",model.orderid]};
//        }else{
//            data = nil;
//        }
//        NSString *URLStrNum = @"/mbtwz/wxorder?action=ziciFaSongDingdan";
//        [HTNetWorking postWithUrl:URLStrNum refreshCache:YES params:data success:^(id response) {
//            NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
//
//            NSLog(@"再次发送订单>>>>>%@",str);
//            if ([str rangeOfString:@"true"].location!=NSNotFound) {
//                //
//                [self yanshidingshiqi];
//            }else{
//                [_timer invalidate];
//                _timer = nil;
//
//            }
//
//
//        } fail:^(NSError *error) {
//            [SVProgressHUD dismiss];
//        }];
//    }
//}
- (UIImageView *)setCarChargeView1{
    
    
    if (_BGView==nil) {
        _BGView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenW)];
        _BGView.image = [UIImage imageNamed:@"充电中BG"];
        _BGView.userInteractionEnabled = YES;
        [self.view addSubview:_BGView];
        
        //页面返回按钮
        CGRect leftFrame;
        leftFrame = CGRectMake(-2, 10, 60, 60);
        UIButton *leftButton= [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame =leftFrame;
        [leftButton addTarget:self action:@selector(dismissOverlayView:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [leftButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [_BGView addSubview:leftButton];
        
        //适用于帧数多的gif动画
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"chongdiand" ofType:@"gif"];
        _gifImageView = [[LLGifImageView alloc] initWithFrame:CGRectMake(UIScreenW/4, 50, UIScreenW/2, UIScreenW/2) filePath:filePath];
        [_BGView addSubview:_gifImageView];
        [_gifImageView startGif];
        
        UIImageView *shudian = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW/2-1, _gifImageView.bottom+5, 3, _BGView.bottom - _gifImageView.bottom-25)];
        shudian.image = [UIImage imageNamed:@"竖点"];
        [_BGView addSubview:shudian];
    }
    
    
    
//    HcdProcessView *customView = [[HcdProcessView alloc]initWithFrame:CGRectMake(UIScreenW/10*1.5, 20, UIScreenW/10*7, UIScreenW/10*7)];
//    customView.titletext = @" 0°";
//    if (_dataArr.count) {
//        CarChargeModel *model = _dataArr[0];
//        customView.titletext = [NSString stringWithFormat:@" %@°",model.count];
//    }
//    if (_socketArr.count) {
//        customView.titletext = [NSString stringWithFormat:@" %@°",[_socketArr[0] objectForKey:@"chongdiandushu"]];
//    }
//    customView.showBgLineView = YES;
//    customView.frontWaterColor = UIColorFromRGB(0x3fc320);
//    customView.backWaterColor = UIColorFromRGB(0x8fc320);
//    [BGView addSubview:customView];
    
    
    
    
    if (_dushuLab==nil) {
        _dushuLab = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW/4, 50, UIScreenW/2, UIScreenW/2)];
        _dushuLab.text = @" 0°";
        _dushuLab.font = [UIFont systemFontOfSize:40*MYWIDTH];
        _dushuLab.textColor = [UIColor whiteColor];
        _dushuLab.textAlignment = NSTextAlignmentCenter;
        [_BGView addSubview:_dushuLab];
    }
    

    
    if (_chargeed==nil) {
        _chargeed = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW/20, _BGView.bottom - 65*MYWIDTH, UIScreenW/10*4, 35*MYWIDTH)];
        _chargeed.layer.borderColor = UIColorFromRGB(0xF4F4F4).CGColor;//边框颜色
        _chargeed.layer.borderWidth = 1;//边框宽度
        _chargeed.layer.cornerRadius = 5.0;
        _chargeed.text = @"已充:0度电";
        
        _chargeed.textColor = [UIColor whiteColor];
        _chargeed.font = [UIFont systemFontOfSize:13];
        _chargeed.textAlignment = NSTextAlignmentCenter;
        [_BGView addSubview:_chargeed];
    }
    
    
    if (_timeing==nil) {
        _timeing = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW/5*3-UIScreenW/20, _BGView.bottom - 65*MYWIDTH, UIScreenW/10*4, 35*MYWIDTH)];
        _timeing.layer.borderColor = UIColorFromRGB(0xF4F4F4).CGColor;//边框颜色
        _timeing.layer.borderWidth = 1;//边框宽度
        _timeing.layer.cornerRadius = 8.0;
        _timeing.text = @"已充:0小时";
        _timeing.textColor = [UIColor whiteColor];
        _timeing.font = [UIFont systemFontOfSize:13];
        _timeing.textAlignment = NSTextAlignmentCenter;
        [_BGView addSubview:_timeing];
    }
    
    return _BGView;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH-60*MYWIDTH)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _tableView.tableHeaderView = [self setCarChargeView1];

        [self.view addSubview:_tableView];

    }
    return _tableView;
}
- (void)liebiaoView{
    UIButton *button = [UIButton buttonWithTitle:@"结束充电" TitleColor:UIColorFromRGB(MYColor) titleFont:[UIFont systemFontOfSize:17] image:nil backgroundImage:nil bgColor:UIColorFromRGB(0x333333) rect:CGRectMake(0, UIScreenH-60*MYWIDTH, UIScreenW, 60*MYWIDTH) state:UIControlStateNormal target:self action:@selector(buttonClick)];
    //[button setTitle:@"您已链接两台设备" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    
}
//结束充电
- (void)buttonClick{
    if (numer==2) {
        [SVProgressHUD showWithStatus:@"正在结束充电..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        CarChargeModel *model;
        NSDictionary* data;
        if (_dataArr.count) {
            model = _dataArr[0];
            data = @{@"data":[NSString stringWithFormat:@"{\"electricno\":\"%@\",\"electricsbm\":\"%@\"}",model.electricno,model.electricsbm]};
        }else{
            data = @{@"data":[NSString stringWithFormat:@"{\"electricno\":\"%@\",\"electricsbm\":\"%@\"}",@"",@""]};
        }
        NSLog(@"结束充电data%@",data);
        NSString *URLStr = @"/mbtwz/wxorder?action=endChongDian";
        [HTNetWorking postWithUrl:URLStr refreshCache:YES params:data success:^(id response) {
            NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
            
            NSLog(@"结束充电>>>>>%@",str);
            if ([str rangeOfString:@"true"].location!=NSNotFound) {
                //
                numer = 2;
            }else{
                numer = 1;
                jxt_showAlertOneButton(@"提示", @"结束充电操作失败", @"确定", ^(NSInteger buttonIndex) {
                    
                });
                [SVProgressHUD dismiss];
            }
            
        } fail:^(NSError *error) {
            [SVProgressHUD dismiss];
            
        }];
    }else{
        jxt_showAlertTwoButton(@"您确定要结束充电吗", nil, @"取消", ^(NSInteger buttonIndex) {
            
        }, @"确定", ^(NSInteger buttonIndex) {
            [SVProgressHUD showWithStatus:@"正在结束充电..."];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            CarChargeModel *model;
            NSDictionary* data;
            if (_dataArr.count) {
                model = _dataArr[0];
                data = @{@"data":[NSString stringWithFormat:@"{\"electricno\":\"%@\",\"electricsbm\":\"%@\"}",model.electricno,model.electricsbm]};
            }else{
                data = @{@"data":[NSString stringWithFormat:@"{\"electricno\":\"%@\",\"electricsbm\":\"%@\"}",@"",@""]};
            }
            NSLog(@"结束充电data%@",data);
            NSString *URLStr = @"/mbtwz/wxorder?action=endChongDian";
            [HTNetWorking postWithUrl:URLStr refreshCache:YES params:data success:^(id response) {
                NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
                
                NSLog(@"结束充电>>>>>%@",str);
                if ([str rangeOfString:@"true"].location!=NSNotFound) {
                    //
                    numer = 2;
                }else{
                    numer = 1;
                    jxt_showAlertOneButton(@"提示", @"结束充电操作失败", @"确定", ^(NSInteger buttonIndex) {
                        
                    });
                    [SVProgressHUD dismiss];
                    
                }
                
            } fail:^(NSError *error) {
                [SVProgressHUD dismiss];
                
            }];
        });
    }
    
    
    
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
   UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell .accessoryType  = UITableViewCellAccessoryNone;

    NSArray *titleArr = @[@"账单号:",@"充电枪号",@"设备终端盒号:",@"充电金额:",@"充电总度数:",@"充电总金额:",@"账单创建时间:"];

    //配置单元格。
    cell.textLabel.text = titleArr[indexPath.row];
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 49*MYWIDTH, UIScreenW, 1)];
    xian.backgroundColor = UIColorFromRGB(0xF4F4F4);
    [cell addSubview:xian];
    if (indexPath.row == 4 || indexPath.row == 5) {
        cell .accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        if (_totalArr.count) {
            CarNumerModel *model = _totalArr[0];
            NSArray *otherArr;
            if (![[NSString stringWithFormat:@"%@",model.totalcount] isEqualToString:@"(null)"]) {
                otherArr = @[@"",@"",@"",@"",[NSString stringWithFormat:@"%.2f°",[model.totalcount floatValue]],[NSString stringWithFormat:@"%.2f元",[model.totalrealmoney floatValue]],@""];
            }else{
                otherArr = @[@"",@"",@"",@"",@"0",@"0",@""];
            }
            UILabel *strLab = [[UILabel alloc]initWithFrame:CGRectMake(190*MYWIDTH, 0, UIScreenW-230*MYWIDTH, 50*MYWIDTH)];
            strLab.text = otherArr[indexPath.row];
            strLab.textColor = UIColorFromRGB(0x333333);
            strLab.textAlignment = NSTextAlignmentRight;
            strLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
            [cell addSubview:strLab];
        }
    }else{
        if (_dataArr.count) {
            CarChargeModel *model = _dataArr[0];
            NSArray *otherArr = @[model.orderno,model.electricsbm,model.electricno,[NSString stringWithFormat:@"%.2f元",[model.realmoney floatValue]],@"",@"",model.createtime];
            UILabel *strLab = [[UILabel alloc]initWithFrame:CGRectMake(190*MYWIDTH, 0, UIScreenW-210*MYWIDTH, 50*MYWIDTH)];
            strLab.text = otherArr[indexPath.row];
            strLab.textColor = UIColorFromRGB(0x333333);
            if (indexPath.row == 3) {
                if (_socketArr.count) {
                    strLab.text = [NSString stringWithFormat:@"%.2f元",[[_socketArr[0] objectForKey:@"realmoney"] floatValue]];
                }
                strLab.textColor = UIColorFromRGB(MYColor);
            }
            strLab.textAlignment = NSTextAlignmentRight;
            strLab.font = [UIFont systemFontOfSize:14*MYWIDTH];
            [cell addSubview:strLab];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 4||indexPath.row == 5) {
        ChargeOrderViewController *charge = [[ChargeOrderViewController alloc]init];
        MBTNavigationController *nav = [[MBTNavigationController alloc] initWithRootViewController:charge];
        [self presentViewController:nav animated:YES completion:nil];
    }
}
- (void)dismissOverlayView:(id)sender{
    if (_pushnumer == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        NSLog(@"11111111111");
    }else{
        NSLog(@"222222222222");

        [self dismissViewControllerAnimated:YES completion:nil];
        kKeyWindow.rootViewController = nil;
        kKeyWindow.rootViewController =[[MBTTabBarController alloc]init];
        [kKeyWindow makeKeyAndVisible];
    }

}

#pragma mark - WebSocket

/**
 * 开始到结束的时间差
 */
- (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    if (value<0) {
        value = 0;
    }
    return [NSString stringWithFormat:@"%.2f",value / 3600];
}

//关闭连接
-(void)SRWebSocketClose{
    if (self.socket){
        [self.socket close];
        self.socket = nil;
        //断开连接时销毁心跳
        [self destoryHeartBeat];
    }
}

#pragma mark - socket delegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"连接成功，可以与服务器交流了,同时需要开启心跳");
    //每次正常连接的时候清零重连时间
    reConnectTime = 0;
    //开启心跳
    [self initHeartBeat];
    //[[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketDidOpenNote object:nil];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"连接失败，这里可以实现掉线自动重连，要注意以下几点");
    NSLog(@"1.判断当前网络环境，如果断网了就不要连了，等待网络到来，在发起重连");
    NSLog(@"2.判断调用层是否需要连接，例如用户都没在聊天界面，连接上去浪费流量");
    NSLog(@"3.连接次数限制，如果连接失败了，重试10次左右就可以了，不然就死循环了。");
    _socket = nil;
    //连接失败就重连
    [self reConnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",code,reason,wasClean);
    //断开连接 同时销毁心跳
    [self SRWebSocketClose];
}

/*该函数是接收服务器发送的pong消息，其中最后一个是接受pong消息的，
 在这里就要提一下心跳包，一般情况下建立长连接都会建立一个心跳包，
 用于每隔一段时间通知一次服务端，客户端还是在线，这个心跳包其实就是一个ping消息，
 我的理解就是建立一个定时器，每隔十秒或者十五秒向服务端发送一个ping消息，这个消息可是是空的
 */
-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"reply===%@",reply);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    //收到服务器发过来的数据 这里的数据可以和后台约定一个格式 我约定的就是一个字符串 收到以后发送通知到外层 根据类型 实现不同的操作
    NSLog(@"ZFC %@",message);
    NSData *JSONData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];

    NSLog(@"收到数据了，是 %@",responseJSON);
    
    if (responseJSON) {
        if (_dataArr.count) {
            CarChargeModel *model = _dataArr[0];
            NSLog(@">>ID>%@",[responseJSON objectForKey:@"orderid"]);
            NSLog(@">>>ID>%@",model.orderid);
            if (numer==1) {
                if ([[responseJSON objectForKey:@"orderid"] intValue]==[model.orderid intValue]) {
                    [SVProgressHUD dismiss];
                    
                    if ([[NSString stringWithFormat:@"%@",[responseJSON objectForKey:@"biaoshi"]] isEqualToString:@"01"]) {
                        _socketArr = [[NSMutableArray alloc]init];
                        [_socketArr addObject:responseJSON];
                        //[self setCarChargeView1];
                        
                        _dushuLab.text = [NSString stringWithFormat:@" %.2f°",[[_socketArr[0] objectForKey:@"chongdiandushu"] floatValue]];
                        _chargeed.text = [NSString stringWithFormat:@"已充:%.2f度电",[[_socketArr[0] objectForKey:@"chongdiandushu"] floatValue]];
                        
                        CarChargeModel *model = _dataArr[0];
                        NSString *createtime = [NSString stringWithFormat:@"%@",model.createtime];
                        NSString *endtime = [NSString stringWithFormat:@"%@",[_socketArr[0] objectForKey:@"endtime"]];
                        NSLog(@"?>>>>>>%@,%@",createtime,endtime);
                        NSString * timeInteger = [self dateTimeDifferenceWithStartTime:createtime endTime:endtime];
                        if (timeInteger<=0) {
                            _timeing.text = @"已充:0小时";
                        }else{
                            _timeing.text = [NSString stringWithFormat:@"已充:%.2f小时",[timeInteger floatValue]];
                        }
                        
                        [_tableView reloadData];
                    }else{
                        jxt_showToastTitle(@"充电已结束", 1);
                        
                        ChargeOrderViewController *charge = [[ChargeOrderViewController alloc]init];
                        MBTNavigationController *nav = [[MBTNavigationController alloc] initWithRootViewController:charge];
                        [self presentViewController:nav animated:YES completion:nil];
                    }
                    
                }
            }else if (numer==2){//结束状态为2
                if ([[responseJSON objectForKey:@"orderid"] intValue]==[model.orderid intValue]) {
                    [SVProgressHUD dismiss];
                    
                    if ([[NSString stringWithFormat:@"%@",[responseJSON objectForKey:@"biaoshi"]] isEqualToString:@"01"]) {
                        [self buttonClick];
                    }else{
                        jxt_showToastTitle(@"充电已结束", 1);
                        
                        ChargeOrderViewController *charge = [[ChargeOrderViewController alloc]init];
                        MBTNavigationController *nav = [[MBTNavigationController alloc] initWithRootViewController:charge];
                        [self presentViewController:nav animated:YES completion:nil];
                    }
                    
                }
            }
            
        }
        
    }else{
        NSLog(@"webSocket接受数据为空");
    }
}

#pragma mark - methods
//重连机制
- (void)reConnect{
    
    [self SRWebSocketClose];
    
    //超过一分钟就不再重连 所以只会重连5次 2^5 = 64
    if (reConnectTime > 64) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.socket = nil;
        if (self.socket) {
            self.socket = nil;
            return;
        }
        //SRWebSocketUrlString 就是websocket的地址
        self.socket = [[SRWebSocket alloc] initWithURLRequest:
                       [NSURLRequest requestWithURL:[NSURL URLWithString:socket_ADDRESS]]];
        
        self.socket.delegate = self;   //SRWebSocketDelegate 协议
        [self.socket open];     //open 就是直接连接了

        NSLog(@"重连");
    });
    
    //重连时间2的指数级增长
    if (reConnectTime == 0) {
        reConnectTime = 2;
    }else{
        reConnectTime *= 2;
    }
}

//初始化心跳
- (void)initHeartBeat
{
    dispatch_main_async_safe(^{
        
        [self destoryHeartBeat];
        __weak typeof(self) weakSelf = self;
        //心跳设置为3分钟，NAT超时一般为5分钟
        heartBeat = [NSTimer scheduledTimerWithTimeInterval:2*60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"heart");
            //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
            [weakSelf sendData:@"heart"];
        }];
        [[NSRunLoop currentRunLoop]addTimer:heartBeat forMode:NSRunLoopCommonModes];
    })
    
}

//取消心跳
- (void)destoryHeartBeat
{
    dispatch_main_async_safe(^{
        if (heartBeat) {
            [heartBeat invalidate];
            heartBeat = nil;
        }
    })
}

//pingPong机制
- (void)ping{
    [self.socket sendPing:nil];
}


#define WeakSelf(ws) __weak __typeof(&*self)weakSelf = self
- (void)sendData:(id)data {
    
    WeakSelf(ws);
    dispatch_queue_t queue =  dispatch_queue_create("zy", NULL);
    
    dispatch_async(queue, ^{
        if (weakSelf.socket != nil) {
            // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
            if (weakSelf.socket.readyState == SR_OPEN) {
                [weakSelf.socket send:data];    // 发送数据
                
            } else if (weakSelf.socket.readyState == SR_CONNECTING) {
                NSLog(@"正在连接中，重连后其他方法会去自动同步数据");
                // 每隔2秒检测一次 socket.readyState 状态，检测 10 次左右
                // 只要有一次状态是 SR_OPEN 的就调用 [ws.socket send:data] 发送数据
                // 如果 10 次都还是没连上的，那这个发送请求就丢失了，这种情况是服务器的问题了，小概率的
                [self reConnect];
                
            } else if (weakSelf.socket.readyState == SR_CLOSING || weakSelf.socket.readyState == SR_CLOSED) {
                // websocket 断开了，调用 reConnect 方法重连
                [self reConnect];
            }
        } else {
            NSLog(@"没网络，发送失败，一旦断网 socket 会被我设置 nil 的");
        }
    });
}
@end
