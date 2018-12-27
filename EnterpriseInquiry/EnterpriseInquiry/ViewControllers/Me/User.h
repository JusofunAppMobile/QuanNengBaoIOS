//
//  User.h
//  EnterpriseInquiry
//
//  Created by LEZ on 16/8/12.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <JKDBModel.h>

#define USER [User sharedUser]

typedef enum : NSInteger{

    WeChatLogin = 1,
    WeiboLogin = 4,

}OtherLoginType;

@interface User : JKDBModel

SingletonH(User);


////手机号登录
//+ (void)loginWithAccount:(NSString*)account
//                  accpwd:(NSString *)pwd
//                    type:(NSString*)type
//               superview:(UIView*)superView;
//
////第三方登录
//
//+(void)otherLogin:(OtherLoginType)type
//     PlatformType:(SSDKPlatformType)PlatformType;
//
//+ (void)otherLoginWithAccount:(NSString*)account
//                       accpwd:(NSString *)pwd
//                         type:(NSString*)type
//                   thirdToken:(NSString*)thirdToken
//                     nickname:(NSString*)nickname
//                        photo:(NSString*)photo
//                      unionid:(NSString*)unionid
//                    superview:(UIView*)superView;
//
//-(void)gotUserinfo;
//
//-(void)giveUserInfo:(NSDictionary*)userInfo;
//
//-(void)logout;

@property(nonatomic,assign)BOOL isUserLogin;

///用户userid
@property(nonatomic,copy)NSString *userID;
///电话
@property(nonatomic,copy)NSString *mobile;
///昵称
@property(nonatomic,copy)NSString *nickname;
///头像
@property(nonatomic,copy)NSString *photo;
///公司
@property(nonatomic,copy)NSString *company;
///职位
@property(nonatomic,copy)NSString *job;
///职位id
@property(nonatomic,copy)NSString *jobID;
///关注未读
@property(nonatomic,copy)NSString *focuseUnread;
///消息未读
@property(nonatomic,copy)NSString *messageUnread;
///性别
@property(nonatomic,copy)NSString *sex;
///公司id
@property(nonatomic,copy)NSString *companyid;
///关注数目
@property(nonatomic,copy)NSString *myfocuscount;

///系统消息未读数量
@property(nonatomic,copy)NSString *systemmessageunread;

@property(nonatomic,assign)BOOL issetpwd;




@property (nonatomic ,copy) NSString *vipType;



@end
