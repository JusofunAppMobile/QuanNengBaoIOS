//
//  LoseCreditCell.m
//  EnterpriseInquiry
//
//  Created by shancheli on 15/11/18.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "LoseCreditCell.h"

@interface LoseCreditCell ()
{
    UIImageView* credentialsImage;
}


@property(nonatomic,strong)UILabel* nameLab;

@property(nonatomic,strong)UILabel *credentialsLab;

@property(nonatomic,strong)UILabel *numberingLab;

@property(nonatomic,strong)UILabel *cityName;

@property (nonatomic,strong)UIImageView *cityImageV;


@end

@implementation LoseCreditCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //姓名
        UILabel* nameLab = [[UILabel alloc]init];
        nameLab.frame = CGRectMake(10, 10, KDeviceW - 10, 15);
        nameLab.font = [UIFont systemFontOfSize:15];
        nameLab.textAlignment = NSTextAlignmentLeft;
        nameLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:nameLab];
        _nameLab = nameLab;
        
        CGFloat  credentialsY = nameLab.maxY + 9;
        
        //证件号图标
        credentialsImage = [[UIImageView alloc]init];
        credentialsImage.image = [UIImage imageNamed:@"组织机构代码"];
        //credentialsImage.contentMode = UIViewContentModeScaleToFill;
        credentialsImage.frame = CGRectMake(10, nameLab.maxY + 10, 13, 13);
        [self.contentView addSubview:credentialsImage];
        
        //证件号
        UILabel* credentialsLab = [[UILabel alloc]init];
        credentialsLab.frame = CGRectMake(credentialsImage.maxX+5, credentialsY, KDeviceW/2 - credentialsImage.maxX, 15);
        credentialsLab.font = [UIFont systemFontOfSize:13];
        credentialsLab.textAlignment = NSTextAlignmentLeft;
        credentialsLab.textColor = KHexRGB(0x979797);//[Utility hexStringToColor:@"#979797"];
        [self.contentView addSubview:credentialsLab];
        _credentialsLab = credentialsLab;
        
        //城市名称图标
        UIImageView* cityImage = [[UIImageView alloc]init];
        cityImage.image = [UIImage imageNamed:@"cityImg"];
        cityImage.contentMode = UIViewContentModeScaleAspectFit;
        cityImage.frame = CGRectMake(KDeviceW - 100, credentialsY, 15, 15);
        [self.contentView addSubview:cityImage];
        _cityImageV = cityImage;
        
        //城市名称
        UILabel* cityName = [[UILabel alloc]init];
        cityName.frame = CGRectMake(cityImage.maxX + 5, credentialsY, 80, 15);
        cityName.font = [UIFont systemFontOfSize:13];
        cityName.textAlignment = NSTextAlignmentLeft;
        cityName.textColor =KHexRGB(0x979797);// [Utility hexStringToColor:@"#979797"];
        [self.contentView addSubview:cityName];
        _cityName = cityName;
        
        
        //编号图标
        UIImageView* numberingImage = [[UIImageView alloc]init];
        numberingImage.image = [UIImage imageNamed:@"gongshangImg"];
        numberingImage.contentMode = UIViewContentModeScaleAspectFit;
        numberingImage.frame = CGRectMake(10, credentialsImage.maxY + 10, 13, 13);
        [self.contentView addSubview:numberingImage];
        
        //编号
        UILabel* numberingLab = [[UILabel alloc]init];
        numberingLab.frame = CGRectMake(numberingImage.maxX +5, numberingImage.y, KDeviceW - 20, 13);
        numberingLab.font = [UIFont systemFontOfSize:13];
        numberingLab.textAlignment = NSTextAlignmentLeft;
        numberingLab.textColor =KHexRGB(0x979797);// [Utility hexStringToColor:@"#979797"];
        [self.contentView addSubview:numberingLab];
        _numberingLab = numberingLab;
        
    }
    return self;
}

-(void)setLoseCreditModel:(LoseCreditModel *)LoseCreditModel
{
    _LoseCreditModel = LoseCreditModel;
    _nameLab.attributedText  = [Tools titleNameWithTitle:LoseCreditModel.name otherColor:[UIColor blackColor]];
    _credentialsLab.text = LoseCreditModel.credentials;
    _numberingLab.text = LoseCreditModel.numbering;
    _cityName.text = LoseCreditModel.location;
    
    if([LoseCreditModel.type intValue] == 0)
    {
        
        credentialsImage.image = KImageName(@"身份证号");
        
    }
    else
    {
        credentialsImage.image = [UIImage imageNamed:@"组织机构代码"];
    }
    
    
    CGFloat kwidth = [Tools getWidthWithString:LoseCreditModel.location fontSize:14 maxHeight:14];
    _cityName.frame = KFrame(KDeviceW-kwidth-10, _nameLab.maxY + 9, KDeviceW, 14);
    _cityImageV.frame = KFrame(KDeviceW-kwidth-10-15, _nameLab.maxY + 9, 15, 15);
    
}

@end
