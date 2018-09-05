//
//  MeTabviewHeaderView.m
//  MaiBaTe
//
//  Created by LONG on 17/8/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MeTabviewHeaderView.h"

@implementation MeTabviewHeaderView{
    UILabel *_headtitle;
    UIImageView *_headview;
    UIImageView * levImage;
    UIImageView *bgimage;
}
- (void)settitledata:(MeModel *)data{
    
    if (![[NSString stringWithFormat:@"%@",data.autoname] isEqualToString:@"(null)"]) {
        NSString *image = [NSString stringWithFormat:@"%@/%@/%@",PHOTO_ADDRESS,data.folder,data.autoname];
        NSLog(@"%@",image);
        [_headview sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }else{
        _headview.image = [UIImage imageNamed:@"默认头像"];

    }
    if ([[NSString stringWithFormat:@"%@",data.isdriver] isEqualToString:@"1"]) {
        _starV.hidden = NO;
        //bgimage.userInteractionEnabled = YES;
        [self searchDriverScore];
    }else{
        _starV.hidden = YES;
        //bgimage.userInteractionEnabled = NO;
        
    }
    if ([[NSString stringWithFormat:@"%@",data.custname] isEqualToString:@"(null)"]) {
        _headtitle.text = @"麦巴特用户";
    }else{
        _headtitle.text = [NSString stringWithFormat:@"%@",data.custname];
    }
    
    UILabel *balancelab = [self viewWithTag:270];
    NSLog(@">>>%@",data.balance);
    if ([[NSString stringWithFormat:@"%@",data.balance] isEqualToString:@"(null)"]) {
        balancelab.text = @"0.00";
    }else{
        balancelab.text = [NSString stringWithFormat:@"%.2f",[data.balance doubleValue]];
    }

    UILabel *ticketslab = [self viewWithTag:271];
    if ([[NSString stringWithFormat:@"%@",data.tickets] isEqualToString:@"(null)"]) {
        ticketslab.text = @"0";
    }else{
        ticketslab.text = [NSString stringWithFormat:@"%@",data.count];
    }
    
    UILabel *scoreslab = [self viewWithTag:272];
    if ([[NSString stringWithFormat:@"%@",data.scores] isEqualToString:@"(null)"]) {
        scoreslab.text = @"0";
    }else{
        scoreslab.text = [NSString stringWithFormat:@"%@",data.scores];

    }

    
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self createUI];
    }
    return self;
}
-(void)createUI{
    bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 200*MYWIDTH)];
    bgimage.image = [UIImage imageNamed:@"头像背景"];
    bgimage.userInteractionEnabled = YES;
    [self addSubview:bgimage];
    
    UIImageView *headviewBG = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW/2-55*MYWIDTH, bgimage.height/2-65*MYWIDTH, 110*MYWIDTH, 110*MYWIDTH)];
    headviewBG.image = [UIImage imageNamed:@"默认头像BG"];
    headviewBG.layer.masksToBounds = YES;
    headviewBG.layer.cornerRadius = headviewBG.width/2;
    [bgimage addSubview:headviewBG];
    
    _headview = [[UIImageView alloc]initWithFrame:CGRectMake(12*MYWIDTH, 12*MYWIDTH, 86*MYWIDTH, 86*MYWIDTH)];
    _headview.image = [UIImage imageNamed:@"默认头像"];
    _headview.layer.masksToBounds = YES;
    _headview.layer.cornerRadius = _headview.width/2;
    [headviewBG addSubview:_headview];
    
    _headtitle  = [[UILabel alloc]initWithFrame:CGRectMake(headviewBG.x, headviewBG.bottom+3, headviewBG.width, 20)];
    _headtitle.text = @"麦巴特用户";
    _headtitle.textAlignment = NSTextAlignmentCenter;
    _headtitle.textColor = UIColorFromRGB(0x333333);
    _headtitle.font = [UIFont systemFontOfSize:13];
    [bgimage addSubview:_headtitle];
    //星星评价等级
    _starV = [[UIView alloc]initWithFrame:CGRectMake(UIScreenW/2-(_headtitle.width+140*MYWIDTH)/2, _headtitle.bottom, _headtitle.width+140*MYWIDTH, 20*MYWIDTH)];
//    _starV.backgroundColor = [UIColor cyanColor];
    [bgimage addSubview:_starV];
    levImage = [[UIImageView alloc]initWithFrame:CGRectMake(_headtitle.x-_headtitle.width/2-18*MYWIDTH, 3*MYWIDTH, 13.5*MYWIDTH, 17.5*MYWIDTH)];
//    levImage.backgroundColor = [UIColor redColor];
    levImage.image = [UIImage imageNamed:@"lv0"];
    [_starV addSubview:levImage];
    _xingxingView = [[WQLStarView alloc]initWithFrame:CGRectMake(levImage.right+7*MYWIDTH,1*MYWIDTH, _headtitle.width-20*MYWIDTH,20*MYWIDTH) withTotalStar:5 withTotalPoint:5 starSpace:2*MYWIDTH];
    _xingxingView.starAliment = StarAlimentDefault;
    _xingxingView.commentPoint = 0;
    [_starV addSubview:_xingxingView];
    UIImageView * rArrow = [[UIImageView alloc]initWithFrame:CGRectMake(_xingxingView.right+5*MYWIDTH, 7*MYWIDTH, 8*MYWIDTH, 12*MYWIDTH)];
    rArrow.image = [UIImage imageNamed:@"youjiantou_1"];
    [_starV addSubview:rArrow];
    //登录
    UIButton *LoginBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/2-55*MYWIDTH, bgimage.height/2-65*MYWIDTH, 110*MYWIDTH, 110*MYWIDTH+20)];
    [bgimage addSubview:LoginBut];
    [LoginBut addTarget:self action:@selector(LoginButClick) forControlEvents:UIControlEventTouchUpInside];
    //
