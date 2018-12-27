//
//  AppDelegate.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/8/8.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NewHomeViewController.h"
#import "NearSearchCondition.h"

@interface AppDelegate ()
{
    BMKLocationService * _locService;
    NSString *deviceTokenString;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //把启动页的StatusBar先隐藏进页面再显示出来
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [KNotificationCenter addObserver:self selector:@selector(sendDeviceToken) name:LOGIN_SUCCESS_NOTIFICATION object:nil];
    deviceTokenString = @"";
    [self setUseAgent];
    
    [self setReachbility];
    
   // [self setUmeng];
    
    [self setBaiduTJ];
    
   // [self registerShareSDK];
    
    [self startLocation];
    
    [self autologin];
    
    [self setIQKeyboardManager];
    
    [self setRootView];
    
    
    
    
    
    //延迟执行等待网络判断
//    [self performSelector:@selector(startRequest) withObject:nil afterDelay:2.0];
    
    // 注册APNS
    [self registerRemoteNotification];
    
    if (launchOptions) {
        NSDictionary*userInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if(userInfo)
        {
            //  [self didReiveceRemoteNotificatison:userInfo];
            [self  application:application didReceiveRemoteNotification:userInfo];
            
        }
    }
    
    //    NSLog(@"----------------%@",[UIDevice currentDevice].identifierForVendor.UUIDString);
    
    return YES;
}

-(void)didReiveceRemoteNotificatison:(NSDictionary *)userInfo{
    if (userInfo) {
        if (userInfo[@"c"]) {
            [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"pushType"];
            
            
            
        }
        
    }
}

