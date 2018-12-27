//
//  SalaryQueryCell.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/11/1.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "SalaryQueryCell.h"

@interface SalaryQueryCell ()

@property (nonatomic ,strong) UILabel *positionTitle;

@property (nonatomic ,strong) UILabel *positionLab;

@property (nonatomic ,strong) UILabel *salaryTitle;

@property (nonatomic ,strong) UILabel *salaryLab;


@end

@implementation SalaryQueryCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

#pragma mark - initView
- (void)initView{
    
    self.positionTitle = ({
        UILabel *view =[UILabel new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
        }];
        view.font = KFont(14);
        view.text = @"职位：";
        view;
    });
    
    self.positionLab = ({
        UILabel *view = [UILabel new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_positionTitle.mas_right);
            make.top.mas_equalTo(_positionTitle);
        }];
        view.text = @"高级运维工程师";
        view.font = KFont(14);
        view;
    });
    
    self.salaryTitle = ({
        UILabel *view = [UILabel new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(_positionTitle.mas_bottom).offset(15);
        }];
        view.font = KFont(14);
        view.text = @"薪资：";
        view;
    });
    
    self.salaryLab = ({
        UILabel *view = [UILabel new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_salaryTitle.mas_right);
            make.top.mas_equalTo(_salaryTitle);
        }];
        view.font = KFont(14);
        view.text = @"0.8-1.4万／月";
        view;
    });

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
