//
//  SetViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SetViewController.h"
#import "SetTableViewCell.h"
#import "AboutMeViewController.h"
#import "SaveCenterViewController.h"
#import "AnswerViewController.h"
#import "JPUSHService.h"

@interface SetViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_bgView;
    NSString *_versionUrl;
}
@property(nonatomic,strong)UITableView *tableview;

@end

@implementation SetViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"NarBg"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH-64)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _tableview.scrollEnabled = NO;
        [self.view addSubview:_tableview];
        
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 15)];
        _tableview.tableHeaderView = head;
        [_tableview registerNib:[UINib nibWithNibName:@"SetTableViewCell" bundle:nil] forCellReuseIdentifier:@"SetTableViewCell"];
        
    }
    return _tableview;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 25)];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"设置Nar.png"]];
    titleImage.frame = CGRectMake(5, 3, 19, 19);
    [titleView addSubview:titleImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 45, 25)];
    titleLab.text = @"设置";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    
    [self tableview];
    
    UIButton *tuichu = [UIButton buttonWithTitle:@"退出登录" TitleColor:UIColorFromRGB(0x515151) titleFont:[UIFont systemFontOfSize:17] image:nil backgroundImage:nil bgColor:UIColorFromRGB(0xffffff) rect:CGRectMake(0, UIScreenH-60*MYWIDTH, UIScreenW, 60*MYWIDTH) state:UIControlStateNormal target:self action:@selector(tuichuClick)];
    [self.view addSubview:tuichu];
}
//退出登录
- (void)tuichuClick{
    
    [JXTAlertView showAlertViewWithTitle:@"确认退出登录" message:nil cancelButtonTitle:@"取消"otherButtonTitle:@"确定" cancelButtonBlock:nil otherButtonBlock:^(NSInteger buttonIndex) {
        NSString *URLStr = @"/mbtwz/mallLogin?action=exiteMallLogin";
        [Command loadDataWithParams:nil withPath:URLStr completionBlock:^(id responseObject, NSError *error) {
            NSLog(@"我的登录%@",responseObject);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:USERID];
            [userDefaults removeObjectForKey:USENAME];
            [userDefaults removeObjectForKey:USERPHONE];
            [userDefaults removeObjectForKey:PASSWORD];
            [userDefaults synchronize];
            
            NSDictionary *dict = @{@"chongdian":@""};
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"chongdianzhuangtai" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [self cancelJpush];
            [self.navigationController popViewControllerAnimated:YES];
        } autoShowError:YES];
    }];
    
}
#pragma mark Jpush消除标签、别名
-(void)cancelJpush{
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:0];
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*MYWIDTH;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SetTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SetTableViewCell"];
    if (!cell) {
        cell=[[SetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SetTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *title = @[@"版本更新",@"安全中心",@"意见与建议",@"关于我们"];

    if (indexPath.row == 0) {
        cell.titleLab.text = title[indexPath.row];
        cell.titleLab1.text = @"";
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDic));
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSLog(@"当前版本号%@",appVersion);
        cell.otherLab.text = [NSString stringWithFormat:@"当前版本号：%@",appVersion];//@"当前版本号：1.10823";
    }else{
        cell.titleLab.text = @"";
        cell.titleLab1.text = title[indexPath.row];
        cell.otherLab.text = @"";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self versionRequest];
    }else if (indexPath.row == 1){
        SaveCenterViewController *saveVC = [[SaveCenterViewController alloc]init];
        [self.navigationController pushViewController:saveVC animated:YES];
    }else if (indexPath.row == 3){
        AboutMeViewController *about = [[AboutMeViewController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }else if (indexPath.row == 2){
        AnswerViewController* vc = [[AnswerViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    NSLog(@"%ld",indexPath.row);
}

- (void)setbanbenUIViewing{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
    _bgView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH/7*2)];
    topview.backgroundColor = [UIColor blackColor];
    topview.alpha = 0.5;
    [_bgView addSubview:topview];
    
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, topview.bottom, UIScreenW/2 - 125*MYWIDTH, 320*MYWIDTH)];
    leftview.backgroundColor = [UIColor blackColor];
    leftview.alpha = 0.5;
    [_bgView addSubview:leftview];
    
    UIView *rightview = [[UIView alloc]initWithFrame:CGRectMake(UIScreenW/2 + 125*MYWIDTH, topview.bottom, UIScreenW/2 - 125*MYWIDTH, 320*MYWIDTH)];
    rightview.backgroundColor = [UIColor blackColor];
    rightview.alpha = 0.5;
    [_bgView addSubview:rightview];
    
    UIView *bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenH/7*2+320*MYWIDTH, UIScreenW, UIScreenH/7*5 - 320*MYWIDTH)];
    bottomview.backgroundColor = [UIColor blackColor];
    bottomview.alpha = 0.5;
    [_bgView addSubview:bottomview];
    
    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"版本更新_1"]];
    bgImage.userInteractionEnabled = YES;
    bgImage.frame = CGRectMake(leftview.right-12*MYWIDTH, topview.bottom-12*MYWIDTH, 250*MYWIDTH+24*MYWIDTH, 320*MYWIDTH+24*MYWIDTH);
    [_bgView addSubview:bgImage];
    
    UIButton *backBut = [[UIButton alloc]initWithFrame:CGRectMake(bgImage.right-30*MYWIDTH, bgImage.y-10*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
    [backBut setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(backBanBenClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:backBut];
    
    UIImageView *huojianImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"火箭"]];
    huojianImage.frame = CGRectMake(UIScreenW/2 - 45*MYWIDTH, bgImage.y - 45*MYWIDTH, 90*MYWIDTH, 150*MYWIDTH);
    [_bgView addSubview:huojianImage];

    UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(30*MYWIDTH, bgImage.height/5*2, bgImage.width-60*MYWIDTH, 20)];
    textLab.text = @"新版本优化:";
    textLab.textColor = [UIColor blackColor];
    textLab.font = [UIFont systemFontOfSize:15];
    [bgImage addSubview:textLab];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30*MYWIDTH, textLab.bottom+10, bgImage.width-60*MYWIDTH, 60)];
    titleLab.text = @"1.优化部分机型闪退BUG\n\n2.更换部分图标";
    titleLab.numberOfLines = 0;
    titleLab.textColor = UIColorFromRGB(0x666666);
    titleLab.font = [UIFont systemFontOfSize:13];
    [bgImage addSubview:titleLab];
    
    UIButton *upBut = [[UIButton alloc]initWithFrame:CGRectMake(30*MYWIDTH, bgImage.height/7*5, bgImage.width-60*MYWIDTH, 40*MYWIDTH)];
    [upBut setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
    [upBut setTitle:@"立即更新" forState:UIControlStateNormal];
    [upBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bgImage addSubview:upBut];
    [upBut addTarget:self action:@selector(upButClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)backBanBenClick{
    [_bgView removeFromSuperview];
}
- (void)setbanbenUIViewed{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
    _bgView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH/7*2)];
    topview.backgroundColor = [UIColor blackColor];
    topview.alpha = 0.5;
    [_bgView addSubview:topview];
    
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, topview.bottom, UIScreenW/2 - 125*MYWIDTH, 320*MYWIDTH)];
    leftview.backgroundColor = [UIColor blackColor];
    leftview.alpha = 0.5;
    [_bgView addSubview:leftview];
    
    UIView *rightview = [[UIView alloc]initWithFrame:CGRectMake(UIScreenW/2 + 125*MYWIDTH, topview.bottom, UIScreenW/2 - 125*MYWIDTH, 320*MYWIDTH)];
    rightview.backgroundColor = [UIColor blackColor];
    rightview.alpha = 0.5;
    [_bgView addSubview:rightview];
    
    UIView *bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreenH/7*2+320*MYWIDTH, UIScreenW, UIScreenH/7*5 - 320*MYWIDTH)];
    bottomview.backgroundColor = [UIColor blackColor];
    bottomview.alpha = 0.5;
    [_bgView addSubview:bottomview];
    
    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"版本更新"]];
    bgImage.userInteractionEnabled = YES;
    bgImage.frame = CGRectMake(leftview.right-12*MYWIDTH, topview.bottom-12*MYWIDTH, 250*MYWIDTH+24*MYWIDTH, 320*MYWIDTH+24*MYWIDTH);
    [_bgView addSubview:bgImage];
    
    UIButton *backBut = [[UIButton alloc]initWithFrame:CGRectMake(bgImage.right-30*MYWIDTH, bgImage.y-10*MYWIDTH, 30*MYWIDTH, 30*MYWIDTH)];
    [backBut setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(backBanBenClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:backBut];
    
    UIImageView *huojianImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"火箭"]];
    huojianImage.frame = CGRectMake(UIScreenW/2 - 45*MYWIDTH, bgImage.y - 45*MYWIDTH, 90*MYWIDTH, 150*MYWIDTH);
    [_bgView addSubview:huojianImage];
    
    UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(30*MYWIDTH, bgImage.height/2, bgImage.width-60*MYWIDTH, 20)];
    textLab.text = @"当前已是最新版本";
    textLab.textColor = [UIColor blackColor];
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.font = [UIFont systemFontOfSize:17];
    [bgImage addSubview:textLab];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSLog(@"当前版本号%@",appVersion);
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30*MYWIDTH, textLab.bottom+30, bgImage.width-60*MYWIDTH, 60)];
    titleLab.text = [NSString stringWithFormat:@"当前版本号:%@\n\n更新时间:2017/09/23",appVersion];
    titleLab.numberOfLines = 0;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = UIColorFromRGB(0x666666);
    titleLab.font = [UIFont systemFontOfSize:13];
    [bgImage addSubview:titleLab];
}