//判定是否首次使用
- (BOOL)isFirstEverUsed
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //第一次启动时，会创建“everUsed”键值，并默认为假
    if (![userDefaults boolForKey:@"isFirstEverUsed1"]) {
        [userDefaults setBool:YES forKey:@"isFirstEverUsed1"];
        [userDefaults synchronize];
        return YES;
    }
    else{
        return NO;
    }
}
-(void)setRootView
{
    
    if ([self isFirstEverUsed]) {
        [KUserDefaults setObject:@"" forKey:ShowQuestion];
    }
    //首次安装app
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:AppIsFirst]) {
        [defaults setBool:YES forKey:AppIsFirst];
        [defaults setBool:YES forKey:QuestionISFirst];
    }else{
        [defaults setBool:NO forKey:QuestionISFirst];
    }
    
    [defaults setBool:YES forKey:homeIsFirst];
    [defaults synchronize];
    
    _isHelepWillShow = NO;
    _isUserWillShow = NO;
    __block AppDelegate *weakSelf = self;
    
    UserCenterController *userCenter = [UserCenterController new];
    HelpViewController *helpVC = [[HelpViewController alloc]init];
    NewHomeViewController *homeVC = [[NewHomeViewController alloc] init];
    
    UIImage *img1 = KImageName(@"左上角叹号");
    UIImage *img2 = KImageName(@"关于icon");
    UIImage *img3 = KImageName(@"右上角我的");
    self.quitImageView = [[UIImageView alloc] initWithImage:KImageName(@"退出icon")];
    self.quitImageView.frame = CGRectMake(0, 0, 20, 20);
    _pageViewController = [[SLPagingViewController alloc] initWithNavBarItems:@[[[UIImageView alloc] initWithImage:img1], [[UIImageView alloc] initWithImage:img2], [[UIImageView alloc] initWithImage:img3],self.quitImageView ]navBarBackground:[UIColor clearColor] controllers:@[helpVC,homeVC,userCenter]showPageControl:NO];
    _pageViewController.navigationSideItemsStyle = SLNavigationSideItemsStyleOnBounds;
    
    //设置开始显示的位置
    [_pageViewController setCurrentIndex:1 animated:NO];
    _pageViewController.pagingViewMovingRedefine = ^(UIScrollView * scrollView, NSArray *subviews)
    {
        //NSLog(@"%f",scrollView.contentOffset);
        
        
        UIImageView *homeSearchImageView =(UIImageView *)subviews[1];//首页的搜索图标
        UIImageView *meImageView =(UIImageView *)subviews[2];//个人页面
        UIImageView *helpImageView =(UIImageView *)subviews[0];//个人页面
        
        CGFloat scrollRate = 0.0;//横向滚动率
        CGFloat naviAlpha = 0.0;//当前home透明度
        CGFloat offsetHomeY = homeVC.tableview.contentOffset.y;//用来判断首页当前的导航栏是否显示
        CGFloat alpha =  offsetHomeY /(homeVC.headerView.searchBtnView.maxY - KNavigationBarHeight);//home页导航栏透明度
        alpha = MIN(alpha, 1);
        
        if(scrollView.contentOffset.x>KDeviceW)//即页面将要滑到个人页
        {
            scrollRate = (2*KDeviceW-scrollView.contentOffset.x)/KDeviceW;
            naviAlpha = alpha*scrollRate;
            if(!weakSelf.isUserWillShow)
            {
//                [userCenter viewWillAppear:YES];
                weakSelf.isUserWillShow = YES;
                [MobClick event:@"Home19"];//首页－个人按钮点击数
                [[BaiduMobStat defaultStat] logEvent:@"Home19" eventLabel:@"首页－个人按钮点击数"];
            }
            homeVC.naviSearchView.hidden = YES;//在个人页不管什么情况都隐藏搜索框
            
        }else if(scrollView.contentOffset.x<KDeviceW){
            scrollRate = scrollView.contentOffset.x/KDeviceW;
            naviAlpha = alpha*scrollRate;
            if(!weakSelf.isHelepWillShow)
            {
//                [helpVC viewWillAppear:YES];
                weakSelf.isHelepWillShow = YES;
                [MobClick event:@"Home18"];//首页－帮助按钮点击数
                [[BaiduMobStat defaultStat] logEvent:@"Home18" eventLabel:@"首页－帮助按钮点击数"];
            }
            homeVC.naviSearchView.hidden = YES;//在帮助页不管什么情况都隐藏搜索框
        }else{

            naviAlpha = alpha;
            scrollRate = 1;
            weakSelf.isUserWillShow = NO;
            weakSelf.isHelepWillShow = NO;
            if (offsetHomeY > 0) {
                if (alpha ==  1) {
                    homeVC.naviSearchView.hidden = NO;
                }else
                {
                    homeVC.naviSearchView.hidden = YES;
                }
            }else
            {
                homeVC.naviSearchView.hidden = YES;
            }

        }

        meImageView.alpha =  scrollRate;
        helpImageView.alpha =  scrollRate;
        homeSearchImageView.alpha = 1 - scrollRate;
        [homeVC.navigationController.navigationBar fs_setBackgroundColor:[KHexRGB(0x3c82fc) colorWithAlphaComponent:naviAlpha]];
    };
    BasicNavigationController *nav = [[BasicNavigationController alloc] initWithRootViewController:_pageViewController];
    [self.window setRootViewController:nav];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}

#pragma mark - 设置useagent
-(void)setUseAgent
{
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newUagent = [NSString stringWithFormat:@"%@ device/iOSInquireClient(v%@)",secretAgent,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSLog(@"%@",newUagent);
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:newUagent, @"UserAgent", nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    webView = nil;
}

#pragma mark - shareSDK
-(void)registerShareSDK
{
    /*
     需要 微信、微信朋友圈、微博
     只需配置此三种完事
     如果需要更多，另配置
     */
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ)
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:WeiBo_Appkey
                                           appSecret:WeiBo_AppSecret
                                         redirectUri:WeiBo_RedirectUri
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WeiXin_AppId
                                       appSecret:WeiXin_AppSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:QQ_AppId
                                      appKey:QQ_Appkey
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
}

#pragma mark -  友盟设置
-(void)setUmeng
{
    UMConfigInstance.appKey = UMOB_Appkey;
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.eSType = E_UM_NORMAL;
    [MobClick startWithConfigure:UMConfigInstance];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
}


#pragma mark - 百度统计
- (void)setBaiduTJ{
    BaiduMobStat *stat = [BaiduMobStat defaultStat];
    //    stat.enableDebugOn = YES;
    [stat startWithAppId:BaiDuTJ_AppKey];
}

#pragma mark - 自动隐藏键盘的第三方类库
-(void)setIQKeyboardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    manager.shouldShowTextFieldPlaceholder = NO;
}

