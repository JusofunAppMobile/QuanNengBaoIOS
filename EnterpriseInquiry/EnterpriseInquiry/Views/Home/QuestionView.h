//
//  QuestionView.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/10.
//  Copyright © 2016年 王志朋. All rights reserved.
//
//问卷调查页
#import <UIKit/UIKit.h>
#import "QuestionModel.h"

@protocol QuestionViewDelegate <NSObject>

-(void)joinWithQuestionModel:(QuestionModel *)questionModel;

@end

@interface QuestionView : UIView

@property (nonatomic,assign) id<QuestionViewDelegate> delegate;
@property (nonatomic,strong) QuestionModel *currentQuestionModel;
@property (nonatomic,assign) NSInteger type;


@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UILabel *descLabel;
@property (nonatomic,strong) UIButton *joinButton;
@property (nonatomic,strong) UIButton *laterButton;


-(void)layoutQuestionViewsWithQuestionModel:(QuestionModel *)questionModel andType:(NSInteger)type;

-(void)show;

-(void)close;

@end
