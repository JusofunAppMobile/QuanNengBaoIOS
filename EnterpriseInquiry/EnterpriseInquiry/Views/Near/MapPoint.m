                                                                       //
//  MapPoint.m
//  jusfounData
//
//  Created by jusfoun on 15/7/23.
//  Copyright (c) 2015年 jusfoun. All rights reserved.
//

#import "MapPoint.h"
@implementation MapPoint

-(instancetype)initWithModel:(NearCompanyModel *)model
{
    self = [super init];
    if (self) {
        CLLocationCoordinate2D coor;
        coor.latitude = [model.mapLat floatValue];
        coor.longitude = [model.mapLng floatValue];
        self.coordinate = coor;
        self.title = model.name;
        
        self.tag = model.companyId;
        self.companyName = model.name;
    }
    return self;
}

//不是第四级时调用
- (instancetype)initWithDictary:(NSMutableDictionary *)dic andMapType:(NSInteger)mapType
{
    self = [super init];
    if (self) {
        CLLocationCoordinate2D coor;
        coor.latitude = [dic[@"lat"] floatValue];
        coor.longitude = [dic[@"lng"] floatValue];
        self.coordinate = coor;
        
        NSString *howmany = @"";
       
        if(![Verification validateNullOrEmpty:[NSString stringWithFormat:@"%@",dic[@"total"]]])
        {
            CGFloat tempTotal =[dic[@"total"] floatValue];
            if (tempTotal>10000) {
                howmany = [NSString stringWithFormat:@"(%.2f)万家",tempTotal/10000];
            }
            else
            {
                howmany = [NSString stringWithFormat:@"(%.0f)家",tempTotal];
            }
        }
        
        if(mapType == 3 || mapType == 2){
             self.title = [NSString stringWithFormat:@"%@%@",dic[@"area"],howmany];

        }else
        {
            self.title = [NSString stringWithFormat:@"%@%@",dic[@"area"],howmany];
        }
       
        self.mapType =  mapType;
        self.tag = @"2";
    }
    return self;
}


//第四级地图时调用
- (instancetype)initWithDictary:(NSMutableDictionary *)dic
{
    self = [super init];
    if (self)
    {
        
        CLLocationCoordinate2D coor;
        coor.latitude = [dic[@"lat"] doubleValue];
        coor.longitude = [dic[@"lng"] doubleValue];
        
        self.coordinate = coor;
        
        NSString *companyid = [NSString stringWithFormat:@"%@",dic[@"ent_id"]];
        if ([companyid isEqualToString:@"0"])
        {
            //有多家企业时
            self.title = [NSString stringWithFormat:@"(%@)家",dic[@"total"]];
            self.tag = @"1";
        }else
        {
            self.title = [NSString stringWithFormat:@"%@",dic[@"entname"]];
            self.tag = companyid;
        }
    }
    return self;
}



@end
