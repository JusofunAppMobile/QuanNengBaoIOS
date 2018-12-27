//
//  HelpModel.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/11.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppModel.h"

@interface HelpModel : NSObject
@property (nonatomic,strong) NSString *appintroduction;//应用简介
@property (nonatomic,strong) NSString *customeravatar;//客服头像
@property (nonatomic,strong) NSString *customermail;//客服邮箱
@property (nonatomic,strong) NSString *customerphone;//客服电话
@property (nonatomic,strong) NSString *customerqq;//客服QQ
@property (nonatomic,strong) NSString *qqgroup;//QQ群
@property (nonatomic,strong) NSDictionary *topData;//翻拍数据
@property (nonatomic,strong) NSArray *apprecommenlist;

@end
