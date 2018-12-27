//
//  HelpCell.m
//  EnterpriseInquiry
//
//  Created by clj on 16/8/13.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "HelpCell.h"

@implementation HelpCell
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect detaRect = self.detailTextLabel.frame;
    detaRect.origin.x = 105*KDeviceW/320;
    self.detailTextLabel.frame = detaRect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
