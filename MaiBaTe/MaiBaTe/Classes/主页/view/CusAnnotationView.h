//
//  CusAnnotationView.h
//  ikkyuchegjbus
//
//  Created by 石家庄盛航 on 16/9/29.
//  Copyright © 2016年 sjzshtx. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"

@interface CusAnnotationView : MAAnnotationView
@property (nonatomic, strong) UIImage *portrait;

@property (nonatomic, readonly) CustomCalloutView *calloutView;

@end
