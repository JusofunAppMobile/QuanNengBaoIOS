//
//  SearchAllWebView.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/9/19.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchAllWeb)();

@interface SearchAllWebView : UIView

@property(nonatomic,copy)SearchAllWeb searchAllWeb;
@end
