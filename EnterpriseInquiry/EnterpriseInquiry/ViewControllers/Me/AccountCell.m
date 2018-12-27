//
//  AccountCell.m
//  EnterpriseInquiry
//
//  Created by LEZ on 16/8/9.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "AccountCell.h"

@implementation AccountCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _iconImg = ({
            UIImageView *view = [UIImageView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.centerY.mas_equalTo(self.contentView);
                make.width.height.mas_equalTo(20);
            }];
            view.contentMode = UIViewContentModeScaleAspectFit;
            view;
        });

        
        _titleLabel = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(51);
                make.centerY.mas_equalTo(self.contentView);
            }];
            view.font = KFont(16);
            view.textColor = KHexRGB(0x333333);
            view;
        });
        
        _redBtn = ({
            UIButton *view = [UIButton new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(8.f);
                make.left.mas_equalTo(_titleLabel.mas_right).offset(2);
                make.top.mas_equalTo(_titleLabel.mas_top).offset(-1);
            }];
            view.layer.cornerRadius = 4.f;
            view.layer.masksToBounds = YES;
            view.backgroundColor = KHexRGB(0xff5a01);
            view;
        });
        
        
        _imgV = [[UIImageView alloc] initWithFrame:KFrame(KDeviceW-7-20, (54-13)/2, 7, 13)];
        _imgV.image = [UIImage imageNamed:@"canTouchIcon"];
        [self.contentView addSubview:_imgV];

        _subtitleLabel = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.right.mas_equalTo(_imgV.mas_left).offset(-10);
            }];
            view.font = KFont(16);
            view.textColor = KHexRGB(0xff6500);
            view.textAlignment = NSTextAlignmentRight;
            view;
        });
        
        
//        _topLineView = [[UIImageView alloc] init];
//        _topLineView.frame = KFrame(14, 0, KDeviceW-28-20, 1);
//        _topLineView.backgroundColor = KHexRGB(0xf2f2f2);
//        [self.contentView addSubview:_topLineView];
//        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = KFrame(0, 53, KDeviceW-30, 1);
        lineView.backgroundColor = KRGB(248, 248, 248);
        [self.contentView addSubview:lineView];
        
    }
    return self;
}

@end
