//
//  DishonestView.m
//  EnterpriseInquiry
//
//  Created by clj on 16/8/14.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "DishonestView.h"

@implementation DishonestView

-(UIView *)colorView
{
    if (_colorView == nil) {
        _colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height/3)];
        _colorView.backgroundColor = KHexRGB(0xff6666);
    }
    return _colorView;
}


-(UILabel *)yearLabel
{
    if (_yearLabel == nil) {
        _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.colorView.frame.size.height)];
        _yearLabel.textColor = [UIColor whiteColor];
        _yearLabel.font = [UIFont fontWithName:FontName size:13];
//
        _yearLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _yearLabel;
}

-(UILabel *)monthLabel
{
    if (_monthLabel == nil) {
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_colorView.frame) +1, self.frame.size.width, self.frame.size.height - (CGRectGetMaxY(_colorView.frame) +1)) ];
        _monthLabel.textColor = KHexRGB(0xff652f);
        _monthLabel.textAlignment = NSTextAlignmentCenter;
//
        _monthLabel.font = [UIFont systemFontOfSize:15];
    }
    return _monthLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:[self colorView]];
        [self addSubview:[self yearLabel]];
        [self addSubview:[self monthLabel]];
        
        
        self.layer.cornerRadius = 5.0;
        self.layer.borderWidth = 1;
        self.layer.borderColor = KHexRGB(0xcdcdcd).CGColor;
        self.clipsToBounds = YES;

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andDishonestyMonthModel:(DishonestyMonthModel *)dishonestryModel
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:[self colorView]];
        [self addSubview:[self yearLabel]];
        [self addSubview:[self monthLabel]];

        
        _yearLabel.text = dishonestryModel.year;
        NSString *monStr = [NSString stringWithFormat:@"%@月",dishonestryModel.month];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:monStr];
        [AttributedStr addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:23.0]
                              range:NSMakeRange(0, monStr.length - 1)];
        _monthLabel.attributedText = AttributedStr;

        self.layer.cornerRadius = 5.0;
        self.layer.borderWidth = 1;
        self.layer.borderColor = KHexRGB(0xcdcdcd).CGColor;
        self.clipsToBounds = YES;

    }
    return self;
}


-(void)setDishonestryMonthModel:(DishonestyMonthModel *)dishonestryModel
{
    _yearLabel.text = dishonestryModel.year;
     NSString *monStr = [NSString stringWithFormat:@"%@月",dishonestryModel.month];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:monStr];
            [AttributedStr addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:23.0]
                                  range:NSMakeRange(0, monStr.length - 1)];
    _monthLabel.attributedText = AttributedStr;
}

@end
