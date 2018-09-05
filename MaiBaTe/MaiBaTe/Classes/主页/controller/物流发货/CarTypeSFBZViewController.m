//
//  CarTypeSFBZViewController.m
//  MaiBaTe
//
//  Created by LONG on 2018/4/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CarTypeSFBZViewController.h"
#import "lconsCollectionViewCell.h"
@interface CarTypeSFBZViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic ,strong)UICollectionView *IconsCollectionView;
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation CarTypeSFBZViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"baiNat"];
    if (statusbarHeight>20) {
        image = [UIImage imageNamed:@"baiNat_X"];
    }
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0x333333)];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    titleLab.text = @"收费标准";
    titleLab.textColor = UIColorFromRGB(0x333333);
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLab];
    
    self.navigationItem.titleView = titleView;
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadNewselectVolMoneys];
    [self IconsCollectionView];

}
- (void)loadNewselectVolMoneys{
    //
    NSString *XWURLStr = @"/mbtwz/logisticsgoods?action=selectVolMoneys";
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    [HTNetWorking postWithUrl:XWURLStr refreshCache:YES params:nil success:^(id response) {
        [SVProgressHUD dismiss];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@">>%@",dic);
        if ([[dic objectForKey:@"response"] count]) {
            _dataArray = [dic objectForKey:@"response"];
        }
        [_IconsCollectionView reloadData];
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
- (UICollectionView *)IconsCollectionView{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 0;//行间距
    flowLayout.minimumLineSpacing = 0;//列间距
    if (_IconsCollectionView == nil) {
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, NavBarHeight, 200, 50*MYWIDTH)];
        title.text = @"按立方计算";
        title.font = [UIFont systemFontOfSize:14*MYWIDTH];
        title.textColor = UIColorFromRGB(0x333333);
        [self.view addSubview:title];
        
        _IconsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(15*MYWIDTH, title.bottom+ 10*MYWIDTH, UIScreenW-30*MYWIDTH, UIScreenH-NavBarHeight) collectionViewLayout:flowLayout];
        
        //隐藏滑块
        _IconsCollectionView.showsVerticalScrollIndicator = NO;
        _IconsCollectionView.showsHorizontalScrollIndicator = NO;
        
        _IconsCollectionView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        _IconsCollectionView.dataSource = self;
        _IconsCollectionView.delegate = self;
        //注册单元格
        [_IconsCollectionView registerNib:[UINib nibWithNibName:@"lconsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"lconsCollectionViewCellID"];
        [_IconsCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];  //  一定要设置
        
        [self.view addSubview:_IconsCollectionView];
    }
    return _IconsCollectionView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataArray count];
}
//调整Item的位置 使Item不紧挨着屏幕
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //在原有基础上进行调整 上 左 下 右
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((UIScreenW-30*MYWIDTH)/5, 90*MYWIDTH);
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HomeSelarCellID = @"lconsCollectionViewCellID";
    
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"lconsCollectionViewCell" bundle: [NSBundle mainBundle]];
    [_IconsCollectionView registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    
    lconsCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    
    if (_dataArray.count) {
        cell.titleVel.text = [NSString stringWithFormat:@"%@m³",[_dataArray[indexPath.row] objectForKey:@"weightrange"]];
        cell.price.text = [NSString stringWithFormat:@"￥%@",[_dataArray[indexPath.row] objectForKey:@"money"]];
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
