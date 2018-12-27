//
//  HotNewsModel.h
//  EnterpriseInquiry
//
//  Created by 方首滔 on 16/9/23.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsModel.h"
@interface HotNewsModel : NSObject
@property (nonatomic,strong) NSString *result;
@property (nonatomic,strong) NSString *msg;
@property (nonatomic,strong) NSString *count;
@property (nonatomic,strong) NSMutableArray *hotnewslist;
@end
