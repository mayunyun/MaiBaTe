//
//  AddZuLinModel.h
//  MaiBaTe
//
//  Created by LONG on 2017/12/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AddZuLinModel : JSONModel
@property (nonatomic,strong)NSString *model_id;
@property (nonatomic,strong)NSString *carname;
@property (nonatomic,assign)NSInteger count;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *order_type;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString *during_time;


@end
