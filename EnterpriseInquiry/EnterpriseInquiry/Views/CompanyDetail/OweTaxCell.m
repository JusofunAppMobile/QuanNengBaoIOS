//
//  OweTaxCell.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/11/9.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "OweTaxCell.h"
#import "OweTaxModel.h"

@interface OweTaxCell ()
@property (nonatomic ,strong) UILabel *numLab;
@property (nonatomic ,strong) UILabel *moneyLab;
@property (nonatomic ,strong) UILabel *typeLab;
@property (nonatomic ,strong) UILabel *timeLab;

@end

@implementation OweTaxCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *numTitle = [UILabel new];
        [self.contentView addSubview:numTitle];
        [numTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-KDeviceW/2-10);
            make.top.mas_equalTo(self.contentView).offset(20);
        }];
        numTitle.font = KFont(13);
        numTitle.text = @"纳税人识别号：";
        numTitle.textColor = KHexRGB(0x999999);

        self.numLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(numTitle);
                make.top.mas_equalTo(numTitle.mas_bottom).offset(10);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x333333);
            view;
        });
        
        UILabel *moneyTitle = [UILabel new];
        [self.contentView addSubview:moneyTitle];
        [moneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_numLab.mas_bottom).offset(20);
            make.left.right.mas_equalTo(_numLab);
        }];
        moneyTitle.font = KFont(13);
        moneyTitle.text = @"欠税金额：";
        moneyTitle.textColor = KHexRGB(0x999999);

        self.moneyLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(moneyTitle);
                make.top.mas_equalTo(moneyTitle.mas_bottom).offset(10);
                make.bottom.mas_equalTo(self.contentView).offset(-20);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0xff6400);
            view;
        });
        
        
        UILabel *typeTitle = [UILabel new];
        [self.contentView addSubview:typeTitle];
        [typeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(numTitle);
            make.left.mas_equalTo(KDeviceW/2+10);
            make.right.mas_equalTo(-15);
        }];
        typeTitle.font = KFont(13);
        typeTitle.text = @"纳税人类型：";
        typeTitle.textColor = KHexRGB(0x999999);
        
        self.typeLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(typeTitle);
                make.top.mas_equalTo(typeTitle.mas_bottom).offset(10);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x3075e1);
            view;
        });
        
        
        UILabel *timeTitle = [UILabel new];
        [self.contentView addSubview:timeTitle];
        [timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_typeLab);
            make.top.mas_equalTo(_typeLab.mas_bottom).offset(20);
        }];
        timeTitle.font = KFont(13);
        timeTitle.text = @"认定时间：";
        timeTitle.textColor = KHexRGB(0x999999);
        
        self.timeLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(timeTitle);
                make.top.mas_equalTo(timeTitle.mas_bottom).offset(10);
                make.bottom.mas_equalTo(self.contentView).offset(-20);
            }];
            view.font = KFont(14);
            view.textColor = KHexRGB(0x333333);
            view;
        });
    }
    return self;
}

- (void)setModel:(OweTaxModel *)model{

    _model = model;
    
    _numLab.text = model.taxCode;
    
    _moneyLab.text = model.balance;
    
    _typeLab.text = model.entType;
    
    NSString *time = model.confirmDate.length>10?[NSString stringWithFormat:@"%li",(NSInteger)[model.confirmDate longLongValue]/1000]:model.confirmDate;
    _timeLab.text = [Tools timestampSwitchTime:time];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
