//
//  BaseCell.m
//  JuXin
//
//  Created by 杨雯德 on 15/3/12.
//  Copyright (c) 2015年 huang. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.textLabel.frame;
    rect.origin.x =  10;
    self.textLabel.frame = rect;
    self.textLabel.font = KFont(16);
    self.textLabel.textColor = KHexRGB(0x333333);
    
    CGRect detaRect = self.detailTextLabel.frame;
    detaRect.size.height = detaRect.size.height +2;
    detaRect.origin.y = detaRect.origin.y -1;
    self.detailTextLabel.frame = detaRect;
    
    _ArrowImageView = [[UIImageView alloc]init];
    _ArrowImageView.image = [UIImage imageNamed:@"canTouchIcon"];
    _ArrowImageView.frame = CGRectMake(KDeviceW- 28, (44-13)/2, 7, 13);
    [self.contentView addSubview:_ArrowImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
@end
