//
//  Verification.h
//  Templetion
//  验证类
//  Created by huang on 15/1/29.
//  Copyright (c) 2015年 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Verification : NSObject

//验证非空
+(BOOL)validateNullOrEmpty:(NSString *)string;

+(NSString *)rebackStrIfNull:(NSString *)string;

//验证长度不能超过20位
+(BOOL)validateStringLength:(NSString *)string;
//验证手机号码
+(BOOL)validatePhoneNumber:(NSString *)phoneNumber;
//验证float类型的数据
+(BOOL)validateFloatNumber:(NSString *)string;
//验证数字输入
+(BOOL)validateNumber:(NSString *)string;
//验证身份证号码
+(BOOL)validateIDCardNumber:(NSString *)string;
//验证邮箱
+ (BOOL) validateEmail:(NSString *)email;

+(NSString *)titleNameWithNickName:(NSString *)nickName andRemarkName:(NSString *)remark;
@end
