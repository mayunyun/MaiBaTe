//
//  CollectionReusableView.m
//  MaiBaTe
//
//  Created by LONG on 2017/9/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CollectionReusableView.h"

@implementation CollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self createUI];
        [self loadNewData];
    }
    return self;
}
- (void)loadNewData{
    NSString *URLStr = @"/mbtwz/scshop?action=getIndexImageWx";
    
    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:nil success:^(id response) {
        
        NSArray* array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        NSSLog(@"轮播图%@",array);
        if (array.count) {
            NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
            //建立模型
            for (NSDictionary*dic in array ) {
                
                NSString *image = [NSString stringWithFormat:@"%@/%@%@",PHOTO_ADDRESS,[dic objectForKey:@"folder"],[dic objectForKey:@"autoname"]];
                
                //追加数据
                [imagesURLStrings addObject:image];
            }
            
            self.cycleScrollView.imageURLStringsGroup = imagesURLStrings;
        }
        
        
    } fail:^(NSError *error) {
        
    }];
}
-(void)createUI{
    
    
    // 网络加载 --- 创建带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UIScreenW, UIScreenW*37/50) delegate:self placeholderImage:[UIImage imageNamed:@"shangchengBaner"]];
    
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.currentPageDotColor = NavBarItemColor; // 自定义分页控件小圆标颜色
    [self addSubview:self.cycleScrollView];
    
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (cycleScrollView == self.cycleScrollView) {
        NSLog(@"---点击了专题第%ld张图片", (long)index);
        
    }
}
@end

