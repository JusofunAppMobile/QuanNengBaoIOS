//
//  NewCompanyCell.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/5.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "NewCompanyCell.h"
#import "NewCompanyView.h"
#import "WLScrollView.h"

@interface NewCompanyCell ()<WLSubViewDelegate,WLScrollViewDelegate>
@property (nonatomic ,strong) WLScrollView *wlScrollView;
@end

@implementation NewCompanyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.wlScrollView = ({
            WLScrollView* view = [[WLScrollView alloc]initWithFrame:CGRectMake(0, 0, KDeviceW, 158)];
            view.delegate = self;
            view.isAnimation = NO;
            view.scale = 0.95;
            view.marginX = 5;
            view.backgroundColor = [UIColor clearColor];
            [view starRender];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView);
                make.height.mas_equalTo(158);
            }];
            view;
        });
    }
    return self;
}

#pragma mark cell赋值

- (void)setAddList:(NSArray *)addList{   
    if(_addList != addList)
    {
        _addList = addList;
        [_wlScrollView upConfig];
    }
}

- (NSInteger)numOfContentViewScrollView:(WLScrollView *)scrollView{
    return _addList.count;
}

- (WLSubView *)scrollView:(WLScrollView *)scrollView subViewFrame:(CGRect)frame cellAtIndex:(NSInteger)index{
    
    static NSString *cellID = @"123";
    NewCompanyView *sub = (NewCompanyView *)[scrollView dequeueReuseCellWithIdentifier:cellID];
    if (!sub) {
        sub = [[NewCompanyView alloc] initWithFrame:frame Identifier:cellID];
    }
    sub.model = _addList[index];
    sub.data = _addList[index];
    return sub;
}

- (void)scrollView:(WLScrollView *)scrollView didSelectedAtIndex:(NSInteger)index data:(id)data{
    if ([_delegate respondsToSelector:@selector(newAddCompanyClicked:)]) {
        [_delegate newAddCompanyClicked:(NewAddModel *)data];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

