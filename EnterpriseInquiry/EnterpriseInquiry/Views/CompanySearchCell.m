//
//  CompanySearchCell.m
//  EnterpriseInquiry
//
//  Created by LEZ on 16/8/15.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "CompanySearchCell.h"


@implementation CompanySearchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _companyLabel = [[UILabel alloc] initWithFrame:KFrame(14, 15, KDeviceW-80, 16)];
        _companyLabel.font = KFont(16);
//        _companyLabel.textColor = KHexRGB(0xff772e);
        [self.contentView addSubview:_companyLabel];
        
        
    }
    return self;
}

-(void)setInfoDict:(NSDictionary *)infoDict
{
    _infoDict = infoDict;
    _companyLabel.frame = KFrame(14, 15, KDeviceW -28, 16);
    NSString *str= _infoDict[@"companyname"];
     NSMutableAttributedString *str1 = [Tools titleNameWithTitle:str otherColor:[UIColor blackColor]];
    _companyLabel.attributedText = str1;
    
}

@end
