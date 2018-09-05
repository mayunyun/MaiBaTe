//
//  ChargeSouSuoViewController.m
//  MaiBaTe
//
//  Created by LONG on 17/9/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ChargeSouSuoViewController.h"
#import "BRPickerView.h"
#import "NSDate+BRAdd.h"

@interface ChargeSouSuoViewController (){
    UIButton *_createtimebutton;
    UIButton *_endtimebutton;
}

@end

@implementation ChargeSouSuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"搜索";
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(15, 64+50*MYWIDTH, UIScreenW-30, 200*MYWIDTH)];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.layer.cornerRadius = 8;
    [self.view addSubview:bgview];
    
    UILabel *createtimeLab = [UILabel labelWithTitle:@"开始日期" TitleColor:UIColorFromRGB(0x333333) titleFont:[UIFont systemFontOfSize:13] textAligment:NSTextAlignmentCenter bgColor:nil rect:CGRectMake(10,0,70,100*MYWIDTH)];
    createtimeLab.font = [UIFont systemFontOfSize:14];
    [bgview addSubview:createtimeLab];
    
    UILabel *endtimeLab = [UILabel labelWithTitle:@"结束日期" TitleColor:UIColorFromRGB(0x333333) titleFont:[UIFont systemFontOfSize:13] textAligment:NSTextAlignmentCenter bgColor:nil rect:CGRectMake(10,100*MYWIDTH,70,100*MYWIDTH)];
    endtimeLab.font = [UIFont systemFontOfSize:14];
    [bgview addSubview:endtimeLab];
    
    _createtimebutton = [UIButton buttonWithTitle:@"日期选择" TitleColor:UIColorFromRGB(0x666666) titleFont:[UIFont systemFontOfSize:13] image:nil backgroundImage:nil bgColor:[UIColor whiteColor] rect:CGRectMake(80, 25*MYWIDTH, bgview.width-100, 50*MYWIDTH) state:UIControlStateNormal target:self action:@selector(createtimebuttonClick:)];
    _createtimebutton.layer.borderColor = UIColorFromRGB(0xF4F4F4).CGColor;//边框颜色
    _createtimebutton.layer.borderWidth = 1;//边框宽度
    _createtimebutton.layer.cornerRadius = 8.0;
    [bgview addSubview:_createtimebutton];
    
    _endtimebutton = [UIButton buttonWithTitle:@"日期选择" TitleColor:UIColorFromRGB(0x666666) titleFont:[UIFont systemFontOfSize:13] image:nil backgroundImage:nil bgColor:[UIColor whiteColor] rect:CGRectMake(80, 125*MYWIDTH, bgview.width-100, 50*MYWIDTH) state:UIControlStateNormal target:self action:@selector(endtimebuttonClick:)];
    _endtimebutton.layer.borderColor = UIColorFromRGB(0xF4F4F4).CGColor;//边框颜色
    _endtimebutton.layer.borderWidth = 1;//边框宽度
    _endtimebutton.layer.cornerRadius = 8.0;
    [bgview addSubview:_endtimebutton];
    
    
    UIButton *But = [[UIButton alloc]init];
    [But setFrame:CGRectMake(UIScreenW/2-75*MYWIDTH,bgview.bottom+70*MYWIDTH, 150*MYWIDTH, 50*MYWIDTH)];
    ;
    [But setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
    [But setTitle:@"搜索" forState:UIControlStateNormal];
    But.layer.cornerRadius = 5.0;
    [But addTarget:self action:@selector(ButClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:But];
}

- (void)createtimebuttonClick:(UIButton *)but{
    [BRDatePickerView showDatePickerWithTitle:@"日期选择" dateType:UIDatePickerModeDate defaultSelValue:@"" minDateStr:@"" maxDateStr:[NSDate currentDateString] isAutoSelect:YES resultBlock:^(NSString *selectValue) {
        [but setTitle:selectValue forState:UIControlStateNormal];
    }];
    
}
- (void)endtimebuttonClick:(UIButton *)but{
    [BRDatePickerView showDatePickerWithTitle:@"日期选择" dateType:UIDatePickerModeDate defaultSelValue:@"" minDateStr:@"" maxDateStr:[NSDate currentDateString] isAutoSelect:YES resultBlock:^(NSString *selectValue) {
        [but setTitle:selectValue forState:UIControlStateNormal];
        
        
    }];
}

- (void)ButClicked{
    if (_block) {
        NSString *create = _createtimebutton.titleLabel.text;
        NSString *end = _endtimebutton.titleLabel.text;

        if ([create isEqualToString:@"日期选择"]) {
            create = nil;
        }
        if ([end isEqualToString:@"日期选择"]) {
            end = nil;
        }
        _block(create,end);

    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