//-(void)startRequest
//{
//    DownTaskController *vc = [[DownTaskController alloc]init];
//    [vc startRequest];
//}


#pragma mark - 开启定位
-(void)startLocation
{
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BaiDu_Appkey generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }else
    {
        NSLog(@"manager start success");
    }
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    
}


- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;//位置坐标
    
    [_locService stopUserLocationService];
    
    [self createLocation:coordinate];
}

//根据当前位置，获取当前所得的省，市，区。即地理反编码
-(void)createLocation:(CLLocationCoordinate2D)userCoordinate
{
    if (!_rsearch) {
        _rsearch = [[BMKGeoCodeSearch alloc] init];
        _rsearch.delegate = self;
    }
    BMKReverseGeoCodeOption  *rever = [[BMKReverseGeoCodeOption alloc]init];
    rever.reverseGeoPoint = userCoordinate;
    BOOL isFlag =  [_rsearch reverseGeoCode:rever];
    if (isFlag) {
        NSLog(@"逆编码发起成功");
    }else
    {
        NSLog(@"逆编码发起失败");
        // [self createLocation:userCoordinate];
    }
}


-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (result.addressDetail.province &&![result.addressDetail.province isEqualToString:@""]) {
        NSString  *province = [result.addressDetail.province substringToIndex:2];
        NSString  *city = result.addressDetail.city;
        NSString  *district = result.addressDetail.district;
        
        NSDictionary *dic = @{@"province":[NSString stringWithFormat:@"%@",province],@"city":[NSString stringWithFormat:@"%@",city],@"district":[NSString stringWithFormat:@"%@",district]};
        [KUserDefaults setObject:dic forKey:KUserLocation];
        [KUserDefaults synchronize];
        
        KNear.province = province;
        KNear.city = city;
        KNear.district = district;
    }
}



-(void)autologin
{
    
    NSArray *array = [User findAll];
    if(array.count>0)
    {
        User *user ;
        user = [array objectAtIndex:0];
        NSLog(@"%@",USER.userID);
    }
    
}

/** 注册APNS */
- (void)registerRemoteNotification {
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationType types = (UIUserNotificationTypeAlert |
                                        UIUserNotificationTypeSound |
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                   UIRemoteNotificationTypeSound |
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    deviceTokenString = [[[[deviceToken description]
                           stringByReplacingOccurrencesOfString: @"<" withString: @""]
                          stringByReplacingOccurrencesOfString: @">" withString: @""]
                         stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"%@",deviceTokenString);
    [self sendDeviceToken];
    
}

-(void)sendDeviceToken
{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [KUserDefaults setObject:deviceTokenString forKey:KPushID];
    [dataDic setObject:deviceTokenString forKey:@"pushid"];
    [dataDic setObject:USER.userID forKey:@"userid"];
    [dataDic setObject: [UIDevice currentDevice].identifierForVendor.UUIDString forKey:@"deveiceid"];
    
    [RequestManager postWithURLString:SendPush parameters:dataDic success:^(id responseObject) {
        //        NSLog(@"%@",responseObject);
        
    } failure:^(NSError *error) {
        //        NSLog(@"%@",error.description);
        
    }];
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KUNREADMSG object:nil];
    
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    
    if (isAppActivity){
        NSLog(@"userInfo===%@",userInfo);
        if (userInfo) {
            
            
            [Tools showNavigaitonBarMessage:userInfo tapBlock:^(NSDictionary *messageDic) {
                NSString *type =[NSString stringWithFormat:@"%@",userInfo[@"c"]];
                NSLog(@"=======S=S=SS=S=S=S=S==%@",messageDic);
                
                if ([type isEqual: @"1"]) {//进详情页
                    
                    CompanyDetailController *comView = [[CompanyDetailController alloc]init];
                    comView.companyId = userInfo[@"d"];
                    comView.companyName = @"";
                    [self toPushDetail:comView];
                }else if ([type isEqual:@"2"]){//H5页面
                    
                    CommonWebViewController *probelemView = [[CommonWebViewController alloc]init];
                    probelemView.titleStr = userInfo[@"a"];
                    probelemView.urlStr = userInfo[@"e"];
                    [self toPushDetail:probelemView];
                }
                
                else if ([type isEqual:@"4"])//进消息列表页
                {
                    NSString *str = USER.userID;
                    if(str.length > 0)//
                    {
                        OwnerMessageVC *message = [OwnerMessageVC new];
                        [self toPushDetail:message];
                    }
                }
                
                
            }];
            
        }
        
    }else{
        if (userInfo) {
            if (userInfo[@"c"]) {
                
                NSString *type =[NSString stringWithFormat:@"%@",userInfo[@"c"]];
                if ([type isEqual: @"1"]) {//进详情页
                    
                    //                    [KUserDefaults setObject:@"0" forKey:KUNREADMSG];
                    //                    [KUserDefaults synchronize];
                    CompanyDetailController *comView = [[CompanyDetailController alloc]init];
                    comView.companyId = userInfo[@"d"];
                    comView.companyName = @"";
                    [self toPushDetail:comView];
                }else if ([type isEqual:@"2"]){//H5页面
                    
                    //                    [KUserDefaults setObject:@"0" forKey:KUNREADMSG];
                    //                    [KUserDefaults synchronize];
                    CommonWebViewController *probelemView = [[CommonWebViewController alloc]init];
                    probelemView.titleStr = userInfo[@"a"];
                    probelemView.urlStr = userInfo[@"e"];
                    [self toPushDetail:probelemView];
                }
                
                else if ([type isEqual:@"4"])//进消息列表页
                {
                    //                    [KUserDefaults setObject:@"0" forKey:KUNREADMSG];
                    //                    [KUserDefaults synchronize];
                    NSString *str = USER.userID;
                    if(str.length > 0)//
                    {
                        OwnerMessageVC *message = [OwnerMessageVC new];
                        [self toPushDetail:message];
                    }
                }
                
            }
            
            
            
        }
        
    }
}

