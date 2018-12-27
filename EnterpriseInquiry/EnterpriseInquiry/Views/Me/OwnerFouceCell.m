//
//  OwnerFouceCell.m
//  EnterpriseInquiry
//
//  Created by LEZ on 16/8/13.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "OwnerFouceCell.h"

@implementation OwnerFouceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _companyNameLabel = [[UILabel alloc] initWithFrame:KFrame(10, 15, KDeviceW-20, 16)];
        _companyNameLabel.font = KFont(16);
        _companyNameLabel.textColor = KHexRGB(0x333333);
        [self.contentView addSubview:_companyNameLabel];
        
        
        UIImageView *legalimg = [[UIImageView alloc] initWithFrame:KFrame(10, CGRectGetMaxY(_companyNameLabel.frame)+12, 10, 10)];
        legalimg.image =  [UIImage imageNamed:@"账户icon"];
        [self.contentView addSubview:legalimg];
        
        _legalPersonLabel = [[UILabel alloc] initWithFrame:KFrame(25, CGRectGetMaxY(_companyNameLabel.frame)+10, KDeviceW-20, 14)];
        _legalPersonLabel.font = KFont(14);
        _legalPersonLabel.textColor = KHexRGB(0x999999);
        [self.contentView addSubview:_legalPersonLabel];
        
        _companyStateLabel = [[UILabel alloc] initWithFrame:KFrame(KDeviceW-160, CGRectGetMaxY(_companyNameLabel.frame)+10, 150, 14)];
        _companyStateLabel.font = KFont(14);
        _companyStateLabel.textColor = KHexRGB(0x999999);
        _companyStateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_companyStateLabel];
        
        
        UIView *lineV = [[UIView alloc] initWithFrame:KFrame(0, 69, KDeviceW, 1)];
        lineV.backgroundColor = KHexRGB(0xf2f2f2);
        [self.contentView addSubview:lineV];
        
    }
    return self;
}

-(void)setInfoDict:(NSDictionary *)infoDict
{
    
    
    
    _infoDict = infoDict;
    
    _companyNameLabel.text = KNSString(_infoDict[@"companyname"]) ;
    _legalPersonLabel.text = KNSString(_infoDict[@"legal"]);
    _companyStateLabel.text = KNSString(_infoDict[@"companystate"]);
    
}

@end
