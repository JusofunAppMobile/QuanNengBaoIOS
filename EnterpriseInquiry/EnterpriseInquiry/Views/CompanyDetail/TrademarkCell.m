//
//  TrademarkCell.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/6.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "TrademarkCell.h"
#import "TrademarkModel.h"

@interface TrademarkCell ()

@property (nonatomic ,strong) UIImageView *iconView;

@property (nonatomic ,strong) UILabel *nameLab;

@property (nonatomic ,strong) UILabel *statusLab;

@property (nonatomic ,strong) UILabel *typeLab;


@end

@implementation TrademarkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.iconView = ({
            UIImageView *view = [UIImageView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(77);
                make.left.mas_equalTo(15);
                make.centerY.mas_equalTo(self.contentView);
            }];
            //view.backgroundColor = [UIColor greenColor];
            view;
        });
        
        //商标名称
        UILabel *nameTitle = [UILabel new];
        [self.contentView addSubview:nameTitle];
        [nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(77+30);
            make.top.mas_equalTo(24);
            make.width.mas_equalTo(70);
        }];
        nameTitle.text = @"商标名称：";
        nameTitle.font = KFont(13);
        nameTitle.textColor = KHexRGB(0x999999);
        
        //商标状态
        UILabel *statusTitle = [UILabel new];
        [self.contentView addSubview:statusTitle];
        [statusTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameTitle);
            make.top.mas_equalTo(nameTitle.mas_bottom).offset(11);
            make.width.mas_equalTo(nameTitle.mas_width);
        }];
        statusTitle.text = @"商标状态：";
        statusTitle.font = KFont(13);
        statusTitle.textColor = KHexRGB(0x999999);
        
        //商标类型
        UILabel *typeTitle = [UILabel new];
        [self.contentView addSubview:typeTitle];
        [typeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameTitle);
            make.top.mas_equalTo(statusTitle.mas_bottom).offset(11);
            make.width.mas_equalTo(nameTitle.mas_width);
        }];
        typeTitle.text = @"商标类型：";
        typeTitle.font = KFont(13);
        typeTitle.textColor = KHexRGB(0x999999);
        
        self.nameLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.baseline.mas_equalTo(nameTitle);
                make.left.mas_equalTo(nameTitle.mas_right);
                make.right.mas_equalTo(self.contentView).offset(-5);
            }];
            view.font = KFont(14);
            view.text = @"-";
            view;
        });
        
        self.statusLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(_nameLab);
                make.baseline.mas_equalTo(statusTitle);
            }];
            view.font = KFont(14);
            view.text = @"其它";
            view;
        });
        
        self.typeLab = ({
            UILabel *view = [UILabel new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(_nameLab);
                make.baseline.mas_equalTo(typeTitle);
            }];
            view.font = KFont(14);
            view.text = @"41-教育娱乐";
            view;
        });
        
    }
    return self;
}


- (void)loadCell:(TrademarkModel *)model{
    
    _nameLab.text = model.name;
    
    _statusLab.text = model.stauts;
    
    _typeLab.text = model.category;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.imgPath] placeholderImage:KImageName(@"brand")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
