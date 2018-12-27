//
//  SearchCell.m
//  EnterpriseInquiry
//
//  Created by 方首滔 on 16/8/10.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       [self SetUplayout];
    }
    return self;
}



-(void)setCompanyInfoModel:(CompanyInfoModel *)CompanyInfoModel{
    _CompanyInfoModel = CompanyInfoModel;
   
    
    NSString *industry = CompanyInfoModel.industry;
    NSString *location = CompanyInfoModel.location;
    NSString *funds = CompanyInfoModel.funds;
    if (industry.length == 0 || [industry isEqualToString:@"null"] || [industry isEqualToString:@"<null>"] || [industry isEqualToString:@""]) {
        industry = @"未知";
    }else if (location.length == 0 || [location isEqualToString:@"null"] || [location isEqualToString:@"<null>"] || [location isEqualToString:@""]||[location isEqualToString:@"未公布"]){
         location = @"";
    }else if(funds.length == 0 || [funds isEqualToString:@"null"] || [funds isEqualToString:@"<null>"] || [funds isEqualToString:@""]){
        funds = @"未知";
    }

    if(location.length>0)
    {
        self.CompanyInfo.text = [NSString stringWithFormat:@"%@ | %@",location,funds];
    }
    else
    {
        self.CompanyInfo.text = [NSString stringWithFormat:@"%@",funds];
    }
    
   
    
    self.CompanyStatusLabel.text = CompanyInfoModel.companystate;
    [self.CompanyStatusLabel sizeToFit];
    
    NSString *creditStr = CompanyInfoModel.socialcredit;
    
    if (creditStr.length == 0 || [creditStr isEqualToString:@"null"] || [creditStr isEqualToString:@"<null>"] || [creditStr isEqualToString:@""]) {
        creditStr = @"";
    }
    
    self.creditLabel.text = [NSString stringWithFormat:@"统一社会信用代码/注册号: %@",creditStr];
    
    self.CompanyName.frame = CGRectMake(15, 15, KDeviceW - 30 , 17 );

    CGFloat infoWidth = [Tools getWidthWithString:self.CompanyInfo.text fontSize:12 maxHeight:15];
    
    self.CompanyInfo.frame = CGRectMake(15, CGRectGetMaxY(self.CompanyName.frame) + 10, infoWidth + 20, 15);
    
    self.CompanyStatusLabel.frame = KFrame(self.CompanyInfo.maxX, self.CompanyInfo.y, KDeviceW - 30 - self.CompanyInfo.width, 15);
    
    self.creditLabel.frame = KFrame(15, self.CompanyInfo.maxY + 5, KDeviceW - 30, 15);
    
    if (CompanyInfoModel.companylightname.length>0) {
        self.CompanyName.attributedText = [Tools titleNameWithTitle:CompanyInfoModel.companylightname otherColor:[UIColor blackColor]];
        self.CompanyName.lineBreakMode = NSLineBreakByTruncatingTail;
    }else{
        self.CompanyName.text  = CompanyInfoModel.companyname;
    }


    if(!self.isSearchCompany)
    {
        _kongView.hidden = NO;
        NSString *relatedStr = CompanyInfoModel.related;
        if(relatedStr.length >0)
        {
             _keyView.hidden = NO;
            _kongView.frame = KFrame(0,  20+107-10, KDeviceW, 10);
        }
        else
        {
            _keyView.hidden = YES;
            _kongView.frame = KFrame(0, 20+70, KDeviceW, 10);
        }

        _keyLable.attributedText = [Tools titleNameWithTitle:CompanyInfoModel.related otherColor:KRGB(154, 155, 156)];
       
    }

    
    
    
}
-(void)SetUplayout{
    
    [self.contentView addSubview:self.CompanyName];
    [self.contentView addSubview:self.CompanyInfo];
    [self.contentView addSubview:self.CompanyStatusLabel];
   
    [self.contentView addSubview:self.creditLabel];
    [self.contentView addSubview:self.keyView];
    [self.contentView addSubview:self.kongView];
    

}

