//
//  HomeNewsHeader.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/4.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeNewsHeaderDelegate <NSObject>

- (void)didTapSectionHeader:(BOOL)index;

@end

@interface HomeNewsHeader : UITableViewHeaderFooterView

@property (nonatomic ,weak) id <HomeNewsHeaderDelegate>delegate;
- (void)loadHeader:(NSString *)title isHot:(BOOL)isHot;

@end
