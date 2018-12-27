//
//  HelpViewController.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/10.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import "HelpModel.h"
#import "AppModel.h"
#import "AdviceViewController.h"
#import "CommonWebViewController.h"
#import "ZZCarouselControl.h"
#import "MyAlertView.h"

@interface HelpViewController : BasicViewController<UITableViewDelegate,UITableViewDataSource,ZZCarouselDataSource,ZZCarouselDelegate,UIAlertViewDelegate,MyAlertViewDelegate>

@property (nonatomic,strong) UIScrollView *mainScrollView;
//@property (nonatomic,assign) BOOL isScrollToHelp;//记录是否滑动到底帮助页面，并且标记是滑动帮助页面的还是SPL


@end
