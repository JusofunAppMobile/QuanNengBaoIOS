//
//  AnimateLine.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/12.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimateLine : UIImageView

@property (nonatomic ,assign) BOOL visiable;//是否显示

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
