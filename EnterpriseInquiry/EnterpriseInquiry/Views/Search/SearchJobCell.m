//
//  SearchJobCell.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/3.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "SearchJobCell.h"
@interface SearchJobCell()
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UILabel *JobLab;
@property (nonatomic ,strong) UILabel *moneyLab;
@property (nonatomic ,strong) UILabel *dateLab;
@property (nonatomic ,strong) UILabel *addrLab;
@property (nonatomic ,strong) UILabel *expLab;
@property (nonatomic ,strong) UIImageView *focusView;
@property (nonatomic ,strong) UILabel *focusLab;
@property (nonatomic ,strong) UIImageView *iconView;
@end

@implementation SearchJobCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = KHexRGB(0xf8f8fa);
        
        self.bgView =({
            UIView *bgView = [UIView new];
            bgView.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:bgView];
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self.contentView);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            }];
            bgView;
        });
        
       
        
        self.moneyLab = ({
            UILabel *view = [UILabel new];
            view.font = KFont(16);
            view.textColor = KHexRGB(0xf86522);
            view.textAlignment = NSTextAlignmentRight;
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_bgView).offset(-15);
                make.top.mas_equalTo(_bgView.mas_top).offset(20);
                make.height.mas_equalTo(16);
            }];
            view;
        });
        
        self.JobLab = ({
            UILabel *view = [UILabel new];
            view.font = KFont(16);
            view.textColor = KHexRGB(0x333333);
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgView).offset(15);
                make.right.mas_equalTo(_moneyLab.mas_left).offset(-10);
                make.top.mas_equalTo(_moneyLab);
                make.height.mas_equalTo(16);
            }];
            view;
        });
        
        UILabel *dateTitle = ({
            UILabel *view = [UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_JobLab);
                make.top.mas_equalTo(_JobLab.mas_bottom).offset(15);
                make.width.mas_equalTo(72);
                make.height.mas_equalTo(14);
            }];
            view.text = @"发布日期：";
            view.font = KFont(14);
            view.textColor = KHexRGB(0x999999);
            view;
        });
        
        self.dateLab = ({
            UILabel *view = [UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(dateTitle.mas_right);
                make.right.mas_equalTo(_bgView).offset(-30);
                make.top.mas_equalTo(dateTitle);
                make.height.mas_equalTo(14);
            }];
            view.textColor = KHexRGB(0x333333);
            view.font = KFont(14);
            view;
        });
        
        UILabel *addrTitle = ({
            UILabel *view = [UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(dateTitle);
                make.top.mas_equalTo(dateTitle.mas_bottom).offset(15);
                make.height.mas_equalTo(14);
            }];
            view.text = @"地址：";
            view.font = KFont(14);
            view.textColor =  KHexRGB(0x999999);
            view;
        });
        
        self.addrLab = ({
            UILabel *view = [UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(_dateLab);
                make.top.mas_equalTo(addrTitle);
                make.height.mas_equalTo(14);
            }];
            view.text = @"北京";
            view.textColor = KHexRGB(0x333333);
            view.font = KFont(14);
            view;
        });
        
        UILabel *expTitle = ({
            UILabel *view = [UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(addrTitle);
                make.top.mas_equalTo(addrTitle.mas_bottom).offset(15);
                make.height.mas_equalTo(14);
            }];
            view.text = @"经验：";
            view.font = KFont(14);
            view.textColor =  KHexRGB(0x999999);
            view;
        });
        
        self.expLab = ({
            UILabel *view =[UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(_addrLab);
                make.top.mas_equalTo(expTitle);
                make.height.mas_equalTo(14);
            }];
            view.textColor = KHexRGB(0x333333);
            view.font = KFont(14);
            view;
        });
        
        self.focusView = ({
            UIImageView *view = [UIImageView new];
            view.image = [UIImage imageNamed:@"渐变彩条"];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(_bgView);
//                make.top.mas_equalTo(expTitle.mas_bottom).offset(20);
                make.height.mas_equalTo(30);
            }];
            view;
        });
        
        self.focusLab = ({
            UILabel *view = [UILabel new];
            [_focusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_focusView).offset(15);
                make.centerY.mas_equalTo(_focusView);
                make.right.mas_equalTo(_focusView).offset(-15);
            }];
            view.textColor = KHexRGB(0x999999);
            view.font = KFont(12);
            view;
        });

        self.iconView = ({
            UIImageView *view = [UIImageView new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_bgView).offset(-15);
                make.centerY.mas_equalTo(_bgView);
            }];
            view.image = KImageName(@"canTouchIcon");
            view;
        });
    
    }
    return self;
}

- (void)setModel:(SearchJobModel *)model{
    _model = model;
    _JobLab.text = model.job;
    _dateLab.text = model.publishDate;
    _addrLab.text = model.workPlace;
    _expLab.text = model.jobExperience;
    _focusLab.attributedText = [self getAttributeText:[NSString stringWithFormat:@"关联企业：%@",model.companyName]];
    _moneyLab.text = model.salary;

    if ([model.companyName length]) {
        [_focusView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
        }];
        _focusView.hidden = NO;
    }else{
        [_focusView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        _focusView.hidden = YES;
    }
}

- (NSAttributedString *)getAttributeText:(NSString *)str{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:KHexRGB(0x1d6fe7) range:NSMakeRange(5, str.length-5)];
    return attr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
