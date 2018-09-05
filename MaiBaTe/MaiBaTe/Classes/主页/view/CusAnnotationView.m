//
//  CusAnnotationView.m
//  ikkyuchegjbus
//
//  Created by 石家庄盛航 on 16/9/29.
//  Copyright © 2016年 sjzshtx. All rights reserved.
//

#import "CusAnnotationView.h"

@interface CusAnnotationView ()
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong, readwrite) CustomCalloutView *calloutView;

@end
@implementation CusAnnotationView
@synthesize portraitImageView   = _portraitImageView;
#define kWidth  40.f
#define kHeight 40.f
#define kCalloutWidth       SCREEN_WIDTH-60
#define kCalloutHeight      90.0
- (UIImage *)portrait{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait{
    self.portraitImageView.image = portrait;
}
- (void)setSelected:(BOOL)selected{
    [self setSelected:selected animated:NO];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    if (self.selected == selected){
        return;
    }
    
    if (selected){
        if (self.calloutView == nil){
            
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        
        self.calloutView.image = [UIImage imageNamed:@"气泡"];
        self.calloutView.title = self.annotation.title;
        self.calloutView.subtitle = self.annotation.subtitle;
//        self.calloutView.distance = self.annotation.
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL inside = [super pointInside:point withEvent:event];
    if (!inside && self.selected){
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        
        self.backgroundColor = [UIColor clearColor];
        
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        
        
        [self addSubview:self.portraitImageView];
        
        
    }
    
    return self;
}

@end
