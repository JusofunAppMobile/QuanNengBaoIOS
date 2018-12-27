//
//  CompanyInfo.m
//  EnterpriseInquiry
//
//  Created by 方首滔 on 16/8/15.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "CompanyInfoModel.h"

@implementation CompanyInfoModel

-(void)setLocation:(NSString *)location
{
    
    if([location isEqualToString:@"未公布"])
    {
        _location = @"";
    }
    
    _location = location;
    
    
}




@end