#pragma mark -－－－－－－－－－－－－－－ 版本更新－－－－－－－－－－－－－－－－－－－－－－－－－－－
//版本更新
- (void)versionRequest{
    /*lxpub/app/version?
     
     action=getVersionInfo
     project=lx
     联祥           applelianxiang
     。。。
     */

    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    NSLog(@"app名字%@",appName);
    NSString *urlStr = [NSString stringWithFormat:@"%@:8004/lxpub/app/version?action=getVersionInfo&project=applembt",Ver_Address];
    NSDictionary *parameters = @{@"action":@"getVersionInfo",@"project":[NSString stringWithFormat:@"%@",@"applembt"]};
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:parameters success:^(id response) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
         NSSLog(@"版本信息:%@",dic);
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDic));
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSSLog(@"当前版本号%@",appVersion);
        NSString *version = dic[@"app_version"];
        NSString *nessary = dic[@"app_necessary"];
        _versionUrl = dic[@"app_url"];
        if ([version isEqualToString:appVersion]) {
            //当前版本
            [self setbanbenUIViewed];
        }else if(![version isEqualToString:appVersion]){
            if ([nessary isEqualToString:@"0"]) {
                //不强制更新
            }else if([nessary isEqualToString:@"1"]){
                //强制更新
            }
            [self setbanbenUIViewing];
        }

        
    } fail:^(NSError *error) {
        jxt_showAlertOneButton(@"提示", @"118服务器出现错误！", @"取消", ^(NSInteger buttonIndex) {
            
        });
    }];
    
}

- (void)upButClick:(UIButton*)sender{
    NSString *str = [NSString stringWithFormat:@"%@%@",@"itms-services://?action=download-manifest&url=",_versionUrl];
    NSURL *url = [NSURL URLWithString:str];
    
    [[UIApplication sharedApplication]openURL:url];

}


@end
