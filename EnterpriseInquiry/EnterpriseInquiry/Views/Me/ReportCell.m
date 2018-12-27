//
//  ReportCell.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/10/16.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "ReportCell.h"
#import "ReportModel.h"


@interface ReportCell ()

@property (nonatomic ,strong) UILabel *nameLab;

@property (nonatomic ,strong) UILabel *timeLab;

@property (nonatomic ,strong) UIButton *iconView;

@end

@implementation ReportCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView{

    self.nameLab = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(15);
            make.right.mas_equalTo(self.contentView).offset(-70);
            make.top.mas_equalTo(20);
        }];
        label.font = KFont(16);
        label.text = @"阿里巴巴（中国）有限公司";
        label;
    });
    
    self.timeLab = ({
        UILabel *view = [UILabel new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLab.mas_bottom).offset(15);
            make.left.mas_equalTo(15);
        }];
        view.font = KFont(12);
        view.textColor = KHexRGB(0x999999);
        view.text = @"2017.09.29";
        view;
    });
    
    self.iconView= ({
        UIButton *view = [UIButton new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(80);
        }];
        //view.imageEdgeInsets = UIEdgeInsetsMake((40-21.5)/2, (40-25)/2,(40-21.5)/2, (40-25)/2);
        [view setImage:KImageName(@"邮件") forState:UIControlStateNormal];
        [view addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
}


- (void)setModel:(ReportModel *)model{
    _model = model;
    _nameLab.text = model.entName;
    _timeLab.text = model.reportTime;
}

- (void)buttonAction{
    if ([_delegate respondsToSelector:@selector(sendReportAction:)]) {
        [_delegate sendReportAction:_model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
