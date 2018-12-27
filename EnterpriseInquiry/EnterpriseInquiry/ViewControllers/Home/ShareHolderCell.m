//
//  ShareHolderCell.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/11/1.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "ShareHolderCell.h"
#import "ChangeDetailModel.h"

@interface ShareHolderCell ()

@property (nonatomic ,strong) UILabel *compLab;
@property (nonatomic ,strong) UILabel *beforeTitle;
@property (nonatomic ,strong) UILabel *afterTitle;
@property (nonatomic ,strong) UILabel *timeLab;
@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong) UIView *lastView;

@end

@implementation ShareHolderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.compLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.top.mas_equalTo(10);
            }];
            view.text = @"北京雷神科技有限责任公司";
            view.font = KFont(16);
            view;
        });
        
        self.timeLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_compLab);
                make.top.mas_equalTo(_compLab.mas_bottom).offset(5);
            }];
            view.font = KFont(13);
            view.textColor = KHexRGB(0x999999);
            view.text = @"2017-10-31";
            view;
        });
        
        
        self.beforeTitle = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.top.mas_equalTo(_timeLab.mas_bottom).offset(10);
                make.right.mas_equalTo(-KDeviceW/2-10);
            }];
            view.font = KFont(13);
            view.text = @"变更前：";
            view.textColor = KHexRGB(0x3075e1);
            view;
        });
        
        self.afterTitle = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(KDeviceW/2+15);
                make.top.mas_equalTo(_beforeTitle);
                make.right.mas_equalTo(-15);
            }];
            view.text = @"变更后：";
            view.font = KFont(13);
            view.textColor = KHexRGB(0xff6500);
            view;
        });

        self.lineView = ({
            UIView *view = [UIView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_beforeTitle);
                make.bottom.mas_equalTo(self.contentView).offset(-20);
                make.centerX.mas_equalTo(self.contentView);
                make.width.mas_equalTo(1);
            }];
            view.backgroundColor = KHexRGB(0xd8d8d8);;
            view;
        });
        
    }
    return self;
}

//- (void)setModel:(ChangeDetailModel *)model{
//    _model = model;
//    if (model.beforlist&&model.afterlist) {//股东
//    }else{
//        [self createLabelWithList:model.beforlist before:YES];
//        [self createLabelWithList:model.afterlist before:NO];
//    }
//}

- (void)createLabelWithList:(NSArray *)list before:(BOOL)before{
    
    _lastView = nil;
    for (int i = 0; i<3; i++) {
        
        UILabel *nameLab = [UILabel new];
        [self.contentView addSubview:nameLab];
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(before?_beforeTitle:_afterTitle);
            if (_lastView) {
                make.top.mas_equalTo(_lastView.mas_bottom).offset(20);
            }else{
                make.top.mas_equalTo(_beforeTitle.mas_bottom).offset(20);
            }
        }];
        nameLab.numberOfLines = 0;
        nameLab.font = KFont(14);
        nameLab.text = @"雷神";

        UILabel *typeLab = [UILabel new];
        [self.contentView addSubview:typeLab];
        [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(nameLab);
            make.top.mas_equalTo(nameLab.mas_bottom).offset(10);
        }];
        typeLab.text = @"类型：";
        typeLab.textColor = KHexRGB(0x999999);
        typeLab.font = KFont(13);
        
        
        UILabel *typeContent = [UILabel new];
        [self.contentView addSubview:typeContent];
        [typeContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(nameLab);
            make.top.mas_equalTo(typeLab.mas_bottom).offset(10);
            make.bottom.mas_lessThanOrEqualTo(self.contentView).offset(-20);
        }];
        typeContent.text = @"自然人股东";
        typeContent.font = KFont(14);
        
        _lastView = typeContent;
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
