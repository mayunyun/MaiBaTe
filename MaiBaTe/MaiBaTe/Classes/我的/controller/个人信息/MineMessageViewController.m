//
//  MineMessageViewController.m
//  MaiBaTe
//
//  Created by 邱 德政 on 17/8/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MineMessageViewController.h"
#import "NIDropDown.h"
#import "NSDate+BRAdd.h"

@interface MineMessageViewController ()<NIDropDownDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIView *statusBarView;
    UIScrollView* _bgScroView;
    UIImageView *_headview;         //头像
    UITextField* _nameField;        //昵称
    UIButton* _sexBtn;              //性别
    UIButton* _birthBtn;            //出生年月
    UIButton* _yearBtn;             //生肖
    UIButton* _monthBtn;            //星座
    UITextField* _workField;        //职业
    UITextField* _cityField;        //城市
    UIButton* _improtBtn;           //收入水平
    UITextView* _carinformation;
    UIButton* _okBtn;
    NIDropDown *dropDown;
    BOOL _isClick;
    NSArray* _importArr;
}

@end

@implementation MineMessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"";
    UIImage *image = [UIImage imageNamed:@"iconfont-touming"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
    [self setStatusBarBackgroundColor:UIColorFromRGB(0x333333)];
//    [self.navigationController setNavigationBa rHidden:YES animated:NO];
    
}


//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [statusBarView removeFromSuperview];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
    if (statusbarHeight>20) {
        statusBarView.frame = CGRectMake(0, -44,    self.view.bounds.size.width, 44);
    }
    statusBarView.backgroundColor = color;
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isClick = NO;
    _importArr = @[@"3-5万/年",@"5-8万/年",@"8-11万/年",@"11-15万/年",@"15以上"];
    [self creatUI];
    
}

