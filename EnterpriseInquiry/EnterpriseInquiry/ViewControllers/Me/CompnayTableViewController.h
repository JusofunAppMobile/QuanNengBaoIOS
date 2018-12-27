//
//  CompnayTableViewController.h
//  EnterpriseInquiry
//
//  Created by Ching on 15/11/20.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "TTUITableViewZoomController.h"
#import "BaseCell.h"

//#import "EnterpriseInquiry-Swift.h"
@protocol CompnayTableViewControllerDelegate <NSObject>

@optional
- (void)TextFieldresignFirstResponder;
- (void)changComSelect:(NSDictionary *)compModel andCompanyName:(NSString *)companyName;
//- (void)changPosition:(Position_Message *)postModel;
@end


@interface CompnayTableViewController : TTUITableViewZoomController
@property (nonatomic) BOOL refreshing;
@property (nonatomic, weak) id<CompnayTableViewControllerDelegate> delegate;
@property (nonatomic, strong)NSMutableArray *modelArr;
@property (nonatomic, strong)NSString *modelType;
- (void)giveDelegate:(id<CompnayTableViewControllerDelegate>)delegate;
@end