-(void)setReachbility
{
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];
}


- (void)toPushDetail:(UIViewController *)detailVC
{
    UIViewController *vc = [self getCurrentRootViewController];
    UINavigationController *navs;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        navs = (UINavigationController *)vc;
        
        if (navs.visibleViewController.navigationController) {
            [navs.visibleViewController.navigationController pushViewController:detailVC animated:YES];
        }
    }
    else if ([vc isKindOfClass:[UITabBarController class]]){
        UITabBarController *tab = (UITabBarController *)vc;
        navs = (UINavigationController *)tab.selectedViewController;
        
        if (navs.visibleViewController.navigationController) {
            [navs.visibleViewController.navigationController pushViewController:detailVC animated:YES];
        }
    }
    else{
        navs = vc.navigationController;
        
        if (navs.visibleViewController.navigationController) {
            [navs.visibleViewController.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

- (UIViewController *)getCurrentRootViewController {
    
    UIViewController *result;
    // Try to find the root view controller programmically
    // Find the top window (that is not an alert view or other window)
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    
    id nextResponder = [rootView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        
        result = nextResponder;
    
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        
        result = topWindow.rootViewController;
    
    else
        
        NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    
    return result;
}




#pragma mark - 微信，支付宝支付回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"]) {
        KWeakSelf
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {//支付宝回调
            NSLog(@"result = %@",resultDic);
            [weakSelf postPayDoneNotification:resultDic];
        }];
        return YES;
    }else{
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        KWeakSelf
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [weakSelf postPayDoneNotification:resultDic];
        }];
        return YES;
    }else{
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
}
//ios9.0以后
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options{
    if ([url.host isEqualToString:@"safepay"]) {
        KWeakSelf
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [weakSelf postPayDoneNotification:resultDic];
        }];
        return YES;
    }else{
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
}

- (void)postPayDoneNotification:(NSDictionary *)resultDic{
    BOOL result = [resultDic[@"resultStatus"] intValue]==9000?YES:NO;//0表示成功，1表示失败
    NSDictionary *dic=@{@"result":@(result)};
    [KNotificationCenter postNotificationName:PAY_DONE_NOTI object:nil userInfo:dic];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //    NSLog(@"程序进入前台");
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [KUserDefaults setObject:nil forKey:ChooseArray];
}

@end