- (void)creatUI{
    _bgScroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -44, UIScreenW, UIScreenH)];
    _bgScroView.bounces = NO;
    _bgScroView.contentSize = CGSizeMake(UIScreenW, 900);
    _bgScroView.backgroundColor = UIColorFromRGB(MYBack);
    _bgScroView.showsVerticalScrollIndicator = NO;
    _bgScroView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bgScroView];
    //----------头
    UIImageView *bgimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenW, 220*MYWIDTH)];
    bgimage.userInteractionEnabled = YES;
    bgimage.image = [UIImage imageNamed:@"头像背景_1"];
    bgimage.userInteractionEnabled = YES;
    [_bgScroView addSubview:bgimage];
    
    UIImageView *headviewBG = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenW/2-55*MYWIDTH, bgimage.height/2-65*MYWIDTH, 110*MYWIDTH, 110*MYWIDTH)];
    headviewBG.image = [UIImage imageNamed:@"默认头像BG"];
    headviewBG.layer.masksToBounds = YES;
    headviewBG.userInteractionEnabled = YES;
    headviewBG.layer.cornerRadius = headviewBG.width/2;
    [bgimage addSubview:headviewBG];
    
    _headview = [[UIImageView alloc]initWithFrame:CGRectMake(12*MYWIDTH, 12*MYWIDTH, 86*MYWIDTH, 86*MYWIDTH)];
    _headview.image = [UIImage imageNamed:@"默认头像"];
    _headview.layer.masksToBounds = YES;
    _headview.userInteractionEnabled = YES;
    _headview.layer.cornerRadius = _headview.width/2;
    [headviewBG addSubview:_headview];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTapClick:)];
    [_headview addGestureRecognizer:tap];
    
    UIButton* eidtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    eidtBtn.frame = CGRectMake(UIScreenW-35, 15, 20, 20);
    [eidtBtn setBackgroundImage:[UIImage imageNamed:@"个人信息编辑"] forState:UIControlStateNormal];
    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:eidtBtn];
    self.navigationItem.rightBarButtonItem = left;
    [eidtBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //-----------第一个cell
    UIImageView* upView = [[UIImageView alloc]initWithFrame:CGRectMake(10*MYWIDTH, bgimage.bottom+35, UIScreenW - 20*MYWIDTH, 215)];
    upView.backgroundColor = [UIColor whiteColor];
    upView.userInteractionEnabled = YES;
    upView.layer.masksToBounds = YES;
    upView.layer.cornerRadius = 10;
    [_bgScroView addSubview:upView];
    //昵称
    UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*MYWIDTH, 20, 60*MYWIDTH, 30)];
    nameLabel.text = @"昵称";
    nameLabel.font = [UIFont systemFontOfSize:14*MYWIDTH];
    [upView addSubview:nameLabel];
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right, nameLabel.top, upView.width - nameLabel.right - 30*MYWIDTH, nameLabel.height)];
    _nameField.font = [UIFont systemFontOfSize:14*MYWIDTH];
    _nameField.layer.masksToBounds = YES;
    _nameField.layer.cornerRadius = _nameField.height/2;
    _nameField.backgroundColor = [UIColor clearColor];
    _nameField.textAlignment = NSTextAlignmentCenter;
    _nameField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _nameField.layer.borderWidth = 0.5;
    [upView addSubview:_nameField];
    //性别
    UILabel* sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+20, nameLabel.width, nameLabel.height)];
    sexLabel.text = @"性别";
    sexLabel.font = nameLabel.font;
    [upView addSubview:sexLabel];
    _sexBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _sexBtn.frame = CGRectMake(sexLabel.right, sexLabel.top, upView.width - sexLabel.right - 30, sexLabel.height);
    [_sexBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _sexBtn.tag = 1001;
    _sexBtn.layer.masksToBounds = YES;
    _sexBtn.layer.cornerRadius = _sexBtn.height/2;
    _sexBtn.backgroundColor = [UIColor clearColor];
    _sexBtn.layer.borderColor = _nameField.layer.borderColor;
    _sexBtn.layer.borderWidth = _nameField.layer.borderWidth;
    _sexBtn.titleLabel.font = _nameField.font;
    [upView addSubview:_sexBtn];
    [_sexBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addDownImgView:_sexBtn];

    //出生年月
    UILabel* birthLabel = [[UILabel alloc]initWithFrame:CGRectMake(sexLabel.left, sexLabel.bottom+20, sexLabel.width, sexLabel.height)];
    birthLabel.text = @"出生年月";
    birthLabel.font = sexLabel.font;
    [upView addSubview:birthLabel];
    _birthBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _birthBtn.frame = CGRectMake(birthLabel.right, birthLabel.top, upView.width - birthLabel.right - 30*MYWIDTH, birthLabel.height);
    _birthBtn.layer.masksToBounds = YES;
    _birthBtn.layer.cornerRadius = _birthBtn.height/2;
    _birthBtn.backgroundColor = [UIColor clearColor];
    _birthBtn.layer.borderWidth = _sexBtn.layer.borderWidth;
    _birthBtn.layer.borderColor = _sexBtn.layer.borderColor;
    _birthBtn.titleLabel.font = _nameField.font;
    [_birthBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [upView addSubview:_birthBtn];
    [_birthBtn addTarget:self action:@selector(birthBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addDownImgView:_birthBtn];
    UIView* birthbotView = [[UIView alloc]initWithFrame:CGRectMake(_birthBtn.left, _birthBtn.bottom, _birthBtn.width, upView.height - _birthBtn.bottom)];
    birthbotView.backgroundColor = [UIColor clearColor];
    [upView addSubview:birthbotView];
    UILabel* yearlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 40*MYWIDTH, birthbotView.height - 40)];
    yearlabel.text = @"生肖";
    yearlabel.font = [UIFont systemFontOfSize:13];
    [birthbotView addSubview:yearlabel];
    _yearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _yearBtn.frame = CGRectMake(yearlabel.right, yearlabel.top, 55*MYWIDTH, yearlabel.height);
    _yearBtn.backgroundColor = UIColorFromRGB(MYOrange);
    [_yearBtn setTitle:@"" forState:UIControlStateNormal];
    [_yearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _yearBtn.layer.masksToBounds = YES;
    _yearBtn.layer.cornerRadius = _yearBtn.height/2;
    [birthbotView addSubview:_yearBtn];
    [_yearBtn addTarget:self action:@selector(yearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel* monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(birthbotView.width/2, yearlabel.top, yearlabel.width, yearlabel.height)];
    monthLabel.text = @"星座";
    monthLabel.font = yearlabel.font;
    [birthbotView addSubview:monthLabel];
    _monthBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _monthBtn.frame = CGRectMake(birthbotView.width - 80*MYWIDTH, _yearBtn.top, 80*MYWIDTH, _yearBtn.height);
    _monthBtn.backgroundColor = UIColorFromRGB(MYOrange);
    [_monthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_monthBtn setTitle:@"" forState:UIControlStateNormal];
    _monthBtn.layer.masksToBounds = YES;
    _monthBtn.layer.cornerRadius = _monthBtn.height/2;
    [birthbotView addSubview:_monthBtn];
    [_monthBtn addTarget:self action:@selector(monthBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //----------------第二个cell
    UIImageView* downView = [[UIImageView alloc]initWithFrame:CGRectMake(upView.left, upView.bottom+20, upView.width, 380)];
    downView.userInteractionEnabled = YES;
    downView.layer.masksToBounds = YES;
    downView.layer.cornerRadius = 10;
    downView.backgroundColor = [UIColor whiteColor];
    [_bgScroView addSubview:downView];
    
    UILabel* jobLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.top, nameLabel.width, nameLabel.height)];
    jobLabel.text = @"职业";
    jobLabel.font = nameLabel.font;
    [downView addSubview:jobLabel];
    _workField = [[UITextField alloc]initWithFrame:CGRectMake(jobLabel.right, jobLabel.top, downView.width - jobLabel.right - 30*MYWIDTH, jobLabel.height)];
    _workField.backgroundColor = [UIColor clearColor];
    _workField.layer.masksToBounds = YES;
    _workField.font = _nameField.font;
    _workField.textAlignment = NSTextAlignmentCenter;
    _workField.layer.cornerRadius = _workField.height/2;
    _workField.layer.borderWidth = _birthBtn.layer.borderWidth;
    _workField.layer.borderColor = _birthBtn.layer.borderColor;
    [downView addSubview:_workField];
    
    UILabel* emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(jobLabel.left, jobLabel.bottom+20, jobLabel.width, jobLabel.height)];
    emailLabel.text = @"邮箱";
    emailLabel.font = nameLabel.font;
    [downView addSubview:emailLabel];
    UITextField *emailField = [[UITextField alloc]initWithFrame:CGRectMake(emailLabel.right, emailLabel.top, downView.width - emailLabel.right - 30*MYWIDTH, emailLabel.height)];
    emailField.userInteractionEnabled = NO;
    emailField.text = [NSString stringWithFormat:@"%@",self.model.email];
    emailField.backgroundColor = [UIColor clearColor];
    emailField.layer.masksToBounds = YES;
    emailField.font = _nameField.font;
    emailField.textAlignment = NSTextAlignmentCenter;
    emailField.layer.cornerRadius = _workField.height/2;
    emailField.layer.borderWidth = _birthBtn.layer.borderWidth;
    emailField.layer.borderColor = _birthBtn.layer.borderColor;
    [downView addSubview:emailField];
    
    UILabel* QQLabel = [[UILabel alloc]initWithFrame:CGRectMake(emailLabel.left, emailLabel.bottom+20, emailLabel.width, emailLabel.height)];
    QQLabel.text = @"QQ";
    QQLabel.font = nameLabel.font;
    [downView addSubview:QQLabel];
    UITextField *QQField = [[UITextField alloc]initWithFrame:CGRectMake(QQLabel.right, QQLabel.top, downView.width - QQLabel.right - 30*MYWIDTH, QQLabel.height)];
    QQField.userInteractionEnabled = NO;
    QQField.text = [NSString stringWithFormat:@"%@",self.model.qq];
    QQField.backgroundColor = [UIColor clearColor];
    QQField.layer.masksToBounds = YES;
    QQField.font = _nameField.font;
    QQField.textAlignment = NSTextAlignmentCenter;
    QQField.layer.cornerRadius = _workField.height/2;
    QQField.layer.borderWidth = _birthBtn.layer.borderWidth;
    QQField.layer.borderColor = _birthBtn.layer.borderColor;
    [downView addSubview:QQField];
    
    UILabel* WXLabel = [[UILabel alloc]initWithFrame:CGRectMake(QQLabel.left, QQLabel.bottom+20, QQLabel.width, QQLabel.height)];
    WXLabel.text = @"微信";
    WXLabel.font = nameLabel.font;
    [downView addSubview:WXLabel];
    UITextField *WXField = [[UITextField alloc]initWithFrame:CGRectMake(WXLabel.right, WXLabel.top, downView.width - WXLabel.right - 30*MYWIDTH, WXLabel.height)];
    WXField.userInteractionEnabled = NO;
    WXField.text = [NSString stringWithFormat:@"%@",self.model.wechat];
    WXField.backgroundColor = [UIColor clearColor];
    WXField.layer.masksToBounds = YES;
    WXField.font = _nameField.font;
    WXField.textAlignment = NSTextAlignmentCenter;
    WXField.layer.cornerRadius = _workField.height/2;
    WXField.layer.borderWidth = _birthBtn.layer.borderWidth;
    WXField.layer.borderColor = _birthBtn.layer.borderColor;
    [downView addSubview:WXField];
    
    UILabel* cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(WXLabel.left, WXLabel.bottom+20, WXLabel.width, WXLabel.height)];;
    cityLabel.font = jobLabel.font;
    cityLabel.text = @"城市";
    [downView addSubview:cityLabel];
    _cityField = [[UITextField alloc]initWithFrame:CGRectMake(cityLabel.right, cityLabel.top, downView.width - cityLabel.right - 30*MYWIDTH, cityLabel.height)];
    _cityField.backgroundColor = [UIColor clearColor];
    _cityField.layer.masksToBounds = YES;
    _cityField.font = _nameField.font;
    _cityField.textAlignment = NSTextAlignmentCenter;
    _cityField.layer.cornerRadius = _cityField.height/2;
    _cityField.layer.borderWidth = _workField.layer.borderWidth;
    _cityField.layer.borderColor = _workField.layer.borderColor;
    [downView addSubview:_cityField];
    UILabel* importLabel = [[UILabel alloc]initWithFrame:CGRectMake(cityLabel.left, cityLabel.bottom+20, cityLabel.width, cityLabel.height)];
    importLabel.font = cityLabel.font;
    importLabel.text = @"收入水平";
    [downView addSubview:importLabel];
    _improtBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _improtBtn.frame = CGRectMake(importLabel.right, importLabel.top, downView.width - importLabel.right - 30*MYWIDTH, importLabel.height);
    _improtBtn.layer.masksToBounds = YES;
    _improtBtn.tag = 1002;
    _improtBtn.layer.cornerRadius = _improtBtn.height/2;
    _improtBtn.layer.borderWidth = _cityField.layer.borderWidth;
    _improtBtn.layer.borderColor = _cityField.layer.borderColor;
    [_improtBtn setTitle:@"" forState:UIControlStateNormal];
    [_improtBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _improtBtn.titleLabel.font = _birthBtn.titleLabel.font;
    [downView addSubview:_improtBtn];
    [self addDownImgView:_improtBtn];
    [_improtBtn addTarget:self action:@selector(importBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel* carLabel = [[UILabel alloc]initWithFrame:CGRectMake(importLabel.left, importLabel.bottom+20, 1.6*importLabel.width, importLabel.height)];
    carLabel.text = @"电动车辆信息";
    carLabel.font = importLabel.font;
    [downView addSubview:carLabel];
//    _carinformation = [[UITextView alloc]initWithFrame:CGRectMake(carLabel.right, carLabel.top, downView.width - carLabel.right - 30*MYWIDTH, carLabel.height*2)];
//    _carinformation.backgroundColor = [UIColor clearColor];
//    [downView addSubview:_carinformation];
    
    
    _okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _okBtn.frame = CGRectMake(0, UIScreenH-44, UIScreenW, 44);
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okBtn setTitle:@"完成" forState:UIControlStateNormal];
    _okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_okBtn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_okBtn];
    [_okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self loadNew];
    [self isEnableClick:NO];
    
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
- (void)addDownImgView:(UIButton*)btn {
    UIImageView* sexdownimgView = [[UIImageView alloc]initWithFrame:CGRectMake(btn.width - 40, 10, 20, btn.height - 10*2)];
    sexdownimgView.image = [UIImage imageNamed:@"个人信息下拉"];
//  sexdownimgView.backgroundColor = [UIColor redColor];
    [btn addSubview:sexdownimgView];
}

- (void)editBtnClick:(UIButton*)sender{
    _isClick = !_isClick;
    if (_isClick) {
        sender.hidden = YES;
        [_okBtn setBackgroundColor:UIColorFromRGB(MYOrange)];
        [self isEnableClick:YES];
    }else{
        sender.hidden = NO;
        [_okBtn setBackgroundColor:UIColorFromRGB(MYBack)];
        [self isEnableClick:NO];
    }

}

- (void)importBtnClick:(UIButton*)sender{
    NSArray * arrImage = [[NSArray alloc] init];
    arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], nil];
    if(dropDown == nil) {
        CGFloat f = 100;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :_importArr :arrImage :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (void)sexBtnClick:(UIButton*)sender{
    NSArray * arrImage = [[NSArray alloc] init];
    arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], nil];
    NSArray* sexArr = @[@"男",@"女"];
    if(dropDown == nil) {
        CGFloat f = 80;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :sexArr :arrImage :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (void)birthBtnClick:(UIButton*)sender{
    __weak typeof(UIButton*) weakBtn = sender;
    __weak typeof(self) weakSelf = self;
    [BRDatePickerView showDatePickerWithTitle:@"出生年月" dateType:UIDatePickerModeDate defaultSelValue:weakBtn.titleLabel.text minDateStr:@"" maxDateStr:[NSDate currentDateString] isAutoSelect:YES resultBlock:^(NSString *selectValue) {
        [weakBtn setTitle:selectValue forState:UIControlStateNormal];
        
        NSArray *array = [selectValue componentsSeparatedByString:@"-"];
        if (array.count == 3) {
            NSString* month = array[1];
            NSString* day = array[2];
            NSString* shengxiao = [weakSelf testStr:array[0]];
            NSString* xingzuo =[weakSelf getConstellationWithMonth:[month intValue] day:[day intValue]];
            [_yearBtn setTitle:shengxiao forState:UIControlStateNormal];
            [_monthBtn setTitle:xingzuo forState:UIControlStateNormal];
        }
    }];
}

- (void)yearBtnClick:(UIButton*)sender{

}

- (void)monthBtnClick:(UIButton*)sender{

}

- (void)okBtnClick:(UIButton*)sender{
    [self updateCustomerRequest];
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender index:(NSInteger)index{
    [self rel];
    
//    _orderselectFlag = [NSString stringWithFormat:@"%li",(long)index];
//    NSLog(@"点击了那个id%@",_orderstatuIdArray[index]);
//    _orderselect = YES;
}
-(void)rel{
    dropDown = nil;
}
-(NSString*)testStr:(NSString *)str{
    NSArray *array=@[@"鼠_4",@"牛_5",@"虎_6",@"兔_7",@"龙_8",@"蛇_9",@"马_10",@"羊_11",@"猴_0",@"鸡_1",@"狗_2",@"猪_3"];
    NSString* returnstr;
    for (int i=0; i<array.count; i++) {
        if ([[array[i] componentsSeparatedByString:@"_"][1] isEqualToString:[NSString stringWithFormat:@"%ld",[str integerValue]%12]]) {
            returnstr = [array[i] componentsSeparatedByString:@"_"][0];
            NSLog(@"属%@",[array[i] componentsSeparatedByString:@"_"][0]);
        }
    }
    return returnstr;
}

- (NSString *)getConstellationWithMonth:(int)m_ day:(int)d_
{
    NSString * astroString = @"摩羯座水瓶座双鱼座白羊座金牛座双子座巨蟹座狮子座处女座天秤座天蝎座射手座摩羯座";
    NSString * astroFormat = @"102123444543";
    NSString * result;
    
    result = [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m_*3-(d_ < [[astroFormat substringWithRange:NSMakeRange((m_-1), 1)] intValue] - (-19))*3, 3)]];
    
    return result;
}

- (void)isEnableClick:(BOOL)isClick{
    _nameField.userInteractionEnabled = isClick;
    _sexBtn.userInteractionEnabled = isClick;
    _birthBtn.userInteractionEnabled = isClick;
    _workField.userInteractionEnabled = isClick;
    _cityField.userInteractionEnabled = isClick;
    _improtBtn.userInteractionEnabled = isClick;
    _carinformation.userInteractionEnabled = isClick;
    _okBtn.userInteractionEnabled = isClick;
}

- (void)loadNew{
    _nameField.text = [NSString stringWithFormat:@"%@",self.model.custname];
    NSString* sex;
    if ([self.model.sex integerValue] == 0) {
        sex = @"男";
    }else{
        sex = @"女";
    }
    [_sexBtn setTitle:sex forState:UIControlStateNormal];
    [_birthBtn setTitle:self.model.birthday forState:UIControlStateNormal];
    NSArray *array = [_birthBtn.titleLabel.text componentsSeparatedByString:@"-"];
    if (array.count == 3) {
        NSString* month = array[1];
        NSString* day = array[2];
        NSString* shengxiao = [self testStr:array[0]];
        NSString* xingzuo =[self getConstellationWithMonth:[month intValue] day:[day intValue]];
        [_yearBtn setTitle:shengxiao forState:UIControlStateNormal];
        [_monthBtn setTitle:xingzuo forState:UIControlStateNormal];
    }
    _workField.text = self.model.occupation;
    _cityField.text = self.model.addressdetail;
    NSInteger i = [self.model.incomelevel intValue];
    [_improtBtn setTitle:_importArr[i] forState:UIControlStateNormal];
    _carinformation.text = self.model.vehicle_information;
    
    if (![[NSString stringWithFormat:@"%@",self.model.autoname] isEqualToString:@"(null)"]) {
        NSString *image = [NSString stringWithFormat:@"%@/%@/%@",PHOTO_ADDRESS,self.model.folder,self.model.autoname];
        NSLog(@"%@",image);
        [_headview sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
}

- (void)updateCustomerRequest{
    /*
     客户信息修改  /mbtwz/wxcustomer?action=updatecustomer    "+callback1
     参数：custname昵称   sex性别 ,birthday生日,occupation职业,addressdetail城市, incomelevel 收入放在data中
     */
    _nameField.text = [Command convertNull:_nameField.text];
    NSString* sex;
    if ([_sexBtn.titleLabel.text isEqualToString:@"男"]) {
        sex = @"0";
    }else if([_sexBtn.titleLabel.text isEqualToString:@"女"]){
        sex = @"1";
    }
    NSString* improtBtnid;
    for (int i = 0; i <_importArr.count; i++) {
        if ([_improtBtn.titleLabel.text isEqualToString:_importArr[i]]) {
            improtBtnid = [NSString stringWithFormat:@"%d",i];
        }
    }
    
    _birthBtn.titleLabel.text = [Command convertNull:_birthBtn.titleLabel.text];
    _workField.text = [Command convertNull:_workField.text];
    _cityField.text = [Command convertNull:_cityField.text];
    _improtBtn.titleLabel.text = [Command convertNull:_improtBtn.titleLabel.text];
    NSString* urlstr = @"/mbtwz/wxcustomer?action=updatecustomer";
    NSDictionary* params = @{@"data":[NSString stringWithFormat:@"{\"custname\":\"%@\",\"sex\":\"%@\",\"birthday\":\"%@\",\"occupation\":\"%@\",\"addressdetail\":\"%@\",\"incomelevel\":\"%@\"}",_nameField.text,sex,_birthBtn.titleLabel.text,_workField.text,_cityField.text,improtBtnid]};
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id response) {
        [SVProgressHUD dismiss];
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSSLog(@">>>%@",str);
        if ([str rangeOfString:@"true"].location!=NSNotFound) {
            jxt_showToastTitle(@"个人信息修改成功", 1);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            jxt_showToastTitle(@"个人信息修改失败", 1);
        }
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}
- (void)imgViewTapClick:(UITapGestureRecognizer*)tap{
    UIActionSheet* sheet = [[UIActionSheet alloc
                             ]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册里选择照片", @"现在就拍一张", nil];
    sheet.tag = 1001;
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //头像
    if (actionSheet.tag == 1001) {
        if (0 == buttonIndex) {
            [self LocalPhoto];
        } else if (1 == buttonIndex) {
            [self takePhoto];
        }
    }
    
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        // DLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        //修改图片的大小为90*90
        image = [self thumbnailImage:CGSizeMake(90.0, 90.0) withImage:image];
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        [self requestPortal:data img:image];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

//修改头像大小
- (UIImage*)thumbnailImage:(CGSize)targetSize withImage:(UIImage*)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width * screenScale;
    CGFloat targetHeight = targetSize.height * screenScale;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //DLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestPortal:(NSData*)imgData img:(UIImage*)img {
    //NSData 转 Base64
    //    NSString* imgStr = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //        NSLog(@"上传图片的请求imgStr%@",imgStr);
#pragma mark 上传图片的请求
    //    [_headerBtn setImage:img forState:UIControlStateNormal];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/mbtwz/wxcustomer?action=uploadCustomerImage"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    [HTNetWorking uploadWithImage:img url:urlStr filename:fileName name:@"img" mimeType:@"image/jpeg" parameters:nil progress:^(int64_t bytesWritten, int64_t totalBytesWritten) {
        
    } success:^(id response) {
        NSString* str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"上传头像返回%@",str);
        if ([str rangeOfString:@"true"].location != NSNotFound) {
            _headview.image = img;
            [Command customAlert:@"头像上传成功"];
        }
    } fail:^(NSError *error) {
        
    }];
    
    
}

//字符串转图片
-(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr
{
    NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:_encodedImageStr];
    UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
    return _decodedImage;
}


@end
