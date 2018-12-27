//
//  AppModel.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/11.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject
@property (nonatomic,strong) NSString * appname;//app名称
@property (nonatomic,strong) NSString * appicon;//应用icon
@property (nonatomic,strong) NSString * appintro;//app简介
@property (nonatomic,strong) NSString * appurl;//详情url

@end
