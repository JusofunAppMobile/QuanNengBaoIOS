//
//  ChangeTextCell.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/11/9.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "ChangeTextCell.h"
#import "ChangeDetailModel.h"

@interface ChangeTextCell ()

@property (nonatomic ,strong) UILabel *compLab;
@property (nonatomic ,strong) UILabel *beforeTitle;
@property (nonatomic ,strong) UILabel *afterTitle;
@property (nonatomic ,strong) UILabel *timeLab;
@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong) UIView *lastView;
@property (nonatomic ,strong) UITextView *leftText;
@property (nonatomic ,strong) UITextView *rightText;

@end

@implementation ChangeTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.compLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.top.mas_equalTo(10);
                make.right.mas_equalTo(-15);
            }];
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
        
        self.leftText = ({
            UITextView *view = [UITextView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(_beforeTitle);
                make.top.mas_equalTo(_beforeTitle.mas_bottom).offset(15);
                make.bottom.mas_lessThanOrEqualTo(self.contentView).offset(-10);
            }];
            view.editable = NO;
            view.scrollEnabled = NO;
            view.contentInset = UIEdgeInsetsMake(-8, -5, 0, 0);
            view.font = KFont(14);
            view.textColor = KHexRGB(0x333333);
            view.userInteractionEnabled = NO;
            view;
        });
        
        self.rightText = ({
            UITextView *view = [UITextView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(_afterTitle);
                make.top.mas_equalTo(_afterTitle.mas_bottom).offset(15);
                make.bottom.mas_lessThanOrEqualTo(self.contentView).offset(-10);
            }];
            view.editable = NO;
            view.scrollEnabled = NO;
            view.contentInset = UIEdgeInsetsMake(-8, -5, 0, 0);
            view.font = KFont(14);
            view.textColor = KHexRGB(0x333333);
            view.userInteractionEnabled = NO;
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

- (void)setModel:(ChangeDetailModel *)model{

    _compLab.text = model.ename;
    
    NSString *time = model.changeDate.length>10?[NSString stringWithFormat:@"%li",(NSInteger)[model.changeDate longLongValue]/1000]:model.changeDate;
    _timeLab.text = [Tools timestampSwitchTime:time];
    
    NSString *str1 = [model.changeBefore stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    NSString *str2 = [model.changeAfter stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    
    _leftText.text = str1;
    _rightText.text = str2;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
