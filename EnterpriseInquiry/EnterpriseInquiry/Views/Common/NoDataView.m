//
//  NoDataView.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/3/13.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "NoDataView.h"

@interface NoDataView()
@property (nonatomic ,strong) UILabel *titleLab;
@property (nonatomic ,strong) UIImageView *iconView;
@end

@implementation NoDataView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(90, 105));
        }];
        
        self.iconView = ({
            UIImageView *iconView = [UIImageView new];
            iconView.image = [UIImage imageNamed:@"暂无信息"];
            [bgView addSubview:iconView];
            [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.centerX.mas_equalTo(bgView);
            }];
            iconView;
        });
        
        self.titleLab = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:15];
            label.text = @"暂无信息";
            label.textColor = KHexRGB(0xcccccc);
            [bgView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(bgView);
                make.top.mas_equalTo(_iconView.mas_bottom).offset(15);
            }];
            label;
        });
        
    }
    return self;
}

- (void)setText:(NSString *)text{
    _text = text.length?text:@"暂无信息";
    self.iconView.image = [UIImage imageNamed:_text];
    self.titleLab.text = _text;
}


@end
