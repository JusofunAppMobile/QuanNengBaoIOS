//
//  NearController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/12/21.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import "NearMapController.h"
#import "NearListController.h"
@interface NearController : BasicViewController


@property(nonatomic,strong)NearListController *listController;

@property(nonatomic,strong)NearMapController *mapController;


@end
