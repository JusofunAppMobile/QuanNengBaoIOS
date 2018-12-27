//
//  UpdateUserInfoCell.m
//  EnterpriseInquiry
//
//  Created by LEZ on 16/8/10.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "UpdateUserInfoCell.h"

@implementation UpdateUserInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        _iconImg = [[UIImageView alloc] init];
//        _iconImg.frame = KFrame(10, 10, 40, 40);
//        _iconImg.backgroundColor = KHexRGB(0xf2f2f2);
//        [self.contentView addSubview:_iconImg];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = KFrame(14, 0, 50, 44);
        _titleLabel.font    = KFont(14);
        _titleLabel.textColor = KHexRGB(0x666666);
        [self.contentView addSubview:_titleLabel];
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.frame = KFrame(64, 0, KDeviceW-94, 44);
        _subTitleLabel.font    = KFont(14);
        _subTitleLabel.textColor = KHexRGB(0x999999);
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_subTitleLabel];
        
        _lineView = [[UIImageView alloc] init];
        _lineView.frame = KFrame(14, 43, KDeviceW-14, 1);
        _lineView.backgroundColor = KHexRGB(0xf2f2f2);
        [self.contentView addSubview:_lineView];
        
        _imgV = [[UIImageView alloc] initWithFrame:KFrame(KDeviceW-35/2-7, (44-13)/2, 7, 13)];
        _imgV.image = [UIImage imageNamed:@"canTouchIcon"];
        [self.contentView addSubview:_imgV];
    }
    return self;
}

@end
