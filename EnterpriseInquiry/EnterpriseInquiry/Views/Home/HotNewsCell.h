//
//  HotNewsCell.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/4.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsModel;
@protocol HotNewsDelegate <NSObject>


- (void)newsSelect:(NewsModel*)model;

@end



@interface HotNewsCell : UITableViewCell

@property(nonatomic,assign) id<HotNewsDelegate>delegate;


- (void)loadCell:(NSArray*) models;

@end
