//
//  HotNewsCell.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/4.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "HotNewsCell.h"
#import "HotNewsItem.h"


@interface HotNewsCell ()

@property (nonatomic ,strong) HotNewsItem *item1;

@property (nonatomic ,strong) HotNewsItem *item2;

@property (nonatomic ,strong) HotNewsItem *item3;

@end



@implementation HotNewsCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat width = (KDeviceW - 15*2 - 10*2)/3;
        
        self.item1 = ({
            HotNewsItem *item = [HotNewsItem new];
            [self.contentView addSubview:item];
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.mas_equalTo(self.contentView).offset(15);
                make.bottom.mas_equalTo(self.contentView).offset(-15);
                make.width.mas_equalTo(width);
            }];
            [item layoutIfNeeded];
            item;
        });
        
        [self.item1 addTarget:self action:@selector(cellSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        self.item2 = ({
            HotNewsItem *item = [HotNewsItem new];
            [self.contentView addSubview:item];
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_item1.mas_right).offset(10);
                make.top.bottom.width.mas_equalTo(_item1);
            }];
            item;
        });
        [self.item2 addTarget:self action:@selector(cellSelect:) forControlEvents:UIControlEventTouchUpInside];
        self.item3 = ({
            HotNewsItem *item = [HotNewsItem new];
            [self.contentView addSubview:item];
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_item2.mas_right).offset(10);
                make.top.bottom.width.mas_equalTo(_item1);
            }];
            item;
        });
        [self.item3 addTarget:self action:@selector(cellSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


-(void)cellSelect:(UIButton*)button
{
    HotNewsItem *item = (HotNewsItem*)button;
    if(self.delegate && [self.delegate respondsToSelector:@selector(newsSelect:)])
    {
        [self.delegate newsSelect:item.model];
    }
}


- (void)loadCell:(NSArray *)models{
    if (models.count<3) {
        return;
    }
    _item1.model = models[0];
    _item2.model = models[1];
    _item3.model = models[2];
}


@end


