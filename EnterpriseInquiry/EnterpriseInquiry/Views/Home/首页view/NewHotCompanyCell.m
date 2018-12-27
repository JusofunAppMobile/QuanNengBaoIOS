//
//  NewHotCompanyCell.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/5.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "NewHotCompanyCell.h"
#import "CompanyModel.h"
#import "ContentInsetsLabel.h"
@interface NewHotCompanyCell ()

@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) ContentInsetsLabel *typeLab;
@property (nonatomic ,strong) ContentInsetsLabel *cityLab;
@property (nonatomic ,strong) ContentInsetsLabel *moneyLab;
@property (nonatomic ,strong) UILabel *dateLab;
@property (nonatomic ,strong) UILabel *legalLab;

@end

@implementation NewHotCompanyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(13);
                make.top.mas_equalTo(20);
                make.right.mas_equalTo(self.contentView).offset(-35);
            }];
            view.font = KFont(16);
            view.textColor = KHexRGB(0x333333);
            view;
        });
        
      
        self.typeLab = ({
            ContentInsetsLabel *view = [ContentInsetsLabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_nameLab.mas_bottom).offset(12);
                make.left.mas_equalTo(_nameLab);
                make.height.mas_equalTo(20);
            }];
            view.contentInsets = UIEdgeInsetsMake(0, 6, 0, 6);
            view.font = KFont(12);
            view.textColor = KHexRGB(0x4075c2);
            view.layer.cornerRadius = 6;
            view.layer.masksToBounds = YES;
            view.backgroundColor = KHexRGB(0xf1f8ff);
            view.textAlignment = NSTextAlignmentCenter;
            [view sizeToFit];
            view;
        });
        
        self.cityLab = ({
            ContentInsetsLabel *view = [ContentInsetsLabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.height.mas_equalTo(_typeLab);
                make.left.mas_equalTo(_typeLab.mas_right).offset(10);
            }];
            view.contentInsets = UIEdgeInsetsMake(0, 6, 0, 6);
            view.font = KFont(12);
            view.textColor = KHexRGB(0x4075c2);
            view.layer.cornerRadius = 6;
            view.layer.masksToBounds = YES;
            view.backgroundColor = KHexRGB(0xf1f8ff);
            view.textAlignment = NSTextAlignmentCenter;
            [view sizeToFit];
            view;
        });
        
        self.moneyLab = ({
            ContentInsetsLabel *view = [ContentInsetsLabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.height.mas_equalTo(_typeLab);
                make.left.mas_equalTo(_cityLab.mas_right).offset(10);
                make.right.mas_lessThanOrEqualTo(-15);
            }];
            view.contentInsets = UIEdgeInsetsMake(0, 6, 0, 6);
            view.font = KFont(12);
            view.textColor = KHexRGB(0x4075c2);
            view.layer.cornerRadius = 6;
            view.layer.masksToBounds = YES;
            view.backgroundColor = KHexRGB(0xf1f8ff);
            view.textAlignment = NSTextAlignmentCenter;
            [view sizeToFit];
            view;
        });
        //防止后2个压缩
//        [_typeLab setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
//        [_cityLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [_moneyLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        
        self.collectBtn = ({
            UIButton *view = [UIButton new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15);
                make.top.mas_equalTo(_nameLab);
            }];
            [view setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
            [view setImage:[UIImage imageNamed:@"收藏_h"] forState:UIControlStateSelected];
            [view addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
            view;
        });
        
        self.dateLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView).offset(-25);
                make.top.mas_equalTo(_typeLab.mas_bottom).offset(16);
                make.bottom.mas_equalTo(self.contentView).offset(-20);
            }];
            view.textColor = KHexRGB(0x999999);
            view.font = KFont(14);
            view.textAlignment = NSTextAlignmentRight;
            view;
        });
        
        self.legalLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_typeLab);
                make.right.mas_equalTo(_dateLab.mas_left).offset(-5);
                make.top.mas_equalTo(_dateLab);
            }];
            view.textColor = KHexRGB(0x999999);
            view.font = KFont(14);
            view;
        });
        
        self.lineView = ({
            UIView *line = [UIView new];
            line.backgroundColor = KHexRGB(0xf2f2f2);
            [self.contentView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.contentView);
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(1);
            }];
            line;
        });
        
        
       
    }
    return self;
}

- (void)setModel:(CompanyModel *)model{
    if (model) {
        _model = model;
        _nameLab.text    = model.companyname;
        _typeLab.text    = model.industry?:@"未公布";
        _moneyLab.text   = model.funds?:@"未公布";
        _cityLab.text    = model.location?:@"未公布";
        
        NSString *date           = [NSString stringWithFormat:@"成立日期：%@",model.PublishTime?:@"未公布"];
        NSString *person         = [NSString stringWithFormat:@"法定代表人：%@",model.legalPerson?:@"未公布"];
        _dateLab.attributedText  = [self getAttributeForString:date location:5];
        _legalLab.attributedText = [self getAttributeForString:person location:6];
        _collectBtn.selected     = [model.isFav boolValue];
    }
}

- (CGFloat)getTextWidth:(NSString *)text{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    return rect.size.width;
}

- (NSAttributedString *)getAttributeForString:(NSString *)text location:(NSUInteger)loc{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:text];
    [attr addAttribute:NSForegroundColorAttributeName value:KHexRGB(0x333333) range:NSMakeRange(loc, text.length-loc)];
    return attr;
}


- (void)collectAction:(UIButton*)button{
    if ([_delegate respondsToSelector:@selector(collectCompanyWithButton:model:)]) {
        [_delegate collectCompanyWithButton:button model:_model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

