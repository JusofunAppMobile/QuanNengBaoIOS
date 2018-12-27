//
//  FilterCollectionCell.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/12.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "FilterCollectionCell.h"
#import "ChooseView.h"

@interface FilterCollectionCell()

@property (nonatomic ,strong) UIView *selectedView;
@property (nonatomic ,strong) UIButton *titleBtn;
@property (nonatomic ,strong) UIImageView *iconView;

@end

@implementation FilterCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor=[UIColor whiteColor];
        self.layer.borderWidth=.5;
        self.layer.cornerRadius = 2;
        self.layer.borderColor=KHexRGB(0xc8c8c8).CGColor;
        
        
        self.titleBtn = [UIButton new];
        [_titleBtn addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        _titleBtn.titleLabel.font = KFont(12);
        [_titleBtn setTitleColor:KHexRGB(0x666666) forState:UIControlStateNormal];
        [_titleBtn setTitleColor:KHexRGB(0x458ef8) forState:UIControlStateSelected];
        [self.contentView addSubview:_titleBtn];
        [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        self.iconView = [UIImageView new];
        _iconView.image = KImageName(@"对号");
        _iconView.hidden = YES;
        [_titleBtn addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.mas_equalTo(_titleBtn);
        }];
    }
    return self;
}

- (void)itemAction:(UIButton *)button{
    if (_model.selected) {
        if ([self.delegate respondsToSelector:@selector(deselectCollectionViewCell:)]) {
            [self.delegate deselectCollectionViewCell:_model];
        }
    }else{
        
        if ([self.delegate respondsToSelector:@selector(selectCollectionViewCell:)]) {
            [self.delegate selectCollectionViewCell:_model];
        }
    }
}

- (void)setModel:(FilterCellModel *)model{
    _model = model;
    if ([model.type isEqualToString:@"1"]&&[model.value isEqualToString:KDingWei]) {
        [_titleBtn setImage:KImageName(@"Pin") forState:UIControlStateNormal];
    }else{
        [_titleBtn setImage:nil forState:UIControlStateNormal];
    }
    [_titleBtn setTitle:model.name forState:UIControlStateNormal];
    [self changeState:model.selected];
}

- (void)changeState:(BOOL)selected{
    _titleBtn.selected = selected;
    _iconView.hidden = !selected;
    
    if (selected) {
        self.layer.borderColor=KHexRGB(0x458ef8).CGColor;
    }else{
        self.layer.borderColor=KHexRGB(0xc8c8c8).CGColor;
    }
}


@end

