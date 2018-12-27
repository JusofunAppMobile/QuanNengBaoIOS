//
//  FilterSectionHeader.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/12.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "FilterSectionHeader.h"

@interface FilterSectionHeader()


@end

@implementation FilterSectionHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _openBtn = [[UIButton alloc]initWithFrame:KFrame(15, 0, self.width-15*2, self.height)];
        _openBtn.backgroundColor = KHexRGB(0xeef6fe);
        _openBtn.titleLabel.font = KFont(12);
        [_openBtn setTitleColor:KHexRGB(0x666666) forState:UIControlStateNormal];
        [_openBtn setImage:KImageName(@"botom") forState:UIControlStateSelected];
        [_openBtn setImage:KImageName(@"top") forState:UIControlStateNormal];
        [_openBtn addTarget:self action:@selector(openAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_openBtn];
    }
    return self;
}

- (void)setModel:(ChooseDataModel *)model{
    if (model) {
        _model = model;
        [_openBtn setTitle:model.name forState:UIControlStateNormal];
        _openBtn.imageEdgeInsets = UIEdgeInsetsMake(0, (_openBtn.width-_openBtn.imageView.width)/2, 0, -(_openBtn.width-_openBtn.imageView.width)/2);
        _openBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -(_openBtn.width-_openBtn.titleLabel.width)/2-_openBtn.imageView.width+15, 0, (_openBtn.width-_openBtn.titleLabel.width)/2-_openBtn.imageView.width-15);
    }
}

- (void)openAction:(UIButton *)button{
    button.selected = !button.selected;
    NSLog(@"点击按钮___%d",button.selected);
    if ([self.delegate respondsToSelector:@selector(filterHeaderOpen:type:)]) {
        [self.delegate filterHeaderOpen:button.selected type:_model.type];
    }
}



@end

