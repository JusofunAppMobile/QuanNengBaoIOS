//
//  User.m
//  EnterpriseInquiry
//
//  Created by LEZ on 16/8/12.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "User.h"

@implementation User

SingletonM(User);


+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"userID" : @"userid",
             @"jobID" : @"jobid",
             @"focuseUnread" : @"myfocusunread",
             @"messageUnread" : @"systemmessageunread"
             };
}

-(void)gotUserinfo
{
    NSDictionary *dict = @{@"userid":[KUserDefaults objectForKey:@"useridDefaults"]};
    [RequestManager getWithURLString:GetUserInfo parameters:dict success:^(id responseObject) {
        
        NSDictionary *userinfo = responseObject[@"userinfo"];
        if ([responseObject[@"result"] integerValue] == 0) {
            NSLog(@"个人信息===%@",responseObject);
            [USER giveUserInfo:userinfo];
            [KNotificationCenter postNotificationName:UserinfoChangedNotification object:nil];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)loginWithAccount:(NSString*)account
                  accpwd:(NSString *)pwd
                    type:(NSString*)type
               superview:(UIView*)superView
{
    
    
    NSDictionary *dict = @{
                           @"phonenumber":account,
                           @"password":[Tools md5:pwd],
                           @"logintype":type,
                           };
    if (superView) {
        [MBProgressHUD showMessag:@"" toView:superView];
    }
    
    [RequestManager postWithURLString:LOGIN_POST parameters:dict success:^(id responseObject) {
        
        if (superView) {
            [MBProgressHUD hideHudToView:superView animated:NO];
        }
        
        NSDictionary *userInfo = responseObject[@"userinfo"];
        if ([responseObject[@"result"] integerValue] == 0) {
            
           
            [USER giveUserInfo:userInfo];
//            [USER gotUserinfo];
            [KUserDefaults setObject:pwd forKey:@"autologin_password"];
            [KUserDefaults setObject:account forKey:@"autologin_account"];
            [USER gotUserinfo];
            //登录成功 发送一下登录成功的通知
            [KNotificationCenter postNotificationName:LOGIN_SUCCESS_NOTIFICATION object:nil];
            
            
            
        }else{
            
            if (superView) {
                [MBProgressHUD showHint:responseObject[@"msg"] toView:superView];
            }
            
        }
        
    } failure:^(NSError *error) {
        if (superView) {
            [MBProgressHUD showHint:@"登录失败" toView:superView];
        }
        
    }];
    
}


-(void)giveUserInfo:(NSDictionary*)userInfo
{
    
    self.isUserLogin = YES;
    
    self.userID     = [NSString stringWithFormat:@"%@",userInfo[@"userid"]];
    self.mobile     = [NSString stringWithFormat:@"%@",userInfo[@"mobile"]];
    self.nickname   = [NSString stringWithFormat:@"%@",userInfo[@"nickname"]];
    self.photo      = [NSString stringWithFormat:@"%@",userInfo[@"photo"]];
    self.company    = [NSString stringWithFormat:@"%@",userInfo[@"company"]];
    self.job        = [NSString stringWithFormat:@"%@",userInfo[@"job"]];
    self.jobID      = [NSString stringWithFormat:@"%@",userInfo[@"jobid"]];
    self.focuseUnread = [NSString stringWithFormat:@"%@",userInfo[@"myfocusunread"]];
    self.messageUnread = [NSString stringWithFormat:@"%@",userInfo[@"systemmessageunread"]];
    self.sex        = [NSString stringWithFormat:@"%@",userInfo[@"sex"]];
    self.issetpwd = [userInfo[@"issetpwd"] boolValue];
    self.companyid = [NSString stringWithFormat:@"%@",userInfo[@"companyid"]];
    self.myfocuscount = [NSString stringWithFormat:@"%@",userInfo[@"myfocuscount"]];
    self.systemmessageunread = [NSString stringWithFormat:@"%@",userInfo[@"systemmessageunread"]];
    self.vipType = [NSString stringWithFormat:@"%@",userInfo[@"vipType"]];
    
}

+(void)otherLogin:(OtherLoginType)type
     PlatformType:(SSDKPlatformType)PlatformType
{
    
    [ShareSDK getUserInfo:PlatformType onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        if (state == SSDKResponseStateSuccess)
        {
            
            NSLog(@"uid=%@",user.uid);
            NSLog(@"%@",user.credential);
            NSLog(@"token=%@",user.credential.token);
            NSLog(@"nickname=%@",user.nickname);
            
            if (type == WeChatLogin) {
                
                NSDictionary *dic = user.rawData;
                [User otherLoginWithAccount:@""
                                     accpwd:@""
                                       type:@"1"
                                 thirdToken:user.uid
                                   nickname:user.nickname
                                      photo:user.icon
                                    unionid:dic[@"unionid"]
                                  superview:nil];
            }
            
            if (type == WeiboLogin){
                
                [User otherLoginWithAccount:@""
                                     accpwd:@""
                                       type:@"1"
                                 thirdToken:user.uid
                                   nickname:user.nickname
                                      photo:user.icon
                                    unionid:@""
                                  superview:nil];
            }
            
            
        }
        else
        {
            NSLog(@"%@",error);
        }
        
    }];
}

+ (void)otherLoginWithAccount:(NSString*)account
                       accpwd:(NSString *)pwd
                         type:(NSString*)type
                   thirdToken:(NSString*)thirdToken
                     nickname:(NSString*)nickname
                        photo:(NSString*)photo
                      unionid:(NSString*)unionid
                    superview:(UIView*)superView
{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    NSString *push_id = [KUserDefaults objectForKey:KPushID];
    [parameter setObject:@"" forKey:@"phonenumber"];
    [parameter setObject:@"" forKey:@"password"];
    [parameter setObject:thirdToken forKey:@"thirdtoken"];
    [parameter setObject:type forKey:@"logintype"];
    [parameter setObject:push_id?push_id:@"" forKey:@"pushid"];
    [parameter setObject:nickname forKey:@"nickname"];
    [parameter setObject:photo forKey:@"photo"];
    
    if ([type isEqualToString:@"1"]) {
        
        [parameter setObject:unionid forKey:@"unionid"];
        
    }else if ([type isEqualToString:@"4"]){
        
        [parameter setObject:@"" forKey:@"unionid"];
    }
    
    if (superView) {
        [MBProgressHUD showMessag:@"" toView:superView];
    }
    
    [RequestManager postWithURLString:LOGIN_POST parameters:parameter success:^(id responseObject) {
        
        if (superView) {
            [MBProgressHUD hideHudToView:superView animated:NO];
        }
        
        NSDictionary *userInfo = responseObject[@"userinfo"];
        if ([responseObject[@"result"] integerValue] == 0) {
            
           
            [USER giveUserInfo:userInfo];
            [USER gotUserinfo];
//            [USER gotUserinfo];
//            [KUserDefaults setObject:pwd forKey:@"autologin_password"];
//            [KUserDefaults setObject:account forKey:@"autologin_account"];
            [KUserDefaults setObject:parameter forKey:@"otherLoginUserinfo"];
            [KUserDefaults setObject:type forKey:@"otherLoginTye"];
            //登录成功 发送一下登录成功的通知
            [KNotificationCenter postNotificationName:LOGIN_SUCCESS_NOTIFICATION object:nil];
            
            
            
        }else{
            if (superView) {
                [MBProgressHUD showHint:responseObject[@"msg"] toView:superView];
            }
            
        }

        
    } failure:^(NSError *error) {
        
        if (superView) {
            [MBProgressHUD hideHudToView:superView animated:NO];
            [MBProgressHUD showHint:@"登录失败" toView:superView];
        }
        
    }];
    
}


-(void)logout
{
     [MobClick event:@"Me96"];//个人页－登出账号点击数
    [[BaiduMobStat defaultStat] logEvent:@"Me96" eventLabel:@"个人页－登出账号点击数"];
    //告知服务器一下
    NSDictionary *dict = @{@"userid":_userID};
    [RequestManager postWithURLString:LOGOUT_POST parameters:dict success:^(id responseObject) {} failure:^(NSError *error) {}];
    
    
    //清空用户信息
    self.isUserLogin = NO;
    
    self.userID     = @"";
    self.mobile     = @"";
    self.nickname   = @"";
    self.photo      = @"";
    self.company    = @"";
    self.job        = @"";
    self.jobID      = @"";
    self.focuseUnread = @"";
    self.messageUnread = @"";
    self.sex        = @"";
    self.issetpwd = NO;
    self.companyid = @"";
    self.myfocuscount = @"";
    
    [KNotificationCenter postNotificationName:LOGOUT_NOTIFICATION object:nil];
}



-(NSString *)userID
{
    if(_userID == nil)
    {
        return @"";
    }
    else
    {
        return _userID;
    }
}

-(NSString *)focuseUnread
{
    
    if(_focuseUnread == nil)
    {
        return @"0";
    }
    else
    {
        return _focuseUnread;
    }
}

-(NSString *)messageUnread
{
    
    if(_messageUnread == nil)
    {
        return @"0";
    }
    else
    {
        return _messageUnread;
    }
}


-(NSString *)photo
{
    if(!_photo)
    {
        return @"";
    }
    else
    {
        return _photo;
    }
}

-(NSString *)mobile
{
    if(!_mobile)
    {
        return @"";
    }
    else
    {
        return _mobile;
    }
}




@end
