//
//  NewCompanyView.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/8.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "NewCompanyView.h"
#import "NewAddModel.h"
#import "ContentInsetsLabel.h"

@interface NewCompanyView ()

@property (nonatomic ,strong) UIImageView *bgView;
@property (nonatomic ,strong) UILabel *nameLab;

@property (nonatomic ,strong) ContentInsetsLabel *statusLab;
@property (nonatomic ,strong) ContentInsetsLabel *cityLab;
@property (nonatomic ,strong) ContentInsetsLabel *moneyLab;

@property (nonatomic ,strong) UILabel *legalLab;
@property (nonatomic ,strong) UILabel *dateLab;

@end

@implementation NewCompanyView


- (void)createUI{
    self.bgView = ({
        UIImageView *view = [UIImageView new];
        view.image = KImageName(@"新增企业的底");
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self).offset(15);
            make.bottom.mas_equalTo(self).offset(-20);
        }];
        view;
    });
    
    self.nameLab = ({
        UILabel *view = [UILabel new];
        [_bgView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView).offset(20);
            make.left.mas_equalTo(_bgView).offset(15);
            make.right.mas_offset(-15);
        }];
        view.font = KFont(16);
        view.textColor = [UIColor whiteColor];
        view;
    });
    
    self.statusLab = ({
        ContentInsetsLabel *view = [ContentInsetsLabel new];
        [_bgView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLab);
            make.top.mas_equalTo(_nameLab.mas_bottom).offset(10);
            make.height.mas_equalTo(18);
        }];
        view.contentInsets = UIEdgeInsetsMake(0, 6, 0, 6);
        view.font = KFont(12);
        view.textColor = KHexRGB(0x1d89fa);
        view.textAlignment = NSTextAlignmentCenter;
        view.layer.cornerRadius = 6.f;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    
    self.cityLab = ({
        ContentInsetsLabel *view = [ContentInsetsLabel new];
        [_bgView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_statusLab.mas_right).offset(12);
            make.top.height.mas_equalTo(_statusLab);
        }];
        view.contentInsets = UIEdgeInsetsMake(0, 6, 0, 6);
        view.font = KFont(12);
        view.textColor = [UIColor whiteColor];
        view.textAlignment = NSTextAlignmentCenter;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.layer.cornerRadius = 6;
        view;
    });
    
    
    self.moneyLab = ({
        ContentInsetsLabel *view = [ContentInsetsLabel new];
        [_bgView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_cityLab.mas_right).offset(12);
            make.top.height.mas_equalTo(_statusLab);
        }];
        view.contentInsets = UIEdgeInsetsMake(0, 6, 0, 6);
        view.font = KFont(12);
        view.textColor = [UIColor whiteColor];
        view.textAlignment = NSTextAlignmentCenter;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.layer.cornerRadius = 6;
        view;
    });
    
    
    self.dateLab = ({
        UILabel *view = [UILabel new];
        [_bgView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView).offset(-15);
            make.top.mas_equalTo(_statusLab.mas_bottom).offset(22);
        }];
        view.textColor = [UIColor whiteColor];
        view.font = KFont(13);
        view.textAlignment = NSTextAlignmentRight;
        view;
    });
    
    self.legalLab = ({
        UILabel *view = [UILabel new];
        [_bgView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_statusLab);
            make.right.mas_equalTo(_dateLab.mas_left).offset(-5);
            make.top.mas_equalTo(_dateLab);
        }];
        view.textColor = [UIColor whiteColor];
        view.font = KFont(13);
        view;
    });
    
}

//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        [self createUI];
//    }
//    return self;
//}

- (void)setModel:(NewAddModel *)model{
    if (!model) {
        return;
    }
    _model = model;
    _nameLab.text = model.companyname;
    _cityLab.text = [self isNilString:model.location]?@"未公布":model.location;
    _moneyLab.text =  [self isNilString:model.funds]?@"未公布":model.funds;
    _statusLab.text = [self isNilString:model.companystate]?@"未公布":model.companystate;
    
    NSString *person = [self isNilString:model.legalPerson]?@"未公布":model.legalPerson;
    _legalLab.text = [NSString stringWithFormat:@"法定代表人：%@",person];
    
    NSString *date = [self isNilString:model.PublishTime]?@"未公布":model.PublishTime;
    _dateLab.text = [NSString stringWithFormat:@"成立日期：%@",date];
    
}

- (CGFloat)getTextWidth:(NSString *)text{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    return rect.size.width;
}

- (BOOL)isNilString:(NSString *)str{
    if (str.length == 0 || [str isEqualToString:@"null"]||[str isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}

@end

