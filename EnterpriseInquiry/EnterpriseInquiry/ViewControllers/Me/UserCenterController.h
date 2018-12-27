//
//  UserCenterController.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/4.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "BasicViewController.h"
#import "LoginController.h"
#import "MeController.h"
@interface UserCenterController : BasicViewController


@property(nonatomic,strong)LoginController *loginController;

@property(nonatomic,strong)MeController *meController;


@end
