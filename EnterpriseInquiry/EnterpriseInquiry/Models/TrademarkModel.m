//
//  TrademarkModel.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/6.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "TrademarkModel.h"

@implementation TrademarkModel


- (NSString *)stauts{
    if (![ _stauts length]||[_stauts isKindOfClass:[NSNull class]]) {
        _stauts = @"-";
    }
    return _stauts;
}

- (NSString *)name{
    if (![_name length]||[_name isKindOfClass:[NSNull class]]) {
        _name = @"-";
    }
    return _name;
}

@end
