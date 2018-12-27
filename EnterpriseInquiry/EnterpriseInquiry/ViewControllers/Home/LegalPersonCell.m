//
//  LegalPersonCell.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/11/1.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "LegalPersonCell.h"
#import "ChangeDetailModel.h"


@interface LegalPersonCell ()

@property (nonatomic ,strong) UILabel *compLab;
@property (nonatomic ,strong) UILabel *beforeLab;
@property (nonatomic ,strong) UILabel *beforeTitle;
@property (nonatomic ,strong) UILabel *afterTitle;
@property (nonatomic ,strong) UILabel *afterLab;
@property (nonatomic ,strong) UILabel *timeLab;
@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong) UIView *lastView;//参考view

@end

@implementation LegalPersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.compLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.top.mas_equalTo(10);
            }];
            view.text = @"北京雷神科技有限责任公司";
            view.font = KFont(16);
            view;
        });
        
        self.timeLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_compLab);
                make.top.mas_equalTo(_compLab.mas_bottom).offset(5);
            }];
            view.font = KFont(13);
            view.textColor = KHexRGB(0x999999);
            view.text = @"2017-10-31";
            view;
        });
        
        
        self.beforeTitle = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.top.mas_equalTo(_timeLab.mas_bottom).offset(20);
                make.right.mas_equalTo(-KDeviceW/2-15);
            }];
            view.font = KFont(13);
            view.text = @"变更前：";
            view.textColor = KHexRGB(0x3075e1);
            view;
        });
        
        self.afterTitle = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(KDeviceW/2+15);
                make.top.mas_equalTo(_beforeTitle);
                make.right.mas_equalTo(-15);
            }];
            view.text = @"变更后：";
            view.font = KFont(13);
            view.textColor = KHexRGB(0xff6500);
            view;
        });
        
        self.beforeLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(_beforeTitle);
                make.top.mas_equalTo(_beforeTitle.mas_bottom).offset(15);
                make.bottom.mas_lessThanOrEqualTo(self.contentView).offset(-20);
            }];
            view.numberOfLines = 0;
            view.font = KFont(14);
            view.textColor = KHexRGB(0x333333);
            view;
        });
        
        
        
        self.afterLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(_afterTitle);
                make.top.mas_equalTo(_afterTitle.mas_bottom).offset(15);
                make.bottom.mas_lessThanOrEqualTo(self.contentView).offset(-20);
            }];
            view.numberOfLines = 0;
            view.font = KFont(14);
            view.textColor = KHexRGB(0x333333);
            view;
        });
        
        
        self.lineView = ({
            UIView *view = [UIView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_beforeTitle);
                make.bottom.mas_equalTo(self.contentView).offset(-20);
                make.centerX.mas_equalTo(self.contentView);
                make.width.mas_equalTo(1);
            }];
            view.backgroundColor = KHexRGB(0xd8d8d8);;
            view;
        });

    }
    return self;
}

- (void)setModel:(ChangeDetailModel *)model{
    _model = model;
    self.compLab.text = model.ename;
    self.timeLab.text = [Tools timestampSwitchTime:model.createDate];
    self.beforeLab.text = model.changeBefore;
    self.afterLab.text = model.changeAfter;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
