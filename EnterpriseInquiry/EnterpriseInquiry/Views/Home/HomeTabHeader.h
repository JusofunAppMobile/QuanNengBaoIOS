//
//  HomeTabHeader.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/4.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeTabHeaderDelegate <NSObject>

- (void)selectTapAtIndex:(NSInteger)index;

@end

@interface HomeTabHeader : UITableViewHeaderFooterView

@property (nonatomic ,weak) id <HomeTabHeaderDelegate>delegate;


- (void)loadHeaderWithType:(NSInteger)type;
@end
