//
//  RecoveryErrorViewController.h
//  EnterpriseInquiry
//
//  Created by clj on 15/11/13.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "BasicViewController.h"
#import "ItemModel.h"
@interface RecoveryErrorViewController : BasicViewController


@property (nonatomic,strong) NSArray *squearList;

@property (nonatomic,strong) ItemModel *currentSquareModel;

@property (nonatomic,strong) NSString *companyId;

@property (nonatomic,strong) NSString *companyName;

@end
