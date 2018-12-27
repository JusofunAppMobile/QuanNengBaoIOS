//
//  HomeTabHeader.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/4.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "HomeTabHeader.h"

#define BTN_TAG 1234
@interface HomeTabHeader ()

@property (nonatomic ,strong) UIButton *selectedBtn;

@property (nonatomic ,strong) UIView *lineView;

@property (nonatomic ,strong) UIButton *hotBtn;

@property (nonatomic ,strong) UIButton *newsBtn;

@property (nonatomic ,strong) UIView *greenView;

@end

@implementation HomeTabHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

    
        self.hotBtn = ({
        
            UIButton *view = [UIButton new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.mas_equalTo(self.contentView);
                make.width.mas_equalTo(KDeviceW).priorityHigh(1000);
            }];
            view.tag = BTN_TAG+0;
            view.titleLabel.font = [UIFont fontWithName:FontName size:14];
            [view setAttributedTitle:[self getAttributeTitle:@"热门企业（近7天）" state:0] forState:UIControlStateNormal];
            [view setAttributedTitle:[self getAttributeTitle:@"热门企业（近7天）" state:1] forState:UIControlStateSelected];
            [view addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
            view.enabled = NO;
            view;
        });
        
        
        self.newsBtn = ({
        
            UIButton *view = [UIButton new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.bottom.mas_equalTo(self.contentView);
                make.left.mas_equalTo(_hotBtn.mas_right);
            }];
            view.tag = BTN_TAG+1;
            view.titleLabel.font = [UIFont fontWithName:FontName size:14];
            [view setAttributedTitle:[self getAttributeTitle:@"新增企业（近90天）" state:0] forState:UIControlStateNormal];
            [view setAttributedTitle:[self getAttributeTitle:@"新增企业（近90天）" state:1] forState:UIControlStateSelected];
            [view addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
            view.enabled = NO;
            view;
        });
        
        
        self.greenView = ({
            UIView *view = [UIView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(5);
                make.height.mas_equalTo(12);
                make.centerY.mas_equalTo(self.contentView);
            }];
            view.backgroundColor = KHexRGB(0x61DDB4);
            view;
        });

        self.lineView = ({
            UIView *view = [UIView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.mas_equalTo(self.contentView);
                make.height.mas_equalTo(2).priorityHigh(1000);//防止约束冲突
                make.width.mas_equalTo(KDeviceW/2);
            }];
            view.backgroundColor = KHexRGB(0xff6b29);
            view;
        });
        [self layoutIfNeeded];//防止线动画时，hot按钮突变

//        [self updateFrames:0];
        [self tabAction:_hotBtn];
        
    }
    return self;
}

- (void)tabAction:(UIButton *)sender{

    if ([_selectedBtn isEqual:sender]) {
        return;
    }
    
    _selectedBtn.selected = NO;
    _selectedBtn = sender;
    _selectedBtn.selected = YES;
    
    [self lineAnimation];

    if ([_delegate respondsToSelector:@selector(selectTapAtIndex:)]) {
        [_delegate selectTapAtIndex:_selectedBtn.tag-BTN_TAG];
    }
}

- (void)loadHeaderWithType:(NSInteger)type{
    [self updateFrames:type];
}

//type:1只有热门企业 2都有 3只有新增企业
- (void)updateFrames:(NSInteger)type{
    
    if (type == 1) {
        [_hotBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KDeviceW).priorityHigh(1000);
        }];
        _hotBtn.hidden = NO;
        _newsBtn.hidden = YES;
        
        _hotBtn.selected = NO;
        _hotBtn.enabled = NO;
        
        _lineView.hidden = YES;
        _greenView.hidden = NO;
        _hotBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _hotBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        self.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];

    }else if(type ==2){
        
        [_hotBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KDeviceW/2).priorityHigh(1000);
        }];
        _hotBtn.hidden = NO;
        _newsBtn.hidden = NO;
        _hotBtn.enabled = YES;
        _newsBtn.enabled = YES;
        
        _lineView.hidden = NO;
        _greenView.hidden = YES;
       
        _hotBtn.selected = YES;

        _newsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _hotBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _hotBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _newsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }else if(type == 3){
        
        [_hotBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        _hotBtn.hidden = YES;
        _newsBtn.hidden = NO;
        
        _newsBtn.selected = NO;
        _newsBtn.enabled = NO;
        
        _lineView.hidden = YES;
        _greenView.hidden = NO;
        
        _newsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _newsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);

        self.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];

    }


}

- (void)lineAnimation{
    if (_lineView.hidden) {
        return;
    }
    [UIView animateWithDuration:.3 animations:^{
        [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo((KDeviceW/2)*(_selectedBtn.tag - BTN_TAG));
            make.left.mas_equalTo(self.contentView).offset((KDeviceW/2)*(_selectedBtn.tag - BTN_TAG));
        }];
        [self layoutIfNeeded];
    }];
}

- (NSAttributedString *)getAttributeTitle:(NSString *)title state:(int)state{
    
    UIColor *color= nil;
    if (state == 0) {
        color = [UIColor blackColor];
    }else{
        color = KHexRGB(0xff6400);
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:title];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontName size:10] range:NSMakeRange(4, title.length-4)];//天数
    [str addAttribute:NSForegroundColorAttributeName value:KHexRGB(0x999999) range:NSMakeRange(4, title.length-4)];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, 4)];

    return str;
}



@end
