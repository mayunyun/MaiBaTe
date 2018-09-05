//
//  AboutMeViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/8/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AboutMeViewController.h"
#import "WXApi.h"
#import "LSActionView.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"
#import "AboutWXViewController.h"
@interface AboutMeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableview;

@end

@implementation AboutMeViewController

- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        //_tableview.scrollEnabled = NO;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.view addSubview:_tableview];
        
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 180*MYWIDTH)];
        UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW/2-100*MYWIDTH, 60*MYWIDTH, 200*MYWIDTH, 60*MYWIDTH)];
        bgimage.image = [UIImage imageNamed:@"关于我们"];
        [bgview addSubview:bgimage];
        _tableview.tableHeaderView = bgview;
        
    }
    return _tableview;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"关于我们";
    [self tableview];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67*MYWIDTH;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15*MYWIDTH;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 15*MYWIDTH)];
    view.backgroundColor = UIColorFromRGB(0xEEEEEE);
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString* cellID = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    
    NSArray *arr = @[@[@"新功能介绍",@"常见问题"],@[@"推荐给好友",@"关注麦巴特微信公众号"]];
    cell.textLabel.text = arr[indexPath.section][indexPath.row];
    if (indexPath.row == 1 || (indexPath.section == 1 && indexPath.row == 2)) {
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 1)];
        xian.backgroundColor = UIColorFromRGB(MYLine);
        [cell addSubview:xian];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0&&indexPath.row == 0) {
        jxt_showToastTitle(@"正在开发中", 1);
    }else if (indexPath.section == 0&&indexPath.row == 1){
        jxt_showToastTitle(@"正在开发中", 1);
    }
    if(indexPath.section == 1&&indexPath.row == 0){
        [self wxlogin];
    }else if (indexPath.section == 1&&indexPath.row == 1){
        AboutWXViewController *aboutwx = [[AboutWXViewController alloc]init];
        [self.navigationController pushViewController:aboutwx animated:YES];
    }
    
    NSLog(@"%ld",indexPath.row);
}


- (void)wxlogin{
    NSArray* images = @[@"shareweixin",@"sharemoments",@"sharecollect"];//,@"sharecollect"
    NSArray* titles = @[@"分享到好友",@"分享到朋友圈",@"分享到收藏"];//,@"分享到空间"
    
    WXMediaMessage* message = [WXMediaMessage message];
    message.title = @"麦巴特";
    message.description = @"麦巴特新能源平台";
    UIImageView *image = [[UIImageView alloc]init];
    [image sd_setImageWithURL:[NSURL URLWithString:@"http://www.adanshi.com/logo.png"] placeholderImage:nil];
    [message setThumbImage:[UIImage imageNamed:@"LOGO.png"]];
    WXWebpageObject* webpage = [WXWebpageObject object];
    webpage.webpageUrl = @"http://120.27.21.89/maibate/maibatewz/weixin/page/xiazai.html";
    message.mediaObject = webpage;
    
    [[LSActionView sharedActionView] showWithImages:images titles:titles actionBlock:^(NSInteger index) {
        NSLog(@"Action trigger at %ld:", (long)index);
        if (index == 0) {
            //WXSceneSession
            if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
            {
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
                req.bText = NO;
                req.message = message;
                req.scene = WXSceneSession;
                [WXApi sendReq:req];
            }else{
                jxt_showAlertOneButton(@"您没有安装微信客户端", nil, @"确定", nil);
            }
        }else if (index == 1){
            if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
            {
                //WXSceneTimeline
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
                req.bText = NO;
                req.message = message;
                req.scene = WXSceneTimeline;
                [WXApi sendReq:req];
             }else{
                 jxt_showAlertOneButton(@"您没有安装微信客户端", nil, @"确定", nil);
             }
        }else if (index == 2){
            if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
            {
                //WXSceneTimeline
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
                req.bText = NO;
                req.message = message;
                req.scene = WXSceneFavorite;
                [WXApi sendReq:req];
            }else{
                jxt_showAlertOneButton(@"您没有安装微信客户端", nil, @"确定", nil);
            }
            
        }else if (index == 3){
            // 设置预览图片
            NSURL *previewURL = [NSURL URLWithString:@"…"];
            // 设置分享链接
            NSURL* url = [NSURL URLWithString: @"…"];
            QQApiNewsObject* imgObj = [QQApiNewsObject objectWithURL:url title: @"…" description: @"…" previewImageURL:previewURL];
            // 设置分享到QZone的标志位
            [imgObj setCflag: kQQAPICtrlFlagQZoneShareOnStart ];
            SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            [self handleSendResult:sent];
        }
    }];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}


@end
