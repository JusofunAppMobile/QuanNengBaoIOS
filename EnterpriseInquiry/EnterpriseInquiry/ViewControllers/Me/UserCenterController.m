//
//  UserCenterController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/4.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "UserCenterController.h"
#import "AppDelegate.h"
@interface UserCenterController ()<SLPagingDelegate>
{
    AppDelegate *appDelegate;
}

@end

@implementation UserCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar fs_setBackgroundColor:[UIColor clearColor]];
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.pageViewController.delegate = self;
    appDelegate.quitImageView.hidden = YES;
    [KNotificationCenter addObserver:self selector:@selector(loginSuccess) name:LOGIN_SUCCESS_NOTIFICATION object:nil];
    [KNotificationCenter addObserver:self selector:@selector(reloadUserInfo) name:KReloadUserInfo object:nil];
    
   // [KNotificationCenter addObserver:self selector:@selector(loginOutAnimateCompletion) name:KLoginOutAnimateCompletion object:nil];
    
    [self initControllers];
    
    
    [self changeViewController];
}

#pragma mark - 初始化控制器
- (void)initControllers{
    
    _loginController = [[LoginController alloc]init];
    
    _meController = [[MeController alloc]init];
    
}


-(void)changeViewController
{
    if(USER.userID.length == 0)
    {
        appDelegate.quitImageView.hidden = YES;
        [self displayViewController:_loginController];
       
    }
    else
    {
        if(USER.mobile.length == 0 && USER.nickname.length == 0)
        {
            [self rightBarItemClicked];
        }
        else
        {
            appDelegate.quitImageView.hidden = NO;
            [self displayViewController:_meController];
        }

    }

}

//刷新个人信息
-(void)reloadUserInfo
{
    [_meController reloadUserInfo];
}

-(void)loginOutAnimateCompletion
{
   
    [self changeViewController];
    
    //[_loginController beginAnimationWithIsUp:NO];
    
}

-(void)loginSuccess
{
    [self changeViewController];
   // [_meController beginAnimateIsUp:YES];
}

-(void)rightBarItemClicked
{
    USER.userID = @"";
    [User clearTable];
   // [_meController beginAnimateIsUp:NO];
    
    [self changeViewController];
}


- (void)displayViewController:(UIViewController *)controller {
    
    if (!controller) {
        return;
    }

    [self addChildViewController:controller];
    
    [self.view addSubview:controller.view];
    
    
    
    [controller didMoveToParentViewController:self];
}

- (void)hideViewController:(UIViewController *)controller {
    
    if (!controller) {
        return;
    }
    [controller willMoveToParentViewController:nil];
    
    [controller.view removeFromSuperview];
    
    [controller removeFromParentViewController];
}


@end
