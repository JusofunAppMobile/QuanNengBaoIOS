//
//  HomeNewsHeader.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/4.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "HomeNewsHeader.h"

@interface HomeNewsHeader ()

@property (nonatomic ,strong) UILabel *titleLab;

@property (nonatomic ,assign) BOOL isHot;

@end

@implementation HomeNewsHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIView *greenView = [UIView new];
        [self.contentView addSubview:greenView];
        [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(5);
            make.height.mas_equalTo(12);
            make.centerY.mas_equalTo(self.contentView);
        }];
        greenView.backgroundColor = KHexRGB(0x61DDB4);
        
        self.titleLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(greenView.mas_right).offset(10);
                make.centerY.mas_equalTo(self.contentView);
            }];
            view.text = @"失信榜单";
            view.font = KFont(14);
            view;
        });
        
        
        UIImageView *iconView = [UIImageView new];
        [self.contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-15);
            make.centerY.mas_equalTo(self.contentView);
        }];
        iconView.image = KImageName(@"more");
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = KFrame(0,self.height-1, KDeviceW, 1);
        lineView.backgroundColor = KHexRGB(0xebebeb);
        [self.contentView addSubview:lineView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
        self.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    }
    return self;
}

- (void)loadHeader:(NSString *)title isHot:(BOOL)isHot{
    
    _isHot = isHot;
    if (_isHot) {
        NSString *str = [NSString stringWithFormat:@"%@（近7天）",title];
        _titleLab.attributedText = [self getAttributeTitle:str];
    }else{
        _titleLab.text = title;
    }
}

- (NSAttributedString *)getAttributeTitle:(NSString *)title{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:title];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontName size:10] range:NSMakeRange(str.length-5, 5)];
    [str addAttribute:NSForegroundColorAttributeName value:KHexRGB(0x999999) range:NSMakeRange(4, title.length-4)];
    return str;
}


- (void)tapAction{

    if ([_delegate respondsToSelector:@selector(didTapSectionHeader:)]) {
        [_delegate didTapSectionHeader:_isHot];
    }
    
}

@end

