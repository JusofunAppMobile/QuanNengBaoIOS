//
//  QuestionView.m
//  EnterpriseInquiry
//
//  Created by clj on 16/8/10.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "QuestionView.h"

#define BLACKWIDTH [UIScreen mainScreen].bounds.size.width - 40

@implementation QuestionView
{
    UIView *blackGroundView;//底部视图
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        blackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLACKWIDTH, KDeviceH - 100)];
        blackGroundView.backgroundColor = [UIColor whiteColor];
        blackGroundView.layer.cornerRadius = 10;
        blackGroundView.clipsToBounds = YES;
        [self addSubview:blackGroundView];
        
        [blackGroundView addSubview:[self titleLabel]];
        [blackGroundView addSubview:[self showImageView]];
        [blackGroundView addSubview:[self descLabel]];
        [blackGroundView addSubview:[self joinButton]];
        [blackGroundView addSubview:[self laterButton]];
    }
    return self;
}





-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35,BLACKWIDTH- 30 , 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UIImageView *)showImageView
{
    if (_showImageView == nil) {
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLabel.frame) + 20, BLACKWIDTH - 40, 160)];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showImageView.backgroundColor = [UIColor lightGrayColor];
        _showImageView.clipsToBounds = YES;
        
    }
    return _showImageView;
}


-(UILabel *)descLabel
{
    if (_descLabel == nil) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_showImageView.frame) + 25, BLACKWIDTH - 40, 80)];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        
        _descLabel.numberOfLines = 5;
        _descLabel.textColor = KHexRGB(0x666666);
        
    }
    return _descLabel;
}


-(UIButton *)joinButton
{
    if (_joinButton == nil) {
        _joinButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _joinButton.backgroundColor = KHexRGB(0x2dcc8a);
        _joinButton.clipsToBounds = YES;
        [_joinButton addTarget:self action:@selector(joinMonent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinButton;
}

-(UIButton *)laterButton
{
    if (_laterButton == nil) {
        _laterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _laterButton.backgroundColor = KHexRGB(0xd0d0d0);
        _laterButton.clipsToBounds = YES;
        [_laterButton addTarget:self action:@selector(laterDeal) forControlEvents:UIControlEventTouchUpInside];
    }
    return _laterButton;
}






/**
 *  Description
 *
 *  @param questionModel questionModel description
 *  @param type          1:问卷调查   2.工资宣传
 */
-(void)layoutQuestionViewsWithQuestionModel:(QuestionModel *)questionModel andType:(NSInteger)type

{
    self.currentQuestionModel = questionModel;
    self.type = type;
    _titleLabel.text = questionModel.title;
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:questionModel.imageurl] placeholderImage:nil];
    _descLabel.text = questionModel.content;
    _descLabel.font = [UIFont boldSystemFontOfSize:14];
    CGFloat height = [Tools getHeightWithString:questionModel.content fontSize:14 maxWidth:BLACKWIDTH - 40];
    CGRect orginFrame = _descLabel.frame;
    orginFrame.size.height = height;
    _descLabel.frame = orginFrame;
    
    
    CGFloat buttonWidth;
    if (type == 1)
    {
        buttonWidth = (BLACKWIDTH - 45)/2;
        
        _joinButton.frame =CGRectMake(15, CGRectGetMaxY(_descLabel.frame) + 10, buttonWidth, 44);
        _joinButton.layer.cornerRadius = 15;
        _joinButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        //        [joinButton jm_setCornerRadius:5 withBackgroundColor:KHexRGB(0x2dcc8a)];
        
        _laterButton .frame = CGRectMake(CGRectGetMaxX(_joinButton.frame) + 15, CGRectGetMaxY(_descLabel.frame) + 10 ,buttonWidth,44);
        _laterButton.layer.cornerRadius = 15;
        _laterButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        
        //        [laterButton jm_setCornerRadius:5 withBackgroundColor:KHexRGB(0xd0d0d0)];
        //        laterButton.clipsToBounds = YES;
    }else
    {
        
        _joinButton.frame = CGRectMake(30, CGRectGetMaxY(_descLabel.frame) + 10, blackGroundView.frame.size.width - 60, 44);
        _joinButton.layer.cornerRadius = 20;
        _joinButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        
        _laterButton.frame = CGRectMake(30,CGRectGetMaxY(_joinButton.frame) + 10 ,blackGroundView.frame.size.width - 60,44);
        _laterButton.layer.cornerRadius = 20;
        _laterButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        //        _laterButton.backgroundColor = KHexRGB(0x2dcc8a);
    }
    [_joinButton setTitle:questionModel.join forState:UIControlStateNormal];
    [_laterButton setTitle:questionModel.cancle forState:UIControlStateNormal];
    
    blackGroundView.frame = CGRectMake(0, 0, BLACKWIDTH, CGRectGetMaxY(_laterButton.frame) + 25) ;
    blackGroundView.center = CGPointMake(KDeviceW/2, KDeviceH/2);
    
    
    
}


//- (instancetype)initWithFrame:(CGRect)frame andQuestionModel:(QuestionModel *)questModel
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.currentQuestionModel = questModel;
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
////        [self layoutviewsWithFrame:frame andQuestionModel:questModel];
//        [self addSubview:blackGroundView];
//    }
//    return self;
//}

-(void)show
{
    [self removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)close
{
    [self removeFromSuperview];
}


#pragma mark- 立即参加
-(void)joinMonent
{
    if (self.type == 1) {//1:问卷调查  2:工资查询
        [MobClick event:@"advert23"];//启动广告页－左按键点击数
        [[BaiduMobStat defaultStat] logEvent:@"advert23" eventLabel:@"启动广告页－左按键点击数"];
        if (_delegate &&[_delegate respondsToSelector:@selector(joinWithQuestionModel:)]) {
            [_delegate joinWithQuestionModel:_currentQuestionModel];
        }
    }else
    {
        [MobClick event:@"advert26"];//工资查询宣传页－上按键点击数
        [[BaiduMobStat defaultStat] logEvent:@"advert26" eventLabel:@"工资查询宣传页－上按键点击数"];

        [self removeFromSuperview];
    }
}

#pragma mark - 以后再说
-(void)laterDeal
{
    if(self.type == 2)
    {
        [MobClick event:@"advert27"];//工资查询宣传页－下按键点击数
        [[BaiduMobStat defaultStat] logEvent:@"advert27" eventLabel:@"工资查询宣传页－下按键点击数"];

    }else
    {
        [MobClick event:@"advert24"];//启动广告页－右按键点击数
        [[BaiduMobStat defaultStat] logEvent:@"advert24" eventLabel:@"启动广告页－右按键点击数"];

    }
    [self close];
}


@end
