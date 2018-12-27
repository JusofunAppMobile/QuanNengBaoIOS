//
//  RegisteredViewController.h
//  EnterpriseInquiry
//
//  Created by Ching on 15/11/18.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "BasicViewController.h"
@protocol RegisteredViewControllerDelegate <NSObject>
@required
- (void)ValidationSuccess:(NSString *)phoneNum;
@end

@interface RegisteredViewController : BasicViewController
@property (nonatomic, weak) id<RegisteredViewControllerDelegate> delegate;

- (void)bindingPhoneNumber:(BOOL)isBeding;
- (void)giveDelegate:(id<RegisteredViewControllerDelegate>)delegate;
@end
