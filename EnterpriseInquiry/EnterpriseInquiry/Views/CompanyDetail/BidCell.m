//
//  BidCell.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/7.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "BidCell.h"

@implementation BidCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
        self.backgroundColor = [UIColor whiteColor];
    
        
        _nameLabel = [[UILabel alloc]initWithFrame:KFrame(15, 10, KDeviceW-30, 50)];
        _nameLabel.textColor = KHexRGB(0x333333);
        _nameLabel.font = KBlodFont(16);
        _nameLabel.text = @"酒泉市公安局交警支队机动车专门查验区查验系统采购项目竞争性谈判成交公告";
        _nameLabel.numberOfLines = 0;
        [self.contentView addSubview:_nameLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:KFrame(15, _nameLabel.maxY + 15 -0.5, KDeviceW-30, 0.5)];
        lineView.backgroundColor = KHexRGB(0xebebeb);
        [self.contentView addSubview:lineView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:KFrame(15, lineView.maxY + 15, 60, 15)];
        label.textColor = KHexRGB(0x999999);
        label.font = KFont(13);
        label.text = @"所属地区:";
        [self.contentView addSubview:label];
        
        _areaLabel = [[UILabel alloc]initWithFrame:KFrame(label.maxX, label.y, KDeviceW/2.0-label.maxX-5, 15)];
        _areaLabel.textColor = KHexRGB(0x333333);
        _areaLabel.font = KFont(14);
        _areaLabel.text = @"山西省";
        [self.contentView addSubview:_areaLabel];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:KFrame(KDeviceW/2.0 +5, label.y, 60, 15)];
        label2.textColor = KHexRGB(0x999999);
        label2.font = KFont(13);
        label2.text = @"发布时间:";
        [self.contentView addSubview:label2];
        
        _timeLabel = [[UILabel alloc]initWithFrame:KFrame(label2.maxX, label.y , KDeviceW/2-5- 60 -15-15-10, 15)];
        _timeLabel.textColor = KHexRGB(0x333333);
        _timeLabel.font = KFont(14);
        _timeLabel.text = @"2017-03-20";
        [self.contentView addSubview:_timeLabel];
        
        
        UILabel *label3 = [[UILabel alloc]initWithFrame:KFrame(15, label.maxY + 15, 60, 15)];
        label3.textColor = KHexRGB(0x999999);
        label3.font = KFont(13);
        label3.text = @"项目分类:";
        [self.contentView addSubview:label3];
        
        _classifyLabel = [[UILabel alloc]initWithFrame:KFrame(label3.maxX, label3.y , KDeviceW - label3.maxX - 40, 15)];
        _classifyLabel.textColor = KHexRGB(0x333333);
        _classifyLabel.font = KFont(14);
        _classifyLabel.text = @"中标结果公告中标结果公告中标结果公告中标结果公告中标结果公告中标结果公告";
        [self.contentView addSubview:_classifyLabel];

        UIImageView *imageView = [[UIImageView alloc]initWithFrame:KFrame(_timeLabel.maxX +10, _timeLabel.maxY, 15, 15)];
        imageView.image = KImageName(@"canTouchIcon");
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        
        
        UIView *kongView = [[UIView alloc]initWithFrame:KFrame(0, label3 .maxY +20, KDeviceW, 5)];
        //kongView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        [kongView jm_setCornerRadius:0 withBorderColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00] borderWidth:0.5 backgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00] backgroundImage:nil contentMode:UIViewContentModeScaleToFill];
        [self.contentView addSubview:kongView];
        
    }
    
    return self;
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
