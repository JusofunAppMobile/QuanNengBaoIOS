//
//  ErrorModel.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/11/2.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ErrorModel : NSObject

@property (nonatomic ,copy) NSString *title;//问题标题

@property (nonatomic ,copy) NSString *questionid;//问题id

@property (nonatomic ,copy) NSArray *answerlist;//答案列表


@end
