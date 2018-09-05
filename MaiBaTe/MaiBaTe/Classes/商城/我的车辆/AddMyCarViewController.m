//
//  AddMyCarViewController.m
//  MaiBaTe
//
//  Created by LONG on 2017/10/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AddMyCarViewController.h"

@interface AddMyCarViewController ()
@property (weak, nonatomic) IBOutlet UITextField *cartype;
@property (weak, nonatomic) IBOutlet UITextField *maxpeople;
@property (weak, nonatomic) IBOutlet UITextField *maxspeed;
@property (weak, nonatomic) IBOutlet UITextField *maxway;
@property (weak, nonatomic) IBOutlet UITextField *power;
@property (weak, nonatomic) IBOutlet UITextField *engine;

@end

@implementation AddMyCarViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"NarBg"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"车辆信息";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addMyCarBut:(UIButton *)sender {
    NSString *URLStr = @"/mbtwz/elecar?action=addMyCar";
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"cartype\":\"%@\",\"maxpeople\":\"%@\",\"maxspeed\":\"%@\",\"maxway\":\"%@\",\"power\":\"%@\",\"engine\":\"%@\"}",_cartype.text,_maxpeople.text,_maxspeed.text,_maxway.text,_power.text,_engine.text]};

    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
        
        NSString* str = [[NSString alloc]initWithData:response encoding:kCFStringEncodingUTF8];
        NSLog(@"%@",str);
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            jxt_showToastTitle(@"操作失败", 1);
        }else{
            jxt_showToastTitle(@"操作成功", 1);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
