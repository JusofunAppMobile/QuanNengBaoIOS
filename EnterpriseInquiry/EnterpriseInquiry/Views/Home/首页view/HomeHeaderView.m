//
//  HomeHeaderView.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/4.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "HomeHeaderView.h"
#import "CenterButton.h"

@interface HomeHeaderView()
@property (nonatomic ,strong) NSArray *titleArr;
@end

@implementation HomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.titleArr = @[@"股东穿透",@"股东高管",@"主营产品",@"地址电话",@"失信查询",@"查税号",@"招聘",@"全部"];
        
        self.bannerView = ({
            UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KDeviceW, HomeBannerHeight)];
            view.image = KImageName(@"banner");
            [self addSubview:view];
            view;
        });
        
        CGFloat searchW = 370*KDeviceW/375.f;
        CGFloat searchH = 80*KDeviceW/375.f;
        CGFloat y = 110*KDeviceW/375;
        
        self.searchBtnView = [[SearchButton alloc] initWithFrame:CGRectMake((KDeviceW-searchW)/2, y, searchW, searchH) andPlaceText:KSearchPlaceholder];
        [_searchBtnView setBackgroundImage:KImageName(@"首页搜索") forState:UIControlStateNormal];
        [self addSubview:_searchBtnView];
        
        
        UIImageView *buttonBg = [[UIImageView alloc]initWithFrame:CGRectMake(12, _searchBtnView.maxY+70, KDeviceW-12*2, 0)];
        buttonBg.image = KImageName(@"首页底卡");
        buttonBg.userInteractionEnabled = YES;
        [self addSubview:buttonBg];
        
        
        CGFloat orginx = 15;
        CGFloat width = (buttonBg.width - 15*2)/4;
        
        for (int i = 0; i<8; i++) {
            int col = i%4;//列数
            int row = i/4;//行数
            CenterButton *centButton = [[CenterButton alloc] initWithFrame:CGRectMake(orginx+ col * width, row*width, width, width)];
            centButton.tag = 100+ i;
            centButton.titleLabel.font = KFont(13);
            [centButton setTitle:_titleArr[i] forState:UIControlStateNormal];
            [centButton setTitleColor:KHexRGB(0x333333) forState:UIControlStateNormal];
            [centButton setTitleColor:KHexRGB(0x666666) forState:UIControlStateDisabled];
            [centButton setImage:[UIImage imageNamed:_titleArr[i]] forState:UIControlStateNormal];
            [centButton addTarget:self action:@selector(gotoSearch:) forControlEvents:UIControlEventTouchUpInside];
            [buttonBg addSubview:centButton];
            if (i==7) {
                buttonBg.frame = CGRectMake(12, _searchBtnView.maxY+70, KDeviceW-12*2, centButton.maxY);
            }
#warning ========== near close =========================
            if(i == 0 || i == 7)
            {
                centButton.enabled = NO;
            }
#warning ========== near close =========================
        }
        
        
        
    }
    return self;
}


- (void)gotoSearch:(UIButton *)button{
    
    if ([_delegate respondsToSelector:@selector(headerBtnClicked:)]) {
        
        [_delegate headerBtnClicked:button];
    }
}



@end

