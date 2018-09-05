//
//  YuYueCarViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/10/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YuYueCarViewController.h"
#import "LoginViewController.h"
#import "BRPickerView.h"
#import "NSDate+BRAdd.h"

@interface YuYueCarViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIWebViewDelegate>{
    UIView *statusBarView;
    int Size_i;
    UITextField* _firstField;
    UITextField* _secondField;
    NSString *_createtime;
    UIWebView *webView;

}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *sizeArr;
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation YuYueCarViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.title = @"";
//    UIImage *image = [UIImage imageNamed:@"iconfont-touming"];
//    [self.navigationController.navigationBar setBackgroundImage:image
//                                                  forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:image];
//    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0x333333)];
    [self setStatusBarBackgroundColor:UIColorFromRGB(0x333333)];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    
}
//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//    [self.navigationItem.leftBarButtonItem setTintColor:NavBarItemColor];
    [statusBarView removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, 0,    self.view.bounds.size.width, 20)];
    if (statusbarHeight>20) {
        statusBarView.frame = CGRectMake(0, 0,    self.view.bounds.size.width, 44);
    }
    statusBarView.backgroundColor = color;
    [self.view addSubview:statusBarView];
    
    
}
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenH)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = UIColorFromRGB(0xFFFFFF);
        
        [self.view addSubview:_tableview];
        
        
        UIImageView *header = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenW*1.08)];
        header.image = [UIImage imageNamed:@"组-39.png"];
        header.userInteractionEnabled = YES;
        
        UIButton *backBut = [[UIButton alloc]initWithFrame:CGRectMake(header.width-50*MYWIDTH, 5, 50*MYWIDTH, 50*MYWIDTH)];
        [backBut addTarget:self action:@selector(backToLastViewControl) forControlEvents:UIControlEventTouchUpInside];
        [backBut setImage:[UIImage imageNamed:@"小关闭.png"] forState:UIControlStateNormal];
        [header addSubview:backBut];
        
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(15, UIScreenW/2, 130*MYWIDTH, 38*MYWIDTH)];
        [but setBackgroundImage:[UIImage imageNamed:@"组-59.png"] forState:UIControlStateNormal];
        [but setTitle:@"预约试驾" forState:UIControlStateNormal];
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:14];
        [but addTarget:self action:@selector(butclick) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:but];
        
        _tableview.tableHeaderView = header;
        
        UIView *food = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 100*MYWIDTH)];
        food.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _tableview.tableFooterView = food;
        
        UIButton *butup = [[UIButton alloc]initWithFrame:CGRectMake(5*MYWIDTH, 10*MYWIDTH, food.width-10*MYWIDTH, food.height-20*MYWIDTH)];
        butup.backgroundColor = UIColorFromRGB(0xDADBDB);
        butup.layer.cornerRadius = 5*MYWIDTH;
        [butup addTarget:self action:@selector(upButClick) forControlEvents:UIControlEventTouchUpInside];
        [food addSubview:butup];
        
        UIImageView *upimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_back_top"]];
        upimage.frame = CGRectMake(butup.width/2-10*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH, 20*MYWIDTH);
        upimage.userInteractionEnabled = YES;
        [butup addSubview:upimage];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, upimage.bottom, butup.width, butup.height-upimage.bottom)];
        lab.text = @"返回顶部预约试驾";
        lab.font = [UIFont systemFontOfSize:13];
        lab.textColor = UIColorFromRGB(0x555555);
        lab.textAlignment = NSTextAlignmentCenter;
        [butup addSubview:lab];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    }
    return _tableview;
    
}
- (void)upButClick{
    [_tableview setContentOffset:CGPointMake(0,-20) animated:YES];
}
- (void)loadNewData{
    [_tableview.mj_header endRefreshing];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArr = [[NSMutableArray alloc]init];
    _sizeArr = [[NSMutableArray alloc]init];
    Size_i = 0;

    [self tableview];

    [self detailDataRequest];
    //添加手势，为了关闭键盘的操作
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
}
- (void)backToLastViewControl{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArr.count) {
        //return _dataArr.count+1;
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_dataArr.count == indexPath.row){
//        return webView.frame.size.height;
//    }
//    if (_sizeArr.count == _dataArr.count) {
//        for (NSDictionary *dic in _sizeArr) {
//            if ([[dic objectForKey:@"w"] floatValue] == 0) {
//                return 0;
//            }
//            if ([[dic objectForKey:@"autoname"] isEqualToString: [_dataArr[indexPath.row] objectForKey:@"autoname"]]) {
//                return (UIScreenW/[[dic objectForKey:@"w"] floatValue])*[[dic objectForKey:@"h"] floatValue];
//            }
//        }
//    }
    if (_dataArr.count){
        return webView.frame.size.height;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellID = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell) {
        if (_dataArr.count) {
            [cell addSubview:webView];
            return cell;
        }
//        if (_dataArr.count>0&&_sizeArr.count<_dataArr.count) {
//            NSDictionary *dictionary = _dataArr[indexPath.row];
//            NSString *image = [NSString stringWithFormat:@"%@/%@%@",PHOTO_ADDRESS,[dictionary objectForKey:@"folder"],[dictionary objectForKey:@"autoname"]];
//            UIImageView *BGimageView = [[UIImageView alloc]init];
//            [BGimageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                CGSize size = image.size;
//                CGFloat W = size.width;
//                CGFloat H = size.height;
//                NSDictionary *dic = @{@"w":[NSString stringWithFormat:@"%.2f",W],@"h":[NSString stringWithFormat:@"%.2f",H],@"autoname":[dictionary objectForKey:@"autoname"]};
//                [_sizeArr addObject:dic];
//                if (W!=0) {
//                    BGimageView.frame = CGRectMake(0, 0, UIScreenW, UIScreenW/W*H);
//                }
//                [cell addSubview:BGimageView];
//                if (Size_i == _dataArr.count-1) {
//                    [_tableview reloadData];
//                }
//                Size_i++;
//            }];
//
//        }
        
    }
    return cell;
}
- (void)detailDataRequest{
    NSString *URLStr = @"/mbtwz/scshop?action=getProductDeatilBanner";
    NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"proid\":\"%@\"}",_id]};
    NSLog(@"%@",params);
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [_dataArr removeAllObjects];
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
        [SVProgressHUD dismiss];
        
        _dataArr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        NSSLog(@"详情列表%@",_dataArr);
        if (_dataArr.count) {
            webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 1)];
            webView.scrollView.bounces=NO;
            [webView sizeToFit];
            [self.view addSubview:webView];
            [self threadRun];
