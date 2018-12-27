//
//  SearchAllWebView.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/9/19.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "SearchAllWebView.h"

@implementation SearchAllWebView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat y ;
        if(KScreen35)
        {
            y = 50.0;
        }
        else if(KScreen4)
        {
            y = 110.0;
        }
        else
        {
            y = 175.0;
        }
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:KFrame(0, y/750.0*KDeviceH/2, KDeviceW, 15)];
        label1.text = @"没有找到信息？";
        label1.font = KFont(15);
        label1.textColor = KHexRGB(0x56ce9c);
        label1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label1];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:KFrame(KDeviceW/2-175/2, label1.maxY + 18, 175, 114)];
        imageView.image = KImageName(@"空白页图片");
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:KFrame(KDeviceW/2- 5-90, imageView.maxY + 45, 90, 35)];
        label.font = KFont(12);
        label.textColor = KRGB(153, 153, 153);
        label.text = @"没有找到信息？\n试试全网查找吧";
        label.numberOfLines = 0;
        [self addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = KFrame(KDeviceW/2+5, imageView.maxY + 45 + 2.5, 75, 30);
        [button setTitle:@"全网查找" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button jm_setCornerRadius:5 withBackgroundColor:KRGB(253, 119, 49)];
        [button addTarget:self action:@selector(searchAllNetwork) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = KFont(14);
        [self addSubview:button];

        
    }
    return self;
}


-(void)searchAllNetwork
{
    self.searchAllWeb();
}


@end
