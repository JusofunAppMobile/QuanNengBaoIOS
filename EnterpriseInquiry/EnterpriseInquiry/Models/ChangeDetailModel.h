//
//  ChangeDetailModel.h
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/11/1.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangeDetailModel : NSObject

//公司名称
@property (nonatomic ,copy) NSString *ename;
//变更前
@property (nonatomic ,copy) NSString *changeBefore;
//变更后
@property (nonatomic ,copy) NSString *changeAfter;

//<-----------------股东--------------------->
@property (nonatomic ,copy) NSString *beforeValue;

@property (nonatomic ,copy) NSString *afterValue;

@property (nonatomic ,copy) NSString *beforetype;

@property (nonatomic ,copy) NSString *afterType;
//<-----------------股东--------------------->

@property (nonatomic ,copy) NSString *Id;

@property (nonatomic ,copy) NSString *areaId;

@property (nonatomic ,copy) NSString *businessLicenseId;

@property (nonatomic ,copy) NSString *changeItem;

@property (nonatomic ,copy) NSString *changeDate;

@property (nonatomic ,copy) NSString *createDate;

@property (nonatomic ,copy) NSString *updateDate;

@property (nonatomic ,copy) NSString *emptyRatio;

@property (nonatomic ,copy) NSString *dataStatus;



@end