//            // 创建
//            NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadRun) object:nil];
//            // 启动
//            [thread start];
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
    
}
- (void)threadRun{
    
    NSString* linkCss = @"<style type=\"text/css\"> img {"
    "width:100%;"
    "height:auto;"
    "}"
    "p {"
    "word-wrap:break-word;"
    "}"
    "</style>";
    
    [webView loadHTMLString:[NSString stringWithFormat:@"%@%@",[_dataArr[0] objectForKey:@"note"],linkCss] baseURL:[NSURL URLWithString:WEB_ADDRESS]];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;

}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];

//    [webView stringByEvaluatingJavaScriptFromString:
//     @"var script = document.createElement('script');"
//     "script.type = 'text/javascript';"
//     "script.text = \"function ResizeImages() { "
//     "var myimg,oldwidth,oldheight;"
//     "var maxwidth=300;"// 图片宽度
//     "for(i=0;i <document.images.length;i++){"
//     "myimg = document.images[i];"
//     "if(myimg.width > maxwidth){"
//     "myimg.width = maxwidth;"
//     "}"
//     "}"
//     "}\";"
//     "document.getElementsByTagName('head')[0].appendChild(script);"];
//    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    CGFloat documentHeight= [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    NSLog(@"webView的高度-----%f",documentHeight);
    webView.frame = CGRectMake(0, 0, UIScreenW, documentHeight+50);
    [_tableview reloadData];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:@"正在加载..."];

    
    NSLog(@"webViewDidStartLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nonnull NSError *)error
{
    NSLog(@"didFailLoadWithError===%@", error);
}
- (void)butclick{
    [Command isloginRequest:^(bool str) {
        if (str) {
            //判断有没有预约过
            NSString *URLStr = @"/mbtwz/scshop?action=isApply";
            NSDictionary* params = @{@"params":[NSString stringWithFormat:@"{\"proid\":\"%@\"}",_id]};
            [SVProgressHUD showWithStatus:@"正在加载..."];
            [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
                [SVProgressHUD dismiss];
                
                NSArray* Arr = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                NSSLog(@"判断有没有预约过%@",Arr);
                if (Arr.count) {
                    if ([[NSString stringWithFormat:@"%@",[Arr[0] objectForKey:@"cou"]] isEqualToString:@"0"]) {
                        [self createUI];
                    }else{
                        jxt_showToastTitle(@"您已经预约该车！", 1);
                    }
                }
                

            } fail:^(NSError *error) {
                [SVProgressHUD dismiss];
                
            }];
        }else{
            jxt_showAlertTwoButton(@"您目前还没有登录", @"是否前往登录", @"取消", ^(NSInteger buttonIndex) {
                
            }, @"前往", ^(NSInteger buttonIndex) {
                LoginViewController* vc = [[LoginViewController alloc]init];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }
    }];
    
}
//预约弹框
- (void)createUI{
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert setTouchToHide:YES];
    [SMAlert setcontrolViewbackgroundColor:[UIColor whiteColor]];

    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(30*MYWIDTH, 0, UIScreenW-60*MYWIDTH, 300*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, 0, bgview.width-30*MYWIDTH, 60*MYWIDTH)];
    label.text = [NSString stringWithFormat:@"预约车型:%@",@""];
    if (_dataArr.count) {
        label.text = [NSString stringWithFormat:@"预约车型:%@",[_dataArr[0] objectForKey:@"specification"]];
    }
    label.font = [UIFont systemFontOfSize:15*MYWIDTH];
    label.textColor = UIColorFromRGB(0x333333);
    [bgview addSubview:label];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 60*MYWIDTH, bgview.width, 1)];
    xian.backgroundColor = UIColorFromRGB(MYLine);
    [bgview addSubview:xian];
    
    NSArray *titleArr = @[@"预约姓名",@"联系方式",@"到店时间"];
    for (int i=0; i<titleArr.count; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, xian.bottom+10*MYWIDTH + i*57*MYWIDTH, 80*MYWIDTH, 57*MYWIDTH)];
        lab.text = titleArr[i];
        lab.font = [UIFont systemFontOfSize:15*MYWIDTH];
        lab.textColor = UIColorFromRGB(0x333333);
        [bgview addSubview:lab];
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(80*MYWIDTH, lab.top+10*MYWIDTH, 7*MYWIDTH, 7*MYWIDTH)];
        imageview.image = [UIImage imageNamed:@"星号"];
        [bgview addSubview:imageview];
    }
    
    _firstField = [[UITextField alloc]initWithFrame:CGRectMake(100*MYWIDTH, xian.bottom + 22.5*MYWIDTH, bgview.width-115*MYWIDTH, 35*MYWIDTH)];
    _firstField.delegate = self;
    _firstField.placeholder = @"请填写您的姓名";
    _firstField.font = [UIFont systemFontOfSize:13*GMYWIDTH];
    _firstField.textAlignment = NSTextAlignmentCenter;
    [bgview addSubview:_firstField];
    [Command placeholderColor:_firstField str:_firstField.placeholder color:UIColorFromRGB(0x999999)];
    [self layerView:_firstField];
    
    _secondField = [[UITextField alloc]initWithFrame:CGRectMake(100*MYWIDTH, _firstField.bottom+20*MYWIDTH, _firstField.width, _firstField.height)];
    _secondField.delegate = self;
    _secondField.keyboardType = UIKeyboardTypeNumberPad;
    _secondField.placeholder = @"请填写您的联系方式";
    _secondField.textAlignment = NSTextAlignmentCenter;
    _secondField.font = [UIFont systemFontOfSize:13*GMYWIDTH];
    [bgview addSubview:_secondField];
    [Command placeholderColor:_secondField str:_secondField.placeholder color:UIColorFromRGB(0x999999)];
    [self layerView:_secondField];
    
    UIButton* qusBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    qusBtn.frame = CGRectMake(100*MYWIDTH, _secondField.bottom+20*MYWIDTH, _secondField.width, _secondField.height);
    [qusBtn setTitle:@"请选择您的到店时间" forState:UIControlStateNormal];
    [qusBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    qusBtn.titleLabel.font = [UIFont systemFontOfSize:13*GMYWIDTH];
    [bgview addSubview:qusBtn];
    [self layerView:qusBtn];
    [qusBtn addTarget:self action:@selector(qusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* downView = [[UIImageView alloc]initWithFrame:CGRectMake(qusBtn.width - 30*GMYWIDTH, (qusBtn.height - 10*GMYWIDTH)/2, 14*GMYWIDTH, 10*GMYWIDTH)];
    downView.image = [UIImage imageNamed:@"个人信息下拉"];
    [qusBtn addSubview:downView];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, bgview.bottom-50*MYWIDTH, bgview.width, 50*MYWIDTH)];
    [but setBackgroundColor:UIColorFromRGB(MYColor)];
    [but setTitle:@"提交预约" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:14];
    [but addTarget:self action:@selector(TJbutclick) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:but];
    
    [SMAlert showCustomView:bgview];
}
- (void)TJbutclick{
    if ([[Command convertNull:_firstField.text] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写您的姓名", 1);
        return ;
    }
    if (![Command isMobileNumber:[Command convertNull:_secondField.text]]) {
        jxt_showToastTitle(@"请填写正确的手机号", 1);
        return;
    }
    if ([[Command convertNull:_createtime] isEqualToString:@""]) {
        jxt_showToastTitle(@"请选择到店时间", 1);
        return ;
    }
    NSString *URLStr = @"/mbtwz/scshop?action=addApply";
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"id\":\"%@\",\"unname\":\"%@\",\"unphone\":\"%@\",\"createtime\":\"%@\"}",_id,_firstField.text,_secondField.text,_createtime]};
    NSLog(@"%@",params);
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
        [SVProgressHUD dismiss];
        NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
        NSSLog(@"提交预约%@",str);
        [SMAlert hide:NO];
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            jxt_showToastTitle(@"预约操作失败", 1);
        }else{
            jxt_showToastTitle(@"预约试驾成功", 1);
        }

        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
