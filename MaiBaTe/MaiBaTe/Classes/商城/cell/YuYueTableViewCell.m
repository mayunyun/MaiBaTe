//
//  YuYueTableViewCell.m
//  MaiBaTe
//
//  Created by 钱龙 on 17/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YuYueTableViewCell.h"

@implementation YuYueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setData:(MyApplyModel *)data{
    _data = data;
    _titleView.text = [NSString stringWithFormat:@"预约车型:%@",data.proname];
    if ([data.isvalid isEqual:@0]) {
        _cornerLabel.backgroundColor = [UIColor colorWithRed:1.00 green:0.70 blue:0.24 alpha:1.00];
        _statusLabel.textColor = [UIColor colorWithRed:1.00 green:0.70 blue:0.24 alpha:1.00];
        _statusLabel.text = [NSString stringWithFormat:@"%@",@"待审核"];
    }else if ([data.isvalid isEqual:@1]){
        _cornerLabel.backgroundColor = [UIColor colorWithRed:0.00 green:0.67 blue:0.29 alpha:1.00];
        _statusLabel.textColor = [UIColor colorWithRed:0.00 green:0.67 blue:0.29 alpha:1.00];
        _statusLabel.text = [NSString stringWithFormat:@"%@",@"审核通过"];
    }else if ([data.isvalid isEqual:@2]){
        _cornerLabel.backgroundColor = [UIColor colorWithRed:1.00 green:0.00 blue:0.09 alpha:1.00];
        _statusLabel.textColor = [UIColor colorWithRed:1.00 green:0.00 blue:0.09 alpha:1.00];
        _statusLabel.text = [NSString stringWithFormat:@"%@",@"审核未通过"];
    }else{
        _cornerLabel.backgroundColor = [UIColor colorWithRed:1.00 green:0.70 blue:0.24 alpha:1.00];
        _statusLabel.textColor = [UIColor colorWithRed:1.00 green:0.70 blue:0.24 alpha:1.00];
        _statusLabel.text = [NSString stringWithFormat:@"%@",@"审核中"];
    }
    _nameLabel.text = [NSString stringWithFormat:@"预约姓名:%@",data.unname];
    _telphoneLabel.text = [NSString stringWithFormat:@"%@",data.unphone];
    _timeLabel.text = [NSString stringWithFormat:@"到店时间:%@",data.createtime];
    _annotateLabel.text = [NSString stringWithFormat:@"注:%@",data.note];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [self createUI];
        
    }
    return self;
}
-(void)createUI{
    _bgview = [[UIView alloc]init];
    _bgview.backgroundColor = [UIColor whiteColor];
    _bgview.layer.cornerRadius = 8.f;
    [self.contentView addSubview:_bgview];
    //圆点
    _cornerLabel = [[UILabel alloc]init];
    _cornerLabel.backgroundColor = [UIColor orangeColor];
    [_bgview addSubview:_cornerLabel];
    //预约车型
    _titleView = [[UILabel alloc]init];
    _titleView.textColor = UIColorFromRGB(0x333333);
    _titleView.font = [UIFont systemFontOfSize:14];
    [_bgview addSubview:_titleView];
    //审核状态
    _statusLabel = [[UILabel alloc]init];
    _statusLabel.textColor = [UIColor orangeColor];
    _statusLabel.textAlignment = NSTextAlignmentRight;
    _statusLabel.font = [UIFont systemFontOfSize:12];
    [_bgview addSubview:_statusLabel];
    //分割线
    _line1View = [[UILabel alloc]init];
    _line1View.backgroundColor = [UIColor lightGrayColor];
    [_bgview addSubview:_line1View];
    //姓名
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textColor = UIColorFromRGB(0x333333);
    _nameLabel.font = [UIFont systemFontOfSize:12];
    
    [_bgview addSubview:_nameLabel];
    //联系电话
    _telphoneLabel = [[UILabel alloc]init];
    _telphoneLabel.textColor = UIColorFromRGB(0x333333);
    _telphoneLabel.font = [UIFont systemFontOfSize:12];
    _telphoneLabel.textAlignment = NSTextAlignmentRight;
    [_bgview addSubview:_telphoneLabel];
    //到店时间
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = UIColorFromRGB(0x333333);
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [_bgview addSubview:_timeLabel];
    //分割线
    _line2View = [[UILabel alloc]init];
    _line2View.backgroundColor = [UIColor lightGrayColor];
    [_bgview addSubview:_line2View];
    //注解
    _annotateLabel = [[UILabel alloc]init];
    
    _annotateLabel.font = [UIFont systemFontOfSize:12];
    _annotateLabel.textColor = [UIColor lightGrayColor];
    [_bgview addSubview:_annotateLabel];
    //删除按钮
//    _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_delBtn setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
//    [_delBtn addTarget:self action:@selector(cutBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [_bgview addSubview:_delBtn];
    

}
-(void)cutBtnClick{
    if (_btnClickBlock) {
        self.btnClickBlock();
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];

#pragma mark - 添加约束
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    //背景
    _bgview.sd_layout
    .leftSpaceToView(contentView,margin)
    .topEqualToView(contentView)
    .rightSpaceToView(contentView,margin)
    .bottomEqualToView(contentView);

    //圆点
    _cornerLabel.sd_layout
    .leftSpaceToView(_bgview,margin)
    .topSpaceToView(_bgview,2*margin)
    .widthIs(10)
    .heightIs(10);
    _cornerLabel.sd_cornerRadiusFromWidthRatio =@(0.5);
    //预约车型
    _titleView.sd_layout
    .leftSpaceToView(_cornerLabel,margin)
    .topSpaceToView(_bgview,2*margin)
    .widthIs(250)
    .heightIs(10);
    //审核状态
    _statusLabel.sd_layout
    .rightSpaceToView(_bgview,margin)
    .topSpaceToView(_bgview,2*margin)
    .widthIs(70)
    .heightIs(10);
    //分割线
    _line1View.sd_layout
    .leftSpaceToView(_bgview,0)
    .topSpaceToView(_titleView,margin)
    .rightSpaceToView(_bgview,0)
    .heightIs(0.5);
    //预约姓名
    _nameLabel.sd_layout
    .leftSpaceToView(_bgview,3*margin)
    .topSpaceToView(_line1View,2*margin)
    .widthIs(200)
    .heightIs(10);
    //联系电话
    _telphoneLabel.sd_layout
    .rightSpaceToView(_bgview,margin)
    .topSpaceToView(_line1View,2*margin)
    .widthIs(150)
    .heightIs(10);
    //到店时间
    _timeLabel.sd_layout
    .leftSpaceToView(_bgview,3*margin)
    .topSpaceToView(_nameLabel,2*margin)
    .widthIs(200)
    .heightIs(10);
    //分割线
    _line2View.sd_layout
    .leftSpaceToView(_bgview,0)
    .topSpaceToView(_timeLabel,2*margin)
    .rightSpaceToView(_bgview,0)
    .heightIs(0.5);
    //注解
    _annotateLabel.sd_layout
    .leftSpaceToView(_bgview,margin)
    .topSpaceToView(_line2View,margin)
    .widthIs(UIScreenW-20)
    .heightIs(10);
//    //删除按钮
//    _delBtn.sd_layout
//    .widthIs(14)
//    .topSpaceToView(_line2View,margin)
//    .rightSpaceToView(_bgview,1.5*margin)
//    .heightIs(15);


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
