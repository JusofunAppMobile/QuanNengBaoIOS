//
//  ModifyCompanyViewController.h
//  EnterpriseInquiry
//
//  Created by Ching on 15/11/18.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "BasicViewController.h"
@protocol ModifyCompanyViewControllerDelegate <NSObject>

@required
- (void)ChoiceCompanyName:(NSString *)comName JobId:(NSString *)jobId;
@end



@interface ModifyCompanyViewController : BasicViewController 
@property (nonatomic, weak) id<ModifyCompanyViewControllerDelegate> delegate;
@property (nonatomic, strong)NSString *modifyName;
- (NSString *)getSelectCompanyName;
- (void)giveDelegate:(id<ModifyCompanyViewControllerDelegate>)delegate;
@end
