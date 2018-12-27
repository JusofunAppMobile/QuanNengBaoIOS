//
//  QuestionItem.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/11/2.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "QuestionItem.h"
#import "ErrorModel.h"
#import "AnswerModel.h"

@interface QuestionItem ()
@property (nonatomic ,strong) UILabel *titleLab;
@property (nonatomic ,strong) UIButton *leftBtn;
@property (nonatomic ,strong) UIButton *rightBtn;
@property (nonatomic ,strong) UILabel *leftLab;
@property (nonatomic ,strong) UILabel *rightLab;

@end

@implementation QuestionItem

- (instancetype)initWithOriginY:(CGFloat)y model:(ErrorModel *)model{
    
    if (self = [super init]) {
        
        _model = model;
        
        AnswerModel *answerModel1 = model.answerlist[0];
        AnswerModel *answerModel2 = model.answerlist[1];
        
        
        _titleLab= [[UILabel alloc]initWithFrame:CGRectMake(15, 10, KDeviceW-15*2, [self getTextHeight:model.title])];
        _titleLab.numberOfLines = 0;
        _titleLab.font = KFont(14);
        _titleLab.textColor = KHexRGB(0x999999);
        _titleLab.text = model.title;
        [self addSubview:_titleLab];

        _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, _titleLab.maxY+10, 20, 20)];
        [_leftBtn setImage:KImageName(@"未选中") forState:UIControlStateNormal];
        [_leftBtn setImage:KImageName(@"选中") forState:UIControlStateSelected];
        [_leftBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBtn];
        
        _leftLab = [[UILabel alloc]initWithFrame:CGRectMake(_leftBtn.maxX+10, _leftBtn.y+(20-14)/2, 70, 14)];
        _leftLab.font = KFont(14);
        _leftLab.textColor = KHexRGB(0x333333);
        _leftLab.text = answerModel1.content;
        [self addSubview:_leftLab];
        
        
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(210, _leftBtn.y, 20, 20)];
        [_rightBtn setImage:KImageName(@"未选中") forState:UIControlStateNormal];
        [_rightBtn setImage:KImageName(@"选中") forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
        
        _rightLab = [[UILabel alloc]initWithFrame:CGRectMake(_rightBtn.maxX+10, _leftBtn.y+(20-14)/2, 70, 14)];
        _rightLab.font = KFont(14);
        _rightLab.textColor = KHexRGB(0x333333);
        _rightLab.text = answerModel2.content;
        [self addSubview:_rightLab];
        
        self.frame = CGRectMake(0, y, KDeviceW, _rightLab.maxY);
    }
    return self;
}


- (void)buttonAction:(UIButton *)sender{

    AnswerModel *aModel = nil;
    if ([sender isEqual:_leftBtn]) {
        _leftBtn.selected = YES;
        _rightBtn.selected = NO;
        aModel = _model.answerlist[0];
    }else{
        _rightBtn.selected = YES;
        _leftBtn.selected = NO;
        aModel = _model.answerlist[1];
    }
    
    if ([_delegate respondsToSelector:@selector(didSelectQuestionItem:answerModel:)]) {
        [_delegate didSelectQuestionItem:self answerModel:aModel];
    }
}

- (CGFloat)getTextHeight:(NSString *)text{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(KDeviceW-15*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return rect.size.height;
}
@end
