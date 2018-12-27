//
//  NearCompanyCell.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/12/27.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "NearCompanyCell.h"

@implementation NearCompanyCell




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *backView = [[UIView alloc]initWithFrame:KFrame(10, 10, KDeviceW - 20, 90)];
        backView.layer.borderColor = KRGB(243, 241, 239).CGColor;
        backView.layer.borderWidth = 1;
        backView.layer.cornerRadius = 5;
        backView.clipsToBounds = YES;
        backView.layer.shadowOpacity = 0.5;// 阴影透明度
        backView.layer.shadowColor = KRGB(243, 241, 239).CGColor;// 阴影的颜色
        backView.layer.shadowRadius = 3;// 阴影扩散的范围控制
        backView.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
        [self.contentView addSubview:backView];
        
        
        _nameLabel = [[UILabel alloc]initWithFrame:KFrame(15, 20, backView.width-30, 20)];
        _nameLabel.textColor = KRGB(51, 51, 51);
        _nameLabel.font = KBlodFont(16);
        _nameLabel.text = @"酒泉市公安局交警支队机动车专";
        //_nameLabel.numberOfLines = 0;
        [backView addSubview:_nameLabel];
        
        
        UIImageView *pointImageView = [[UIImageView alloc]initWithFrame:KFrame(_nameLabel.x, _nameLabel.maxY+15, 13, 16)];
        pointImageView.image = KImageName(@"灰色地址");
        [backView addSubview:pointImageView];
        
        self.addressLabel = [[UILabel alloc]initWithFrame:KFrame(pointImageView.maxX+5 ,pointImageView.y, 100 , 15)];
        self.addressLabel.textColor = KHexRGB(0x333333);
        self.addressLabel.font = KFont(14);
        self.addressLabel.text = @"北京市海淀区";
        [backView addSubview:self.addressLabel];
        
        
        UIImageView *pepleImageView = [[UIImageView alloc]initWithFrame:KFrame(_addressLabel.maxX+10, _nameLabel.maxY+15+2, 15, 12)];
        pepleImageView.image = KImageName(@"industry");
        [backView addSubview:pepleImageView];
        
        self.legalLabel = [[UILabel alloc]initWithFrame:KFrame(pepleImageView.maxX+5 ,_nameLabel.maxY+15, backView.width - pepleImageView.maxX - 20 , 15)];
        self.legalLabel.textColor = KHexRGB(0x333333);
        self.legalLabel.font = KFont(14);
        self.legalLabel.text = @"北京市海淀区";
        [backView addSubview:self.legalLabel];
   
    }
    return self;
}

-(void)setCompanyModel:(NearCompanyModel *)companyModel
{
    _companyModel = companyModel;
    
    self.nameLabel.text = companyModel.name;
    self.legalLabel.text = companyModel.legalPerson;
    
    self.addressLabel.text = companyModel.area;

}






@end
