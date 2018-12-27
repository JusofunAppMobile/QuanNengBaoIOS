//
//  SearchController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/15.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import "SearchResultController.h"
#import "SearchHistoryCell.h"

@interface SearchController : BasicViewController<SearchBackDelegate,SearchHistoryCellDelegate>

@property (nonatomic,assign) SearchType searchType;

@property (nonatomic ,copy) NSString *searchKey;

@end
