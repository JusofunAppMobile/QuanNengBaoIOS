//
//  NewAddListCell.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/11.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "NewAddListCell.h"
#import "ContentInsetsLabel.h"

@interface NewAddListCell()

@property (nonatomic ,strong) UILabel *nameLab;

@property (nonatomic ,strong) ContentInsetsLabel *statusLab;
@property (nonatomic ,strong) ContentInsetsLabel *cityLab;
@property (nonatomic ,strong) ContentInsetsLabel *moneyLab;

@property (nonatomic ,strong) UILabel *legalLab;
@property (nonatomic ,strong) UILabel *dateLab;
@property (nonatomic ,strong) UIView *bgView;

@end

@implementation NewAddListCell
 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = KHexRGB(0xf8f8fa);
        
        self.bgView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 0, 0, 0));
            }];
            view;
        });
        
        self.nameLab = ({
            UILabel *view = [UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_bgView).offset(21);
                make.left.mas_equalTo(_bgView).offset(15);
                make.right.mas_offset(-15);
            }];
            view.font = KFont(16);
            view.textColor = KHexRGB(0x333333);
            view;
        });
        
        self.statusLab = ({
            ContentInsetsLabel *view = [ContentInsetsLabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_nameLab);
                make.top.mas_equalTo(_nameLab.mas_bottom).offset(10);
                make.height.mas_equalTo(20);
            }];
            view.contentInsets = UIEdgeInsetsMake(0, 6, 0, 6);
            view.font = KFont(12);
            view.textColor = KHexRGB(0x1e9efb);
            view.textAlignment = NSTextAlignmentCenter;
            view.layer.cornerRadius = 6.f;
            view.layer.masksToBounds = YES;
            view.layer.borderWidth = 0.5f;
            view.layer.borderColor = KHexRGB(0x1e9efb).CGColor;
            view;
        });
        
        
        self.cityLab = ({
            ContentInsetsLabel *view = [ContentInsetsLabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_statusLab.mas_right).offset(10);
                make.top.height.mas_equalTo(_statusLab);
            }];
            view.contentInsets = UIEdgeInsetsMake(0, 6, 0, 6);
            view.font = KFont(12);
            view.textColor = KHexRGB(0x4075c2);
            view.textAlignment = NSTextAlignmentCenter;
            view.backgroundColor = KHexRGB(0xf1f8ff);
            view.layer.cornerRadius = 6;
            view.layer.masksToBounds = YES;
            view;
        });
        
        
        self.moneyLab = ({
            ContentInsetsLabel *view = [ContentInsetsLabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_cityLab.mas_right).offset(10);
                make.top.height.mas_equalTo(_cityLab);
            }];
            view.contentInsets = UIEdgeInsetsMake(0, 6, 0, 6);
            view.font = KFont(12);
//            view.textColor = KHexRGB(0x999999);
            view.textColor = KHexRGB(0x4075c2);
            view.textAlignment = NSTextAlignmentCenter;
            view.backgroundColor = KHexRGB(0xf1f8ff);
            view.layer.cornerRadius = 6;
            view.layer.masksToBounds = YES;
            view;
        });
        
        
        self.dateLab = ({
            UILabel *view = [UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_bgView).offset(-15);
                make.top.mas_equalTo(_statusLab.mas_bottom).offset(16);
                make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-21);
            }];
            view.textColor = KHexRGB(0x999999);
            view.font = KFont(14);
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
            view.textColor = KHexRGB(0x999999);
            view.font = KFont(14);
            view;
        });
    }
    return self;
}

- (void)setModel:(NewAddModel *)model{
    if (model) {
        _model = model;
        
        _nameLab.text = model.companyname;
        _statusLab.text = model.companystate.length?model.companystate:@"未知";
        _moneyLab.text = model.funds.length?model.funds:@"未公布";
        _cityLab.text = model.location.length?model.location:@"未公布";;
        
        NSString *date = [NSString stringWithFormat:@"成立日期：%@",model.PublishTime.length?model.PublishTime:@"未公布"];
        NSString *person = [NSString stringWithFormat:@"法定代表人：%@",model.legalPerson.length?model.legalPerson:@"未公布"];
        
        _dateLab.attributedText = [self getAttributeForString:date location:5];
        _legalLab.attributedText = [self getAttributeForString:person location:6];
    
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


@end
