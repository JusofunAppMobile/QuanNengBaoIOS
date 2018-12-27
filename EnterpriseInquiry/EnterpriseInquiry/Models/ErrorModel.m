//
//  ErrorModel.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/11/2.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "ErrorModel.h"
#import "AnswerModel.h"
@implementation ErrorModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"answerlist":AnswerModel.class};
}

@end
