//
//  IndustryAndArea.h
//  JuXin
//
//  Created by huang on 15/4/11.
//  Copyright (c) 2015年 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IndustryAndArea : NSManagedObject

//子集ID
@property (nonatomic, retain) NSString * childid;
//是否有子集
@property (nonatomic, retain) NSNumber * haschild;
//当前级别
@property (nonatomic, retain) NSNumber * level;
//行业名或者地区名
@property (nonatomic, retain) NSString * name;
//父级ID
@property (nonatomic, retain) NSString * parentid;
//类型 1：行业   2：地区
@property (nonatomic, retain) NSNumber * type;

@end
