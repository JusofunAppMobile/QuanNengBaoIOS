//
//  CenterButton.m
//  JuXin
//
//  Created by clj on 16/7/28.
//  Copyright © 2016年 huang. All rights reserved.
//

#import "CenterButton.h"

@implementation CenterButton
-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
//    center.y = self.imageView.frame.size.height/2;
    center.y = self.frame.size.height*2/5;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = CGRectGetMaxY(self.imageView.frame) + 5;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


-(void)centerImageAndTitle:(float)space
{
//    CGSize imageSize = self.imageView.frame.size;
//    CGSize titleSize = self.titleLabel.frame.size;
//    
//    CGFloat totalHeight = (imageSize.height + titleSize.height + space);
//    self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight -imageSize.height) +10, 0.0, 0.0, -titleSize.width);
//    self.titleEdgeInsets = UIEdgeInsetsMake(
//                                            0.0, - imageSize.width, - (totalHeight - titleSize.height) -5, 0.0);
}

- (void)centerImageAndTitle
{
//    const int DEFAULT_SPACING = 8.0f;
//    [self centerImageAndTitle:DEFAULT_SPACING];
}

@end
