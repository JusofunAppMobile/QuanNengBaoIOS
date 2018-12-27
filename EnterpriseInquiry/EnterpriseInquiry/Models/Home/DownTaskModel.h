//
//  DownTaskModel.h
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/7/31.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JKDBModel.h>
typedef NS_ENUM(NSInteger,TaskType) {
    TaskGetSucces,          //请求任务成功
    TaskGetFail,            //请求任务失败
    TaskRequestSucces,      //任务请求数据成功
    TaskRequestFail,        //任务请求数据失败
    TaskUploadSucces,       //将数据上传成功
    TaskUploadFail          //将数据上传失败
};

@interface DownTaskModel : JKDBModel

/**
 启动任务时间
 */
@property (nonatomic,copy)NSString *t;


/**
 企业请求链接
 */
@property (nonatomic,copy)NSString *u;


/**
 下载状态
 */
@property (nonatomic,assign)TaskType taskType;

@property(nonatomic,strong)NSDate * getDate;




/**
 请求数量 大于两次不请求了
 */
@property(nonatomic,assign)int requestFailCount;

/**
 请求数量 大于5次不请求了
 */
@property(nonatomic,assign)int uploadFailCount;



@end
