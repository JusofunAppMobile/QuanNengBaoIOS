//
//  LoginController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/4.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import <IQKeyboardManager.h>
#import "ForgetPasswordViewController.h"
#import "RegisteredViewController.h"
#import "AnimateLine.h"
typedef void(^LoginSuccessBlock)();

@interface LoginController : BasicViewController<UITextFieldDelegate>


//-(void)beginAnimationWithIsUp:(BOOL)isUp;

@property(nonatomic,copy)LoginSuccessBlock loginSuccessBlock;

@end
