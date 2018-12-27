//
//  HotNewsItem.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/4.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "HotNewsItem.h"
#import "NewsModel.h"

@interface HotNewsItem ()

@property (nonatomic ,strong) UIImageView *iconView;

@property (nonatomic ,strong) UILabel *numLab;

@property (nonatomic ,strong) UILabel *titleLab;

@end

@implementation HotNewsItem

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.iconView = ({
            UIImageView *view = [UIImageView new];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self);
                make.height.mas_equalTo(80);
            }];
            view.image = KImageName(@"test_home");
            view;
        });
        
        UIView *numLabelView = [[UIView alloc]init];
        numLabelView.layer.backgroundColor = [[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f] CGColor];
        numLabelView.alpha = 0.3;
        [self addSubview:numLabelView];
        [numLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_iconView);
            make.height.mas_equalTo(15);
        }];
        
        self.numLab = ({
            UILabel *view = [UILabel new];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_iconView).offset(5);
                make.right.mas_equalTo(_iconView).offset(-5);
                make.bottom.mas_equalTo(_iconView);
                make.height.mas_equalTo(15);
            }];
            view.text = @"121阅读";
            view.font = KFont(9);
            view.textColor = [UIColor whiteColor];
            view.backgroundColor = [UIColor clearColor];
            view.textAlignment = NSTextAlignmentRight;
            view;
        });
    
        self.titleLab = ({
            UILabel *view = [UILabel new];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_iconView.mas_bottom).offset(10);
                make.left.right.mas_equalTo(_iconView);
            }];
            view.numberOfLines = 2;
            view.text = @"1分钟学会百度云8秒视频怎么破";
            view.font = KFont(14);
            view;
        });
        
    }
    return self;
}

- (void)setModel:(NewsModel *)model{
    
    _model = model;
    
    _numLab.text = [NSString stringWithFormat:@"%@ 阅读",model.newreadcount] ;
    _titleLab.text = model.newstitle;
    //[_iconView sd_setImageWithURL:[NSURL URLWithString:model.newsimgurl]];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.newsimgurl] placeholderImage:[UIImage imageNamed:@"info_moretu"]];
}


@end
