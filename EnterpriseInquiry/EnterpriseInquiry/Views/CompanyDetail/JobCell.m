//
//  JobCell.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/8.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "JobCell.h"

@implementation JobCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        _nameLabel = [[UILabel alloc]initWithFrame:KFrame(15, 15, KDeviceW-30, 15)];
        _nameLabel.textColor = KHexRGB(0x333333);
        _nameLabel.font = KBlodFont(16);
        _nameLabel.text = @"品管数名月5千+双休";
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:KFrame(_nameLabel.x, _nameLabel.maxY + 10 , _nameLabel.width, 10)];
        _timeLabel.textColor = KHexRGB(0x999999);
        _timeLabel.font = KFont(13);
        _timeLabel.text = @"2017-03-20";
        [self.contentView addSubview:_timeLabel];

        
        
        UIView *lineView = [[UIView alloc]initWithFrame:KFrame(15, _timeLabel.maxY + 10 -0.5, KDeviceW-30, 0.5)];
        lineView.backgroundColor = KHexRGB(0xebebeb);
        [self.contentView addSubview:lineView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:KFrame(15, lineView.maxY + 15, 33, 15)];
        label.textColor = KHexRGB(0x999999);
        label.font = KFont(13);
        label.text = @"薪资:";
        [self.contentView addSubview:label];
        
        
        _moneyLabel = [[UILabel alloc]initWithFrame:KFrame(label.maxX, label.y, KDeviceW/2.0-label.maxX-5, 15)];
        _moneyLabel.textColor = KHexRGB(0xff6500);
        _moneyLabel.font = KFont(14);
        _moneyLabel.text = @"面议";
        [self.contentView addSubview:_moneyLabel];
        
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:KFrame(KDeviceW/2.0 +5, label.y, 33, 15)];
        label2.textColor = KHexRGB(0x999999);
        label2.font = KFont(13);
        label2.text = @"地点:";
        [self.contentView addSubview:label2];
        
        _areaLabel = [[UILabel alloc]initWithFrame:KFrame(label2.maxX, label.y, KDeviceW/2.0-label2.width-5 -40, 15)];
        _areaLabel.textColor = KHexRGB(0x3d7ee3);
        _areaLabel.font = KFont(14);
        _areaLabel.text = @"山西省";
        [self.contentView addSubview:_areaLabel];
        
        
        
        UILabel *label3 = [[UILabel alloc]initWithFrame:KFrame(15, label.maxY + 15, 33, 15)];
        label3.textColor = KHexRGB(0x999999);
        label3.font = KFont(13);
        label3.text = @"经验:";
        [self.contentView addSubview:label3];
        
        _experienceLabel = [[UILabel alloc]initWithFrame:KFrame(label3.maxX, label3.y ,KDeviceW/2.0-label.maxX-5, 15)];
        _experienceLabel.textColor = KHexRGB(0x333333);
        _experienceLabel.font = KFont(14);
        _experienceLabel.text = @"不限";
        [self.contentView addSubview:_experienceLabel];
        
        
        UILabel *label4 = [[UILabel alloc]initWithFrame:KFrame(KDeviceW/2.0+5, label3.y, 33, 15)];
        label4.textColor = KHexRGB(0x999999);
        label4.font = KFont(13);
        label4.text = @"学历:";
        [self.contentView addSubview:label4];
        
        _educationLabel = [[UILabel alloc]initWithFrame:KFrame(label4.maxX, label3.y ,KDeviceW/2.0-label4.width-5- 40, 15)];
        _educationLabel.textColor = KHexRGB(0x333333);
        _educationLabel.font = KFont(14);
        _educationLabel.text = @"不限";
        [self.contentView addSubview:_educationLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:KFrame(KDeviceW -30, _areaLabel.maxY, 15, 15)];
        imageView.image = KImageName(@"canTouchIcon");
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        
        
        UIView *kongView = [[UIView alloc]initWithFrame:KFrame(0, label4 .maxY +15, KDeviceW, 5)];
        //kongView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        [kongView jm_setCornerRadius:0 withBorderColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00] borderWidth:0.5 backgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00] backgroundImage:nil contentMode:UIViewContentModeScaleToFill];
        [self.contentView addSubview:kongView];
        
    }
    
    return self;
}
@end
