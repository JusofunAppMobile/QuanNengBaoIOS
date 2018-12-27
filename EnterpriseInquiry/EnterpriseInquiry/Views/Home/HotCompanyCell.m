//
//  HotCompanyCell.m
//  EnterpriseInquiry
//
//  Created by clj on 16/8/13.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "HotCompanyCell.h"

@implementation HotCompanyCell

-(UILabel *)companyLabel
{
    if (_companyLabel == nil) {
        _companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, KDeviceW  - 80, 16)];
        _companyLabel.textColor = KHexRGB(0xFF772E);
        _companyLabel.font = [UIFont fontWithName:FontName size:16];
    }
    return  _companyLabel;
}

-(UILabel *)detailLabel
{
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_companyLabel.frame) + 9, KDeviceW - 80, 12)];
        _detailLabel.textColor = KHexRGB(0x999999);
        _detailLabel.font = [UIFont fontWithName:FontName size:12];
    }
    return _detailLabel;
}

-(UILabel *)foucsCountLabel
{
    if (_foucsCountLabel == nil) {
        _foucsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 46, 20)];
        _foucsCountLabel.textColor = KHexRGB(0x666666);
        _foucsCountLabel.font = [UIFont fontWithName:FontName size:12];
        _foucsCountLabel.center = CGPointMake(KDeviceW - 40, 67/2);
        _foucsCountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _foucsCountLabel;
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:[self companyLabel]];
        [self.contentView addSubview:[self detailLabel]];
        [self.contentView addSubview:[self foucsCountLabel]];
    }
    return self;
}

-(void)setCellDataWithModel:(CompanyModel *)companyModel
{
    _companyLabel.text = [NSString stringWithFormat:@"%@",companyModel.companyname];
    
    NSString *companyIndustry = companyModel.industry;
    if (companyIndustry.length == 0 || [companyIndustry isEqualToString:@"null"]||[companyIndustry isEqualToString:@"<null>"]) {
        companyIndustry = @"未公布";
    }
    NSString *companyLocation = companyModel.location;
    if (companyLocation.length == 0 || [companyLocation isEqualToString:@"null"]||[companyLocation isEqualToString:@"<null>"]) {
        companyLocation = @"未公布";
    }
    
    NSString *companyFunds = companyModel.funds;
    if (companyFunds.length == 0 || [companyFunds isEqualToString:@"null"]||[companyFunds isEqualToString:@"<null>"]) {
        companyFunds = @"未公布";
    }

    _detailLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",companyIndustry,companyLocation,companyFunds];
    _foucsCountLabel.text = [NSString stringWithFormat:@"%@关注",companyModel.attentioncount];
}

@end
