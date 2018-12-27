//
//  NewCompanyCell.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/5.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewAddModel;

@protocol NewAddCompanyDelegate <NSObject>

- (void)newAddCompanyClicked:(NewAddModel *)model;

@end

@interface NewCompanyCell : UITableViewCell
@property (nonatomic ,strong) NSArray *addList;
@property (nonatomic, weak) id<NewAddCompanyDelegate>delegate;

@end
