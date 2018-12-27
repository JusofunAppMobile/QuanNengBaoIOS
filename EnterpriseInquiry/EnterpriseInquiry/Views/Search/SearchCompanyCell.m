//
//  SearchCompanyCell.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/12/29.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "SearchCompanyCell.h"

@interface SearchCompanyCell()
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,assign) BOOL needRedraw;
@property (nonatomic ,strong) UILabel *compLab;
@property (nonatomic ,strong) UILabel *statusLab;
@property (nonatomic ,strong) UILabel *nameLab;
@property (nonatomic ,strong) UILabel *moneyLab;
@property (nonatomic ,strong) UILabel *dateLab;
@property (nonatomic ,strong) UIImageView *focusView;//命中
@property (nonatomic ,strong) UILabel *focusLab;

@end

@implementation SearchCompanyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = KHexRGB(0xf8f8fa);
        self.bgView =({
            UIView *bgView = [UIView new];
            bgView.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:bgView];
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self.contentView);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            }];
            bgView;
        });
        
        self.compLab = ({
            UILabel *view = [UILabel new];
            view.font = KFont(16);
            view.textColor = KHexRGB(0x333333);
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgView).offset(15);
                make.right.mas_equalTo(_bgView).offset(-15);
                make.top.mas_equalTo(_bgView.mas_top).offset(21);
                make.height.mas_equalTo(16);
            }];
            view;
        });
        
        self.statusLab = ({
            UILabel *view = [UILabel new];
            view.font = KFont(12);
            view.textColor = KHexRGB(0x1e9efb);
            view.layer.borderColor = KHexRGB(0x1e9efb).CGColor;
            view.layer.borderWidth = .5;
            view.layer.cornerRadius = 6;
            view.textAlignment = NSTextAlignmentCenter;
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_compLab);
                make.top.mas_equalTo(_compLab.mas_bottom).offset(10);
                make.width.mas_greaterThanOrEqualTo(35);
                make.height.mas_equalTo(19);

            }];
            view;
        });
        
        UILabel *nameTitle = ({
            UILabel *view = [UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_compLab);
                make.top.mas_equalTo(_statusLab.mas_bottom).offset(16);
                make.width.mas_equalTo(86);
                make.height.mas_equalTo(14);
            }];
            view.text = @"法定代表人：";
            view.font = KFont(14);
            view.textColor = KHexRGB(0x999999);
            view;
        });

        self.nameLab = ({
            UILabel *view = [UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(nameTitle.mas_right);
                make.right.mas_equalTo(_bgView).offset(-15);
                make.top.mas_equalTo(nameTitle);
                make.height.mas_equalTo(14);
            }];
            view.textColor = KHexRGB(0x1d6fe7);
            view.font = KFont(14);
            view;
        });

        UILabel *moneyTitle = ({
            UILabel *view = [UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(nameTitle);
                make.top.mas_equalTo(nameTitle.mas_bottom).offset(16);
                make.width.mas_equalTo(86);
                make.height.mas_equalTo(14);
            }];
            view.text = @"注册资金：";
            view.font = KFont(14);
            view.textColor =  KHexRGB(0x999999);
            view;
        });

        self.moneyLab = ({
            UILabel *view = [UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(_nameLab);
                make.top.mas_equalTo(moneyTitle);
                make.height.mas_equalTo(14);
            }];
            view.textColor = KHexRGB(0x333333);
            view.font = KFont(14);
            view;
        });

        UILabel *dateTitle = ({
            UILabel *view = [UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(moneyTitle);
                make.top.mas_equalTo(moneyTitle.mas_bottom).offset(16);
                make.width.mas_equalTo(86);
                make.height.mas_equalTo(14);
            }];
            view.font = KFont(14);
            view.textColor =  KHexRGB(0x999999);
            view.text = @"成立日期：";
            view;
        });

        self.dateLab = ({
            UILabel *view =[UILabel new];
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(_moneyLab);
                make.top.mas_equalTo(dateTitle);
                make.height.mas_equalTo(14);
            }];
            view.textColor = KHexRGB(0x333333);
            view.font = KFont(14);
            view;
        });

        self.focusView = ({
            UIImageView *view = [UIImageView new];
            view.image = [UIImage imageNamed:@"渐变彩条"];
//            view.backgroundColor = KHexRGB(0xfff7ed);
            [_bgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(_bgView);
                make.height.mas_equalTo(0);
            }];
            view.hidden = YES;
            view;
        });
        
        self.focusLab = ({
            UILabel *view = [UILabel new];
            [_focusView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_focusView).offset(15);
                make.centerY.mas_equalTo(_focusView);
                make.right.mas_equalTo(_focusView).offset(-15);
            }];
            view.textColor = KHexRGB(0x999999);
            view.font = KFont(12);
            view;
        });
    }
    return self;
}

- (void)setCompanyInfoModel:(CompanyInfoModel *)companyInfoModel{
    if (companyInfoModel) {
        _companyInfoModel = companyInfoModel;
        _nameLab.text = companyInfoModel.legal;
        _compLab.text = _companyInfoModel.companyname;
        _dateLab.text = _companyInfoModel.establish;
        _moneyLab.text = _companyInfoModel.funds.length?_companyInfoModel.funds:@"未公示";
        
        NSString *status = _companyInfoModel.companystate.length?_companyInfoModel.companystate:@"未知";
        _statusLab.text = status;
        
        //企业名称命中高亮
        if (companyInfoModel.companylightname.length>0) {
            _compLab.attributedText = [Tools titleNameWithTitle:companyInfoModel.companylightname otherColor:[UIColor blackColor]];
            _compLab.lineBreakMode = NSLineBreakByTruncatingTail;
        }else{
            _compLab.text  = companyInfoModel.companyname;
        }
        
        //企业状态 加宽
        [_statusLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([self getTextWidth:_statusLab.text]+12);
        }];

        //关联是否显示
        if ([companyInfoModel.related length]) {
            _focusLab.attributedText = [Tools titleNameWithTitle:_companyInfoModel.related otherColor:KHexRGB(0x262626)];;
            [_focusView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(30);
            }];
            _focusView.hidden = NO;
        }else{
            [_focusView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            _focusView.hidden = YES;
        }
    }
}


- (CGFloat)getTextWidth:(NSString *)text{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 19) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    return rect.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
