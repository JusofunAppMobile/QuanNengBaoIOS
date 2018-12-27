//
//  HomeSectionHeader.h
//  EnterpriseInquiry
//
//  Created by wzh on 2018/1/5.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionHeaderDelegate <NSObject>

- (void)sectionHeaderMoreBtnClicked:(NSString *)title;

@end

@interface HomeSectionHeader : UITableViewHeaderFooterView

@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,weak) id <SectionHeaderDelegate>delegate;

@end

