//
//  MBTNavBar.m
//  MaiBaTe
//
//  Created by apple on 17/8/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MBTNavBar.h"

@implementation MBTNavBar

- (id)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        
    }
    return self;
}

- (void)layoutSubviews

{
    [super layoutSubviews];

    
    for(UIView *btn in self.subviews)
    {
        if(![btn isKindOfClass:[UIButton class]]) continue;
        
        if(btn.centerX < self.width*0.5)
        {
            btn.x=5;
        }
        if(btn.centerX >=self.width * 0.5)
        {
            btn.x = self.width - btn.width - 5;
        }
        
        
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
