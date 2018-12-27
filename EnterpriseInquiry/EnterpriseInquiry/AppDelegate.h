//
//  AppDelegate.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/8/8.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "HelpViewController.h"
#import "SLPagingViewController.h"
#import "BasicNavigationController.h"
#import "UserCenterController.h"
#import <IQKeyboardManager.h>

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "OwnerMessageVC.h"
//#import "DownTaskController.h"
#import <AFNetworkReachabilityManager.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SLPagingViewController *pageViewController;

@property (nonatomic,strong)BMKMapManager *mapManager;

@property (nonatomic, strong) BMKGeoCodeSearch *rsearch; // 地理编码

@property (nonatomic,strong) UIImageView *quitImageView;

@property (nonatomic ,assign) BOOL isHelepWillShow;//帮助页将要显示
@property (nonatomic ,assign) BOOL isUserWillShow;


-(void)setRootView;

@end

