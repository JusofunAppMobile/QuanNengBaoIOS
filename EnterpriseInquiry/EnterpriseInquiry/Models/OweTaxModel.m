//
//  OweTaxModel.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/11/9.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "OweTaxModel.h"

@implementation OweTaxModel


-(NSString *)confirmDate
{
    if(_confirmDate.length == 0||[_confirmDate isEqualToString:@"null"]||[_confirmDate isEqualToString:@"NULL"]||[_confirmDate isEqualToString:@"<null>"]||[_confirmDate isEqualToString:@"-"])
    {
        return @"";
    }
    else
    {
        return _confirmDate;
    }
    
}


@end
