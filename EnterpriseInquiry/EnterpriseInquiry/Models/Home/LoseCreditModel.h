//
//  LoseCreditModel.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/16.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoseCreditModel : NSObject

@property(nonatomic,copy)NSString *LoseCreditID;

@property(nonatomic,copy)NSString *name;

/**
 *  类型 0：人 1：公司
 */
@property(nonatomic,copy)NSString *type;

//证件号
@property(nonatomic,copy)NSString *credentials;

//地点
@property(nonatomic,copy)NSString *location;

@property(nonatomic,copy)NSString *time;

@property(nonatomic,copy)NSString *numbering;

@property(nonatomic,copy)NSString *url;
@end
