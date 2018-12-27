//
//  AnimateLine.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/12.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "AnimateLine.h"
@interface AnimateLine()
@property (nonatomic ,assign) CGPoint mCenter;
@property (nonatomic ,assign) CGFloat mWidth;
@end

@implementation AnimateLine


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _mWidth = self.width;
        _mCenter = self.center;
    }
    return self;
}


- (void)show:(BOOL)animated{
    
    if (!self.visiable) {
        CGRect rect = CGRectMake(0, 0, _mWidth, self.height);
        if (animated) {
            [UIView animateWithDuration:.3 animations:^{
                self.bounds = rect;
            }];
        }else{
            self.bounds = rect;
        }
    }
}

- (void)hide:(BOOL)animated{
    
    if (self.visiable) {
        CGRect rect = CGRectMake(0, 0, 0, self.height);
        if (animated) {
            [UIView animateWithDuration:.3 animations:^{
                self.bounds = rect;
            }];
        }else{
            self.bounds = rect;
        }
    }
}

- (BOOL)visiable{
   _visiable = self.width?YES:NO;
    return _visiable;
}

@end
