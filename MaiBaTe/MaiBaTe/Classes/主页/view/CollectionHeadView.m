//
//  CollectionHeadView.m
//  MaiBaTe
//
//  Created by LONG on 17/8/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CollectionHeadView.h"
#import "NewAllViewController.h"

@implementation CollectionHeadView{
    CGFloat _margin;
    
    int _totalloc;
    
    NSMutableArray *_imagesURLStrings;
    NSMutableArray *_iDStrings;
    
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _imagesURLStrings = [[NSMutableArray alloc]init];
        _iDStrings = [[NSMutableArray alloc]init];
        [self createUI];
        [self dataHeadView];
    }
    return self;
}
-(void)dataHeadView{
    //Banner
    [_imagesURLStrings removeAllObjects];
    NSString *URLStrBanner = @"/mbtwz/index?action=getActivity";
    [Command loadDataWithParams:nil withPath:URLStrBanner completionBlock:^(NSArray *responseObject, NSError *error) {
        NSSLog(@"轮播图%@",responseObject);
        if (responseObject) {
            //建立模型
            for (NSDictionary*dic in responseObject ) {
                HuoDongModel *model=[[HuoDongModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                //追加数据
                [_iDStrings addObject:model];
                NSString *image = [NSString stringWithFormat:@"%@/%@%@",PHOTO_ADDRESS,[dic objectForKey:@"folder"],[dic objectForKey:@"autoname"]];
                
                //追加数据
                [_imagesURLStrings addObject:image];
            }
            
            self.cycleScrollView.imageURLStringsGroup = _imagesURLStrings;
        }
    } autoShowError:YES];
}
-(void)createUI{
    
    
    // 网络加载 --- 创建带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UIScreenW, 215*MYWIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
    
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.currentPageDotColor = NavBarItemColor; // 自定义分页控件小圆标颜色
    [self addSubview:self.cycleScrollView];
    //self.cycleScrollView.placeholderImage = [UIImage imageNamed:@"banner"];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(16*MYWIDTH, self.cycleScrollView.bottom + 20*MYWIDTH, UIScreenW-32*MYWIDTH, UIScreenW-32*MYWIDTH)];
    bgview.backgroundColor = [UIColor clearColor];
    [self addSubview:bgview];
    NSArray *butArr = @[@"车辆销售",@"车辆租赁",@"物流发货",@"物流找货"];
    NSArray *butimageArr = @[@"车辆销售-1",@"车辆租赁-1",@"物流发货-1",@"物流找货-1"];
    for (int i=0; i<4; i++) {
        UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
        
        but.frame = CGRectMake(i%2*(bgview.width/2+5*MYWIDTH), i/2*(bgview.width/2+5*MYWIDTH), bgview.width/2-5*MYWIDTH, bgview.width/2-5*MYWIDTH);
        but.layer.cornerRadius = 7*MYWIDTH;
        [but setAdjustsImageWhenHighlighted:NO];
        [but setTitle:butArr[i] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:13];
        but.backgroundColor = [UIColor whiteColor];
        [but setImage:[UIImage imageNamed:butimageArr[i]] forState:UIControlStateNormal];
        // button标题的偏移量
        but.titleEdgeInsets = UIEdgeInsetsMake(but.imageView.frame.size.height+10, -but.imageView.bounds.size.width, 0,0);
        // button图片的偏移量
        but.imageEdgeInsets = UIEdgeInsetsMake(0, but.titleLabel.frame.size.width/2, but.titleLabel.frame.size.height+10, -but.titleLabel.frame.size.width/2);
        but.tag = +i;
        [but addTarget:self action:@selector(Classbut:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:but];
    }
    
    //
//    _totalloc=2;
//    CGFloat appvieww=35*MYWIDTH;
//    CGFloat appviewh=35*MYWIDTH;
//
//    NSArray *dataarr = @[@"我的钱包",@"车辆租赁",@"物流发货",@"物流找货"];
//    NSArray *imagearr = @[@"我的钱包_2",@"车辆租赁",@"物流发货",@"物流找货"];
//
//    for (int i = 0; i<[dataarr count]; i++) {
//
//        CGFloat appviewx = 42*MYWIDTH + (UIScreenW/2) * (i%2);
//        CGFloat appviewy = 215*MYWIDTH + 125*MYWIDTH/4 - 17*MYWIDTH + 125*MYWIDTH/2 * (i/2);
//        //
//
//        UIImageView *butimage = [[UIImageView alloc]initWithFrame:CGRectMake(appviewx, appviewy, 35*MYWIDTH, 35*MYWIDTH)];
//        butimage.image = [UIImage imageNamed:imagearr[i]];
//        butimage.tag = 10+i;
//        butimage.userInteractionEnabled = YES;
//        [self addSubview:butimage];
//
//
//
//        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
//        [butimage addGestureRecognizer:tapRecognizer];
//        //
//        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(appviewx+30, appviewy, appvieww+50, appviewh)];
//        but.tag = i;
//        [but setTitle:dataarr[i] forState:UIControlStateNormal];
//        but.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
//        but.titleLabel.font = [UIFont systemFontOfSize:14];
//        [but setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
//        [but addTarget:self action:@selector(Classbut:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:but];
//
//    }
//
//    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(20, 215*MYWIDTH + 125*MYWIDTH/2, UIScreenW-40, 0.5)];
//    xian1.backgroundColor = UIColorFromRGB(0xF4F4F4);
//    [self addSubview:xian1];
//
//    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(UIScreenW/2, 215*MYWIDTH + 10, 0.5, 125*MYWIDTH-20)];
//    xian2.backgroundColor = UIColorFromRGB(0xF4F4F4);
//    [self addSubview:xian2];
}

- (void)Classbut:(UIButton *)but{
    [self.delegate CollectionHeadBtnHaveString:(NSInteger *)but.tag];
}
- (void)SingleTap:(UITapGestureRecognizer*)recognizer  {
    [self.delegate CollectionHeadBtnHaveString:(NSInteger *)(recognizer.view.tag-10)];
    
    
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (cycleScrollView == self.cycleScrollView) {
        NSLog(@"---点击了专题第%ld张图片", (long)index);
        NewAllViewController *newAll = [[NewAllViewController alloc]init];
        newAll.hidesBottomBarWhenPushed = YES;
        newAll.type = 2;
        if (_iDStrings) {
            newAll.huomodel = _iDStrings[index];
        }
        [self.viewController.navigationController pushViewController:newAll animated:YES];
    }
}

@end

