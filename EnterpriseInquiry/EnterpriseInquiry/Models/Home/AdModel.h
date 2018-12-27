//
//  AdModel.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/11.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdModel : NSObject

@property (nonatomic,strong) NSString *Id;
@property (nonatomic,strong) NSString *ImgUrl;//图片链接
@property (nonatomic,strong) NSString *ReUrl;//详情页面
@property (nonatomic,strong) NSString *Title;//分享标题
@property (nonatomic,strong) NSString *Deal;//状态 1：表示正常 0：表示删除
@property (nonatomic,strong) NSString *Describe;//分享内容

@end
