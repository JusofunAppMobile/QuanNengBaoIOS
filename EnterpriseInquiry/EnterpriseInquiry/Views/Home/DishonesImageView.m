//
//  DishonesImageView.m
//  EnterpriseInquiry
//
//  Created by clj on 16/8/14.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "DishonesImageView.h"

@implementation DishonesImageView
- (instancetype)initWithFrame:(CGRect)frame andDishonestyMonthModel:(DishonestyMonthModel *)dishonestryModel
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [self createImageWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) andDishonesModel:dishonestryModel];
        self.image = image;
        [self jm_setCornerRadius:5 withBorderColor:KHexRGB(0xcdcdcd) borderWidth:2];
        self.clipsToBounds = YES;
    }
    return self;
}


-(UIImage *)createImageWithFrame:(CGRect)frame andDishonesModel:(DishonestyMonthModel *)dishonestryModel
{
    UIView *imageView = [[UIView alloc] initWithFrame:frame];
    imageView.backgroundColor = [UIColor whiteColor];
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,  frame.size.height/3)];
    colorView.backgroundColor = KHexRGB(0xff6666);
    [imageView addSubview:colorView];
    
    UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, colorView.frame.size.height)];
    yearLabel.textColor = [UIColor whiteColor];
    yearLabel.font = [UIFont fontWithName:FontName size:13];
    yearLabel.text = dishonestryModel.year;
    yearLabel.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:yearLabel];
    
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(colorView.frame), frame.size.width, frame.size.height - (CGRectGetMaxY(colorView.frame) +1)) ];
    monthLabel.textColor = KHexRGB(0xff652f);
    monthLabel.textAlignment = NSTextAlignmentCenter;
    NSString *monStr = [NSString stringWithFormat:@"%@月",dishonestryModel.month];
    monthLabel.font = [UIFont fontWithName:FontName size:17];
    [imageView addSubview:monthLabel];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:monStr];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:17.0]
                          range:NSMakeRange(0, monStr.length - 1)];
    monthLabel.attributedText = AttributedStr;
    
    
    UIGraphicsBeginImageContextWithOptions(imageView.frame.size, NO, [UIScreen mainScreen].scale);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
