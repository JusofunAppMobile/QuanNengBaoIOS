//
//  NearListController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/12/21.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "NearDetailController.h"
#import "BlankSpaceView.h"
#import "NearListCell.h"
#import "NearSearchCondition.h"
@interface NearListController : BasicViewController<BlankSpaceViewDelegate>


@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSString *detailUrl;
@property (nonatomic,assign)  NSInteger maptype;
@property (nonatomic,strong) BMKUserLocation *MyCoordinate;

@property (nonatomic,strong) UITableView *dataTableView;

@property(nonatomic,assign)int loadNum;

-(void)loadData;
@end
