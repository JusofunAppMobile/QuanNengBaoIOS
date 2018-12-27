//
//  ZHCollectionViewInterceptor.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/2/27.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "ZHCollectionViewInterceptor.h"

@implementation ZHCollectionViewInterceptor

#pragma mark - forward & response override
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.middleMan respondsToSelector:aSelector]) return self.middleMan;
    if ([self.receiver respondsToSelector:aSelector]) return self.receiver;
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.middleMan respondsToSelector:aSelector]) return YES;
    if ([self.receiver respondsToSelector:aSelector]) return YES;
    return [super respondsToSelector:aSelector];
}


@end
