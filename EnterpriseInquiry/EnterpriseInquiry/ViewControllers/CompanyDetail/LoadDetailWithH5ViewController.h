//
//  LoadDetailWithH5ViewController.h
//  EnterpriseInquiry
//
//  Created by clj on 15/11/16.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "BasicWebViewController.h"
#import "BasicViewController.h"
#import "CompanyMap.h"
#import "CompanyMapModel.h"
#import "CompanyMapController.h"
#import "UINavigationBar+Extention.h"
#import "ItemModel.h"
#import "DLPanableWebView.h"
#import "BranchOrInvesmentModel.h"
#import "CompanyDetailController.h"
#import "RecoveryErrorViewController.h"

@interface LoadDetailWithH5ViewController : BasicWebViewController<CompanyDelegate>

/**
 *  企业id
 */
@property(nonatomic,strong)NSString *companyId;
@property(nonatomic,strong) NSString *companyName;

@property (nonatomic,strong) NSString *titleLableName;
@property (nonatomic,strong) ItemModel *squareModel;//当前的模型
@property (nonatomic,strong) NSMutableArray *sqiareList;


@end
