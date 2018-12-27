//
//  SearchButton.m
//  EnterpriseInquiry
//
//  Created by clj on 16/8/14.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "SearchButton.h"

@implementation SearchButton


- (instancetype)initWithFrame:(CGRect)frame andPlaceText:(NSString *)placeText
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.searchImageView = ({
            UIImageView *view = [UIImageView new];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self);
                make.width.height.mas_equalTo(15);
                make.right.mas_equalTo(self).offset(-20-20);
            }];
            view.image = [UIImage imageNamed:@"home_search"];
            view;
        });
        
        self.searchLabel = ({
            UILabel *view = [UILabel new];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self);
                make.left.mas_equalTo(20+20);
                make.right.mas_equalTo(_searchImageView.mas_left).offset(-15);
            }];
            view.textColor = KHexRGB(0x999999);
            view.font = KFont(13);
            view;
        });
        
        
        
        [self addSubview:[self searchImageView]];
        [self addSubview:[self searchLabel]];
        _searchLabel.text = placeText;
        
    }
    return self;
}

@end

