//
//  Verification.m
//  Templetion
//  
//  Created by huang on 15/1/29.
//  Copyright (c) 2015年 huang. All rights reserved.
//

#import "Verification.h"


@implementation Verification




#pragma mark - 验证非空
+(BOOL)validateNullOrEmpty:(NSString *)string {
    NSString *regex = @"^\\s*$";
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [regexTest evaluateWithObject:string];
}

+(NSString *)rebackStrIfNull:(NSString *)string
{
    if([ self validateNullOrEmpty:string ])
    {
        return @"";
    }
    else
    {
        return string;
    }
}

#pragma mark - 验证字符长度
+(BOOL)validateStringLength:(NSString *)string {
    if (string.length < 20) {
        return YES;
    }
    return NO;
}

#pragma mark - 手机号码验证
+(BOOL)validatePhoneNumber:(NSString *)phoneNumber {
    NSString *reg = @"^((13[0-9])|(14[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
//    NSString *regex = @"^(((\\d{2,3}))|(\\d{3}\\-))?((0\\d{2,3})|0\\d{2,3}-)?[1-9]\\d{6,7}(\\-\\d{1,4})?$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    return [pred1 evaluateWithObject:phoneNumber];//||[pred1 evaluateWithObject:phoneNumber];
}

#pragma mark - 验证浮点行数据包含2位小数
+(BOOL)validateFloatNumber:(NSString *)string {
    NSString *regex = @"^[1-9]{1}+(\\d{0,})?+(\\.\\d{1,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:string];
}

#pragma mark - 验证数字
//^[0-9]*$
+(BOOL)validateNumber:(NSString *)string {
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:string];
}

#pragma mark - 验证身份证号码
+(BOOL)validateIDCardNumber:(NSString *)string {
    NSString *regex = @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:string];
}

#pragma mark - 邮箱正则验证
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


+(NSString *)titleNameWithNickName:(NSString *)nickName andRemarkName:(NSString *)remark
{
    if (remark.length == 0) {
        return  nickName;
    }
    else
    {
        return remark;
    }
}



@end
