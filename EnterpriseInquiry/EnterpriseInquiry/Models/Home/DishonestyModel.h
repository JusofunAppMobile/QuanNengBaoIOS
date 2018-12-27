//
//  DishonestyModel.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/11.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DishonestyMonthModel.h"

//失信模型
@interface DishonestyModel : NSObject
@property (nonatomic,strong) NSString *umeng_analytics;//点击模块标题的友盟事件
@property (nonatomic,strong) NSString *name;//
@property (nonatomic,strong) NSString *dishonestyurl;//失信链接
@property (nonatomic,strong) NSArray *dishonestylist;

@end
