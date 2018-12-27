//
//  NearSearchCondition.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/12/22.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "NearSearchCondition.h"

@implementation NearSearchCondition
SingletonM(Instance)

-(NSString *)searchKey
{
    if([Tools checkNull:_searchKey])
    {
        return @"";
    }
    else
    {
        return _searchKey;
    }
}

-(NSMutableArray *)chooseArray
{
    if(!_chooseArray)
    {
        return [NSMutableArray array];
    }
    else
    {
        return _chooseArray;
    }
    
}

-(NSMutableArray *)sxChooseArray
{
    if(!_sxChooseArray)
    {
        return [NSMutableArray array];;
    }
    else
    {
        return _sxChooseArray;
    }
}

@end
