//
//  QuestionItem.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/11/2.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuestionItem;
@class ErrorModel;
@class AnswerModel;
@protocol QuestionDelegate <NSObject>

- (void)didSelectQuestionItem:(QuestionItem *)item answerModel:(AnswerModel *)model;

@end

@interface QuestionItem : UIView

@property (nonatomic ,weak) id <QuestionDelegate>delegate;

@property (nonatomic ,strong) ErrorModel *model;


- (instancetype)initWithOriginY:(CGFloat)y model:(ErrorModel *)model;

@end