-(UIView *)kongView
{
    if(!_kongView)
    {
        _kongView = [[UIView alloc]initWithFrame:KFrame(0, 70, KDeviceW, 10)];
        _kongView.backgroundColor = KRGB(235, 235, 235);
        _kongView.hidden = YES;
    }
    
    return _kongView;
}


-(UILabel *)CompanyName{
    
    if (_CompanyName == nil) {
        _CompanyName = [[UILabel alloc]init];
        _CompanyName.frame = CGRectMake(15, 15, KDeviceW -30 , 17 );
        _CompanyName.textColor = KHexRGB(0xff772e);
        _CompanyName.font = KNormalFont;
        
    }
    return _CompanyName;
}

-(UILabel *)CompanyInfo{
    if (_CompanyInfo == nil) {
        _CompanyInfo = [[UILabel alloc]init];
        _CompanyInfo.textColor = KHexRGB(0x999999);
        _CompanyInfo.font = [UIFont fontWithName:@"Arial" size:12.0f];
        _CompanyInfo.frame = CGRectMake(15, CGRectGetMaxY(self.CompanyName.frame) + 10, self.CompanyName.frame.size.width, 15);
    }
    
    return _CompanyInfo;
}

-(UIButton *)CompanyStatus{
    if(_CompanyStatus == nil)
        _CompanyStatus = [[UIButton alloc]init];
    [_CompanyStatus.layer setMasksToBounds:YES];
    [_CompanyStatus.layer setCornerRadius:2];
    [_CompanyStatus.layer setBorderWidth:1];
    [_CompanyStatus.layer setBorderColor:KHexRGB(0xfbdfba).CGColor];
    [_CompanyStatus setTitleColor:KHexRGB(0xf1991b) forState:UIControlStateNormal];
    [_CompanyStatus setTitleColor:KHexRGB(0x979797) forState:UIControlStateSelected];
    _CompanyStatus.titleLabel.font = [UIFont fontWithName:FontName size:12];
    
    [_CompanyStatus.layer setBorderWidth:0.8];

    return _CompanyStatus;
}

-(UILabel *)CompanyStatusLabel{
    if (_CompanyStatusLabel == nil) {
        
        _CompanyStatusLabel = [[UILabel alloc]init];
        _CompanyStatusLabel.font = KMinFont;
        //_CompanyStatusLabel.textAlignment =  NSTextAlignmentRight;
        _CompanyStatusLabel.frame = CGRectMake(KDeviceW - 100, 0, 100, 20);
    }
    
    return _CompanyStatusLabel;
}

-(UIView *)keyView
{
    if(!_keyView)
    {
        _keyView = [[UIView alloc]initWithFrame:KFrame(0, _creditLabel.maxY +10, KDeviceW, 30)];
        _keyView.backgroundColor = KRGB(245, 245, 245);
        _keyView.hidden = YES;
        
        UIImageView *focuImageView = [[UIImageView alloc]initWithFrame:KFrame(15, 8, 14, 14)];
        focuImageView.image = KImageName(@"focu");
        [_keyView addSubview:focuImageView];
        
        [_keyView addSubview:self.keyLable];
        
    }

    return _keyView;
}


-(UILabel *)keyLable
{
    if(!_keyLable)
    {
        _keyLable = [[UILabel alloc]initWithFrame:KFrame(35, 0, KDeviceW - 35 - 10, 30)];
        _keyLable.font = KFont(14);
    }
    
    return _keyLable;
}



-(UILabel *)creditLabel
{
    if(!_creditLabel)
    {
        _creditLabel = [[UILabel alloc]init];
        _creditLabel.font = KMinFont;
        _creditLabel.textColor = KHexRGB(0x999999);
        _creditLabel.textAlignment =  NSTextAlignmentLeft;
        _creditLabel.frame = CGRectMake(15, CGRectGetMaxY(self.CompanyInfo.frame) + 5, 100, 15);
        _creditLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
    }
    
    return _creditLabel;
}











- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
