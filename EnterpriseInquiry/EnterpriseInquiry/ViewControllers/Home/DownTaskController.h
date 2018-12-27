//
//  DownTaskController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/7/31.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import "DownTaskModel.h"
#import <AFNetworkReachabilityManager.h>
#import "DownTaskView.h"
#import "HandWriteController.h"

#define KSaveTimeDic  @"SaveTimeDic"

#define KSaveDate   @"SaveDate"
#define KSaveSpace  @"SaveSpace"

#define KNextTime  5*60


@interface DownTaskController : BasicViewController

-(void)startRequest;





















@end
