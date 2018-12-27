//
//  HomeMoreFooter.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/5.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "HomeMoreFooter.h"

@implementation HomeMoreFooter

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIButton *moreBtn = [UIButton new];
        [self.contentView addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        moreBtn.titleLabel.font = KFont(12);
        moreBtn.backgroundColor = [UIColor whiteColor];
        [moreBtn setTitle:@"更多 >>" forState:UIControlStateNormal];
        [moreBtn setTitleColor:KHexRGB(0x878787) forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)moreAction{
    if ([_delegate respondsToSelector:@selector(didTapMoreButton)]) {
        [_delegate didTapMoreButton];
    }
}


@end