- (void)qusBtnClick:(UIButton*)sender{
    NSDate *dates = [NSDate date];
    NSTimeInterval interval = 60 * 60 * 24 * 30;
    NSDate *detea = [NSDate dateWithTimeInterval:interval sinceDate:dates];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"BeiJing"];
    [dateformatter setTimeZone:timeZone];
    NSString *  locationString=[dateformatter stringFromDate:detea];
    
    [_firstField resignFirstResponder];
    [_secondField resignFirstResponder];
    __weak typeof(UIButton*) weakBtn = sender;
    [BRDatePickerView showDatePickerWithTitle:@"到店时间" dateType:UIDatePickerModeDate defaultSelValue:nil minDateStr:[NSDate currentDateString] maxDateStr:locationString isAutoSelect:YES resultBlock:^(NSString *selectValue) {
        [weakBtn setTitle:selectValue forState:UIControlStateNormal];
        _createtime = selectValue;
    }];
}
- (void)layerView:(UIView*)qusBtn{
    qusBtn.layer.borderWidth = 0.5;
    qusBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    qusBtn.layer.masksToBounds = YES;
    qusBtn.layer.cornerRadius = qusBtn.height*0.5;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    kKeyWindow.frame = CGRectMake(0, 0, UIScreenW, UIScreenH);

}

- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    [UIView animateWithDuration:0.5 animations:^{
        kKeyWindow.frame = CGRectMake(0, -UIScreenH/3, UIScreenW, UIScreenH);
    }];
}
@end
