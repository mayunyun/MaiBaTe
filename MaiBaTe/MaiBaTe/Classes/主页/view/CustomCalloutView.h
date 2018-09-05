//
//  CustomCalloutView.h
//  ikkyuchegjbus
//
//  Created by 石家庄盛航 on 16/9/29.
//  Copyright © 2016年 sjzshtx. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomAnnotationViewDelegate <NSObject>

//-(void)quJiaYou;   //去加油

@end
@interface CustomCalloutView : UIView
@property (nonatomic, strong) UIImage *image; //商户图
@property (nonatomic, copy) NSString *title; //商户名
@property (nonatomic, copy) NSString *subtitle; //地址
//@property (nonatomic, copy) NSString *distance;//距离
//@property (nonatomic, strong) UIButton *btn;
@property(nonatomic,weak) id<CustomAnnotationViewDelegate> delegate;

@end