//    UIImageView *qbimage = [[UIImageView alloc]initWithFrame:CGRectMake(15, bgimage.bottom+10*MYWIDTH, 20*MYWIDTH , 15*MYWIDTH)];
//    qbimage.image = [UIImage imageNamed:@"我的钱包_1"];
//    [self addSubview:qbimage];
//
//    UILabel *qbtitle  = [[UILabel alloc]initWithFrame:CGRectMake(qbimage.right+5, bgimage.bottom+5*MYWIDTH, 100, 25*MYWIDTH)];
//    qbtitle.text = @"我的钱包";
//    qbtitle.textColor = UIColorFromRGB(0x333333);
//    qbtitle.font = [UIFont systemFontOfSize:11];
//    [self addSubview:qbtitle];
//
//    UIImageView *gdimage = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW - 35, bgimage.bottom+8*MYWIDTH, 18*MYWIDTH , 18*MYWIDTH)];
//    gdimage.image = [UIImage imageNamed:@"更多(1)"];
//    [self addSubview:gdimage];
//
//    UIButton *qianbaoBut = [[UIButton alloc]initWithFrame:CGRectMake(0, bgimage.bottom, UIScreenW, 35*MYWIDTH)];
//    [self addSubview:qianbaoBut];
//    [qianbaoBut addTarget:self action:@selector(qianbaoClick) forControlEvents:UIControlEventTouchUpInside];
    
    //
//    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, qbimage.bottom+10*MYWIDTH, UIScreenW , 65*MYWIDTH)];
//    bgview.backgroundColor = UIColorFromRGB(0x333333);
//    [self addSubview:bgview];
//
//    NSArray *titleArr = @[@"余额",@"优惠券",@"积分"];
//    for (int i=0; i<titleArr.count; i++) {
//        UILabel *titlelab  = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW/3*i, 5*MYWIDTH, UIScreenW/3, 25*MYWIDTH)];
//        titlelab.text = titleArr[i];
//        titlelab.textAlignment = NSTextAlignmentCenter;
//        titlelab.textColor = UIColorFromRGB(0xF4F4F4);
//        titlelab.backgroundColor = [UIColor clearColor];
//        titlelab.font = [UIFont systemFontOfSize:12];
//        [bgview addSubview:titlelab];
//    }
//
//    NSArray *numerArr = @[@"0.00",@"0",@"0"];
//    for (int i=0; i<numerArr.count; i++) {
//        UILabel *numerlab  = [[UILabel alloc]initWithFrame:CGRectMake(UIScreenW/3*i, 28*MYWIDTH, UIScreenW/3, 30*MYWIDTH)];
//        numerlab.text = numerArr[i];
//        numerlab.tag = i+270;
//        numerlab.textAlignment = NSTextAlignmentCenter;
//        numerlab.textColor = [UIColor whiteColor];
//        numerlab.backgroundColor = [UIColor clearColor];
//        numerlab.font = [UIFont systemFontOfSize:15];
//        [bgview addSubview:numerlab];
//
//        UIButton *YuEBut = [[UIButton alloc]initWithFrame:CGRectMake(UIScreenW/3*i, 0, UIScreenW/3, 65*MYWIDTH)];
//        YuEBut.tag = i + 260;
//        [bgview addSubview:YuEBut];
//        [YuEBut addTarget:self action:@selector(YuEButClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//
//    for (int i=0; i<2; i++) {
//        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(UIScreenW/3*(i+1), 33*MYWIDTH, 0.5, 25*MYWIDTH)];
//        xian.backgroundColor = UIColorFromRGB(0x666666);
//        [bgview addSubview:xian];
//    }
}
- (void)qianbaoClick{
    [self.delegate MeTabviewHeaderViewBtnHaveString:4];
}
- (void)YuEButClick:(UIButton *)but{
    [self.delegate MeTabviewHeaderViewBtnHaveString:(int)(but.tag-260)];

}
//登录
- (void)LoginButClick{
    [self.delegate MeTabviewHeaderViewBtnHaveString:5];
}
-(void)searchDriverScore{
    NSString *url = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/mbtwz/find?action=selectDriverEvaluationTotal"];
    [HTNetWorking postWithUrl:url refreshCache:YES params:nil success:^(id response) {
        [SVProgressHUD dismiss];
        NSString * result = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"司机评价星分%@",result);
        if ([result isEqualToString:@"\"0\""]) {
            _xingxingView.commentPoint = 0;
            levImage.image = [UIImage imageNamed:@"lv0"];
        }else if ([result isEqualToString:@"\"1\""]){
            _xingxingView.commentPoint = 1;
            levImage.image = [UIImage imageNamed:@"lv1"];
        }else if ([result isEqualToString:@"\"2\""]){
            _xingxingView.commentPoint = 2;
            levImage.image = [UIImage imageNamed:@"lv2"];
        }else if ([result isEqualToString:@"\"3\""]){
            _xingxingView.commentPoint = 3;
            levImage.image = [UIImage imageNamed:@"lv3"];
        }else if ([result isEqualToString:@"\"4\""]){
            _xingxingView.commentPoint = 4;
            levImage.image = [UIImage imageNamed:@"lv4"];
        }else{
            _xingxingView.commentPoint = 5;
            levImage.image = [UIImage imageNamed:@"lv5"];
        }
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
@end
