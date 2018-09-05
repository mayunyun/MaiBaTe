//
//  CustomCalloutView.m
//  ikkyuchegjbus
//
//  Created by 石家庄盛航 on 16/9/29.
//  Copyright © 2016年 sjzshtx. All rights reserved.
//

#import "CustomCalloutView.h"

#define kPortraitMargin     10
 #define PortraitMargin     10

#define kTitleWidth         SCREEN_WIDTH-80
#define kTitleHeight        60
#define kArrorHeight        20
#define ArrorHeight        10

@interface CustomCalloutView ()
@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *distanceLabel;

@end
@implementation CustomCalloutView
- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
}

- (void)setImage:(UIImage *)image
{
    self.portraitView.image = image;
}
- (void)setDistance:(NSString *)distance{
    self.distanceLabel.text = distance;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    // 添加图片，即定位小图标的图片
//    self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(kPortraitMargin-5, 40+PortraitMargin, kArrorHeight, kArrorHeight)];
//    [self addSubview:self.portraitView];
    
    // 添加标题，即商户名
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin, PortraitMargin, kTitleWidth, kTitleHeight)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = @"titletitletitletitle";
    [self addSubview:self.titleLabel];
    
    // 添加副标题，即商户地址
//    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin, 20+PortraitMargin, kTitleWidth, kTitleHeight)];
//    self.subtitleLabel.font = [UIFont systemFontOfSize:12];
//    self.subtitleLabel.textColor = [UIColor lightGrayColor];
//    self.subtitleLabel.text = @"subtitleLabelsubtitleLabelsubtitleLabel";
//    [self addSubview:self.subtitleLabel];
    
    //添加距离，即距离中心点的距离
//    self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin+15, 40+PortraitMargin, kTitleWidth, kTitleHeight)];
//    self.distanceLabel.font = [UIFont systemFontOfSize:12];
//    self.distanceLabel.textColor = [UIColor lightGrayColor];
//    self.distanceLabel.text = @"distanceLabel";
//    [self addSubview:self.distanceLabel];
    
    //加油btn
//    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(kTitleWidth-60, 48, 50, 25)];
//    self.btn.layer.masksToBounds = YES;
//    self.btn.layer.cornerRadius = 5;
//    [self.btn setTitle:@"去加油" forState:UIControlStateNormal];
//    self.btn.titleLabel.font = [UIFont systemFontOfSize:12];
//    self.btn.backgroundColor = [UIColor redColor];
//    [self addSubview:self.btn];
//    [self.btn addTarget:self action:@selector(jiayou:) forControlEvents:UIControlEventTouchUpInside];
    
}
//- (void)jiayou:(UIButton *)btn{
//    NSLog(@"quJiaYou");
//    [self.delegate quJiaYou];
//    
//    NSLog(@"%@=%@=%@", self.subtitleLabel, self.titleLabel,self.distanceLabel);
//}
#pragma mark - draw rect

- (void)drawRect:(CGRect)rect{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context{
    
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-ArrorHeight;
    
    CGContextMoveToPoint(context, midx+ArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+ArrorHeight);
    CGContextAddLineToPoint(context,midx-ArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

@end
