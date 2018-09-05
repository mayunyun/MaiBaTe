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
//@property (weak, nonatomic) IBOutlet UITextField *maxspeed;
//@property (weak, nonatomic) IBOutlet UITextField *maxway;
//@property (weak, nonatomic) IBOutlet UITextField *power;
//@property (weak, nonatomic) IBOutlet UITextField *engine;
//@property (weak, nonatomic) IBOutlet UITextField *note;

@end

@implementation AddMyCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"车辆信息";
    //添加手势，为了关闭键盘的操作
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addMyCarBut:(UIButton *)sender {
    if ([[Command convertNull:_cartype.text] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写车牌号", 1);
        return;
    }
    if ([[Command convertNull:_maxpeople.text] isEqualToString:@""]) {
        jxt_showToastTitle(@"请填写车辆名称", 1);
        return;
    }
//    if ([[Command convertNull:_maxspeed.text] isEqualToString:@""]) {
//        jxt_showToastTitle(@"请填写最高车速", 1);
//        return;
//    }
//    if ([[Command convertNull:_maxway.text] isEqualToString:@""]) {
//        jxt_showToastTitle(@"请填写续航里程", 1);
//        return;
//    }
//    if ([[Command convertNull:_power.text] isEqualToString:@""]) {
//        jxt_showToastTitle(@"请填写电机功率", 1);
//        return;
//    }
//    if ([[Command convertNull:_engine.text] isEqualToString:@""]) {
//        jxt_showToastTitle(@"请填写发动机型号", 1);
//        return;
//    }
    NSString *URLStr = @"/mbtwz/elecar?action=addMyCar";
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"cartype\":\"%@\",\"maxpeople\":\"%@\",\"maxspeed\":\"%@\",\"maxway\":\"%@\",\"power\":\"%@\",\"engine\":\"%@\",\"note\":\"%@\"}",_cartype.text,_maxpeople.text,@"0",@"0",@"0",@"0",@"0"]};

    [HTNetWorking postWithUrl:URLStr refreshCache:YES params:params success:^(id response) {
                
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        if ([str rangeOfString:@"false"].location!=NSNotFound) {
            jxt_showToastTitle(@"操作失败", 1);
        }else if([str rangeOfString:@"true"].location!=NSNotFound){
            jxt_showToastTitle(@"操作成功", 1);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            jxt_showToastTitle(str, 2);
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
