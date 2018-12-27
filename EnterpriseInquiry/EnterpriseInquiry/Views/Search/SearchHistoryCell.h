//
//  SearchHistoryCell.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/15.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchHistoryCellDelegate <NSObject>

- (void)historyButtonClick:(NSString *)str;

@end

typedef enum : NSUInteger {
    SearchHistoryType,
    SearchHotType,
} SearchHistoryCellType;

@interface SearchHistoryCell : UITableViewCell


@property(nonatomic,assign)id<SearchHistoryCellDelegate>delegate;


- (void)setDataArray:(NSArray *)dataArray cellType:(SearchHistoryCellType)type;

@end

