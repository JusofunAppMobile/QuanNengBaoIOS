//
//  HomeMoreFooter.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/5.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeMoreFooterDelegate <NSObject>

- (void)didTapMoreButton;

@end

@interface HomeMoreFooter : UITableViewHeaderFooterView

@property (nonatomic ,weak) id <HomeMoreFooterDelegate>delegate;

@end
