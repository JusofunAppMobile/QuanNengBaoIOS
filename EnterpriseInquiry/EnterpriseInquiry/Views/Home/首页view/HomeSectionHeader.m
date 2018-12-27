//
//  HomeSectionHeader.m
//  EnterpriseInquiry
//
//  Created by wzh on 2018/1/5.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "HomeSectionHeader.h"

@interface HomeSectionHeader ()
@property (nonatomic ,strong) UIButton *moreBtn;
@property (nonatomic ,strong) UILabel *titleLab;
@property (nonatomic ,strong) UIView *line;


@end
@implementation HomeSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        self.line = ({
            UIView *view = [UIView new];
            view.backgroundColor = KHexRGB(0xf2f2f2);
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self.contentView);
                make.height.mas_equalTo(1);
            }];
            view;
        });
        
        
        UIImageView *leftView = [UIImageView new];
        leftView.backgroundColor = KHexRGB(0x5594fc);
        [self.contentView addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.bottom.mas_equalTo(self.contentView).offset(-5);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(3);
        }];
        
        self.titleLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(leftView.mas_right).offset(5);
                make.centerY.mas_equalTo(leftView);
            }];
            view.font = KFont(16);
            view.textColor = KHexRGB(0x333333);
            view.text = @"企业雷达";
            view;
        });
        
        self.moreBtn = ({
            UIButton *view = [UIButton new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(27);
                make.bottom.mas_equalTo(leftView);
                make.right.mas_equalTo(self.contentView).offset(-10);
            }];
            [view addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
            view;
        });
        
        UIImageView *moreView = [[UIImageView alloc]init];
        moreView.image = KImageName(@"首页更多");
        [_moreBtn addSubview:moreView];
        [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_moreBtn).offset(5);
            make.right.mas_equalTo(_moreBtn);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLab.text = title;
    _moreBtn.hidden = [title isEqualToString:@"企业雷达"];
    _line.hidden = YES;
}

- (void)moreAction{
    if ([self.delegate respondsToSelector:@selector(sectionHeaderMoreBtnClicked:)]) {
        [self.delegate sectionHeaderMoreBtnClicked:_titleLab.text];
    }
}

@end

