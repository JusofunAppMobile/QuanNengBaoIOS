//
//  FilterPlainSeionHeader.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/12.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "FilterPlainSeionHeader.h"

@interface FilterPlainSeionHeader()
@property (nonatomic ,strong) UILabel *titleLab;
@end
@implementation FilterPlainSeionHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KDeviceW, 1)];
        line.backgroundColor = KHexRGB(0xf2f2f2);
        [self addSubview:line];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, line.maxY+20, self.width-15*2, 14)];
        _titleLab.font = KFont(14);
        _titleLab.textColor = KHexRGB(0x333333);
        [self addSubview:_titleLab];
    }
    return self;
}

- (void)setModel:(ChooseDataModel *)model{
    if (model) {
        _model = model;
        _titleLab.text = model.name;
    }
}

@end
