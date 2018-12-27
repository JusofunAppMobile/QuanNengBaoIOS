//
//  CompanyDetailModel.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/8/12.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "CompanyDetailModel.h"

@implementation CompanyDetailModel


-(NSString *)companyid
{
    if(_companyid.length == 0||[_companyid isEqualToString:@"null"]||[_companyid isEqualToString:@"NULL"]||[_companyid isEqualToString:@"<null>"]||[_companyid isEqualToString:@"-"])
    {
        return @"";
    }
    else
    {
        return _companyid;
    }

}


-(NSString *)companyname
{
    if(_companyname.length == 0||[_companyname isEqualToString:@"null"]||[_companyname isEqualToString:@"NULL"]||[_companyname isEqualToString:@"<null>"]||[_companyname isEqualToString:@"-"])
    {
        return @"未公布";
    }
    else
    {
        return _companyname;
    }
}



-(NSString *)companynature
{
    if(_companynature.length == 0||[_companynature isEqualToString:@"null"]||[_companynature isEqualToString:@"NULL"]||[_companynature isEqualToString:@"<null>"]||[_companynature isEqualToString:@"-"]||[_companynature isEqualToString:@"未公布"])
    {
        return @"";
    }
    else
    {
        return _companynature;
    }
}





-(NSString *)corporate
{
    if(_corporate.length == 0||[_corporate isEqualToString:@"null"]||[_companyname isEqualToString:@"NULL"]||[_corporate isEqualToString:@"<null>"]||[_corporate isEqualToString:@"-"])
    {
        return @"未公布";
    }
    else
    {
        return _corporate;
    }
}



-(NSString *)registercapital
{
    if(_registercapital.length == 0||[_registercapital isEqualToString:@"null"]||[_registercapital isEqualToString:@"NULL"]||[_registercapital isEqualToString:@"<null>"]||[_registercapital isEqualToString:@"-"])
    {
        return @"未公布";
    }
    else
    {
        return _registercapital;
    }
}



-(NSString *)companysize
{
    if(_companysize.length == 0||[_companysize isEqualToString:@"null"]||[_companyname isEqualToString:@"NULL"]||[_companysize isEqualToString:@"<null>"]||[_companysize isEqualToString:@"-"])
    {
        return @"未公布";
    }
    else
    {
        return _companysize;
    }
}

-(NSString *)cratedate
{
    if(_cratedate.length == 0||[_cratedate isEqualToString:@"null"]||[_cratedate isEqualToString:@"NULL"]||[_cratedate isEqualToString:@"<null>"]||[_cratedate isEqualToString:@"-"])
    {
        return @"未公布";
    }
    else
    {
        return _cratedate;
    }
}

-(NSString *)industry
{
    if(_industry.length == 0||[_industry isEqualToString:@"null"]||[_industry isEqualToString:@"NULL"]||[_industry isEqualToString:@"<null>"]||[_industry isEqualToString:@"-"])
    {
        return @"未公布";
    }
    else
    {
        return _industry;
    }
}


-(NSString *)address
{
    if(_address.length == 0||[_address isEqualToString:@"null"]||[_address isEqualToString:@"NULL"]||[_address isEqualToString:@"<null>"]||[_address isEqualToString:@"-"])
    {
        return @"未公布";
    }
    else
    {
        return _address;
    }
}
-(NSString *)states
{
    if(_states.length == 0||[_states isEqualToString:@"null"]||[_states isEqualToString:@"NULL"]||[_states isEqualToString:@"<null>"]||[_states isEqualToString:@"-"])
    {
        return @"未公布";
    }
    else
    {
        return _states;
    }

}

-(NSString *)result
{
    if(_result.length == 0||[_result isEqualToString:@"null"]||[_result isEqualToString:@"NULL"]||[_result isEqualToString:@"<null>"]||[_result isEqualToString:@"-"])
    {
        return @"";
    }
    else
    {
        return _states;
    }
    
}


-(NSString *)updatestate
{
    if(_updatestate.length == 0||[_updatestate isEqualToString:@"null"]||[_updatestate isEqualToString:@"NULL"]||[_updatestate isEqualToString:@"<null>"]||[_updatestate isEqualToString:@"-"])
    {
        return @"";
    }
    else
    {
        return _updatestate;
    }
    
}














@end
