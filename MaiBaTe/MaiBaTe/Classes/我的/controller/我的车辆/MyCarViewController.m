//
//  MyCarViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyCarViewController.h"
#import "MyCarTableViewCell.h"
#import "AddMyCarViewController.h"
#import "LoginViewController.h"
#import <SocketRocket.h>

@interface MyCarViewController ()<UITableViewDataSource,UITableViewDelegate,SRWebSocketDelegate>
{
    NSTimer * heartBeat;
    NSTimeInterval reConnectTime;

}
@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic,strong) SRWebSocket *socket;

@end

@implementation MyCarViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNew];

    UIImage *image = [UIImage imageNamed:@"NarBg"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self SRWebSocketClose];

    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_tableview];
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 10)];
        _tableview.tableHeaderView = head;
        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 65*MYWIDTH)];
        UIButton *addCar = [[UIButton alloc]init];
        [addCar setFrame:CGRectMake(15*MYWIDTH,10*MYWIDTH, UIScreenW-30*MYWIDTH, 45*MYWIDTH)];
        ;
        [addCar setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        [addCar setTitle:@"添加车辆" forState:UIControlStateNormal];
        [addCar addTarget:self action:@selector(addCarButClicked) forControlEvents:UIControlEventTouchUpInside];
        [food addSubview:addCar];
        _tableview.tableFooterView = food;
        
        [_tableview registerClass:[MyCarTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MyCarTableViewCell class])];
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
    }
    return _tableview;
    
}
//下拉刷新
- (void)loadNewData{
    
    [self loadNew];
    [_tableview.mj_header endRefreshing];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的车辆Nar.png"]];
    titleImage.frame = CGRectMake(5, 3, 17, 19);
    [titleView addSubview:titleImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 75, 25)];
    titleLab.text = @"我的车辆";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    self.navigationItem.titleView = titleView;
    self.dataArr = [[NSMutableArray alloc]init];
    [self tableview];
    
    if (self.socket) {
        self.socket = nil;
        return;
    }
    //SRWebSocketUrlString 就是websocket的地址
    self.socket = [[SRWebSocket alloc] initWithURLRequest:
                   [NSURLRequest requestWithURL:[NSURL URLWithString:socket_ADDRESS]]];
    self.socket.delegate = self;   //SRWebSocketDelegate 协议
    [self.socket open];     //open 就是直接连接了

}

#pragma 在这里面请求数据
- (void)loadNew
{
    
    [_dataArr removeAllObjects];
    NSString *URLStr = @"/mbtwz/elecar?action=getMyCar";
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:nil success:^(id response) {
        
        NSArray* Array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        NSSLog(@"xilie%@",Array);
        if (Array.count) {
            for (NSDictionary *diction in Array) {
                //建立模型
                MyCarModel *model=[[MyCarModel alloc]init];
                [model setValuesForKeysWithDictionary:diction];
                //追加数据
                [self.dataArr addObject:model];
            }
        }
        if (self.dataArr.count>0) {
            [self.tableview dismissNoView];
        }else{
            [self.tableview showNoView:nil image:nil certer:CGPointZero];
        }
        [self.tableview reloadData];

    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210*MYWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Class MainTitleClass = [MyCarTableViewCell class];
    MyCarTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MainTitleClass)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!IsEmptyValue(_dataArr)) {
        MyCarModel *model = _dataArr[indexPath.row];
        [cell setData:model];
        cell.tag = indexPath.row;
        [cell.deleteBut addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
- (void)deleteClick:(UIButton *)but{

    jxt_showAlertTwoButton(@"提示", @"您确定要删除吗？", @"取消", ^(NSInteger buttonIndex) {

    }, @"确定", ^(NSInteger buttonIndex) {
        MyCarModel *model = _dataArr[but.tag];
        NSString *URLStr = @"/mbtwz/elecar?action=delMyCar";
        NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\"}",model.id]};
        [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {

            NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
            NSLog(@"%@",str);
            if ([str rangeOfString:@"false"].location!=NSNotFound) {
                jxt_showToastTitle(@"删除失败", 1);
            }else if([str rangeOfString:@"true"].location!=NSNotFound){
                jxt_showToastTitle(@"删除成功", 1);
                [_dataArr removeObjectAtIndex:but.tag];
                [_tableview reloadData];
            }

        } fail:^(NSError *error) {

        }];
    });
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%ld",indexPath.row);
}
- (void)addCarButClicked{
    [Command isloginRequest:^(bool str) {
        if (str) {
            AddMyCarViewController *addCar = [[AddMyCarViewController alloc]init];
            [self.navigationController pushViewController:addCar animated:YES];
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginViewController* vc = [[LoginViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }
    }];
    
}

#pragma mark - WebSocket


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
        
        for (MyCarModel *model in _dataArr) {
            if ([model.cartype isEqualToString:[responseJSON objectForKey:@"chepaihao"]]) {
                
                NSString *URLStr = @"/mbtwz/elecar?action=searchmyCarToId";
                NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"chepaihao\":\"%@\"}",model.cartype]};
                [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
                    
                    NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
                    NSLog(@">>>>>>%@",str);
                    if ([str rangeOfString:@"false"].location!=NSNotFound) {
                    }else{
                        if ([str isEqualToString:[NSString stringWithFormat:@"%@",model.id]]) {
                            model.chesu = [responseJSON objectForKey:@"chesu"];
                            model.zongdianya = [responseJSON objectForKey:@"zongdianya"];
                            model.zongdianliu = [responseJSON objectForKey:@"zongdianliu"];
                            model.wendu = [responseJSON objectForKey:@"wendu"];
                            [_tableview reloadData];
                        }
                    }
                    
                } fail:^(NSError *error) {
                    
                }];
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
