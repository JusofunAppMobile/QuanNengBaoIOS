//
//  RadarCardCell.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/2/27.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "RadarCardCell.h"
#import "JDFlipNumberView.h"

@interface RadarCardCell()

@property (nonatomic ,strong) JDFlipNumberView *numberView;
@property (nonatomic ,strong) UILabel *typeLab;

@end

@implementation RadarCardCell


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIImageView *bgView = [UIImageView new];
    bgView.image = KImageName(@"radarBg");
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    self.numberView = ({
        JDFlipNumberView *view = [[JDFlipNumberView alloc]initWithDigitCount:1 imageBundleName:@"BlueDigitImage"];
        [bgView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView).offset(15);
            make.right.mas_equalTo(bgView).offset(-15);
            make.top.mas_equalTo(19);
            make.height.mas_equalTo(26.5);
        }];
        view.xDistance = 1;
        view;
    });
    
    self.typeLab = ({
        UILabel *view = [UILabel new];
        [bgView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_numberView.mas_bottom).offset(10);
            make.left.mas_equalTo(_numberView.mas_left).offset(5);
            make.right.mas_equalTo(_numberView);
        }];
        view.font = KFont(13);
        view.numberOfLines = 2;
        view.text = @"家企业进行了法人变更";
        view;
    });
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    NSString *number = data[@"count"];
    int type = [data[@"type"] intValue];
   
    switch (type) {
        case 1:
            _typeLab.text =@"家企业进行了法人变更";
            _typeLab.textColor = KHexRGB(0x4860bb);
            _numberView.imageBundleName = @"BlueDigitImage";

            break;
        case 2:
            _typeLab.text =@"家企业进行了股东变更";
            _typeLab.textColor = KHexRGB(0x0294ba);
            _numberView.imageBundleName = @"CyanDigitImage";

            break;
        case 3:
            _typeLab.text =@"家企业进行了资本变更";
            _typeLab.textColor = KHexRGB(0xeb9720);
            _numberView.imageBundleName = @"YellowDigitImage";
            break;
        case 4:
            _typeLab.text =@"家企业进行了名称变更";
            _typeLab.textColor = KHexRGB(0x7060b8);
            _numberView.imageBundleName = @"PurpleDigitImage";

            break;
        case 5:
            _typeLab.text =@"家企业进行了经营变更";
            _numberView.imageBundleName = @"GreenDigitImage";
            _typeLab.textColor = KHexRGB(0x009370);

            break;
        default:
            break;
    }
    
    _numberView.digitCount = [number length];
    _numberView.value = [number integerValue];
    [_numberView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(17*_numberView.digitCount);
    }];
    if (_numberView.digitCount<5) {//防止数字少的时候，下方文字显示不全
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(115);
        }];
    }
   
}



@end
