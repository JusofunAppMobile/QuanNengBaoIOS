//
//  QuestionModel.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/11.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>
//问卷调查 、工资查询模型
@interface QuestionModel : NSObject

@property (nonatomic,strong) NSString *isshow;
@property (nonatomic,strong) NSString *title;//标题
@property (nonatomic,strong) NSString *imageurl;//图片链接
@property (nonatomic,strong) NSString *content;//内容
@property (nonatomic,strong) NSString *htmlurl;//跳转的具体html页面
@property (nonatomic,strong) NSString *cancle;//取消按钮文字
@property (nonatomic,strong) NSString *join;//确定按钮文字
@property (nonatomic,strong) NSString *id;
@end
