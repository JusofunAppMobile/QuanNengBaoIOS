//
//  NearListCell.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/2.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "NearListCell.h"

@implementation NearListCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
        self.backgroundColor = KRGB(255, 255, 255);
        
        UIView *backView = [[UIView alloc]initWithFrame:KFrame(10, 10, KDeviceW - 20, 165)];
        backView.layer.borderColor = KRGB(243, 241, 239).CGColor;
        backView.layer.borderWidth = 1;
        backView.layer.cornerRadius = 5;
        backView.clipsToBounds = YES;
        backView.layer.shadowOpacity = 0.5;// 阴影透明度
        backView.layer.shadowColor = KRGB(243, 241, 239).CGColor;// 阴影的颜色
        backView.layer.shadowRadius = 3;// 阴影扩散的范围控制
        backView.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
        [self.contentView addSubview:backView];
        
        
        _nameLabel = [[UILabel alloc]initWithFrame:KFrame(15, 10, backView.width-30, 20)];
        _nameLabel.textColor = KRGB(51, 51, 51);
        _nameLabel.font = KBlodFont(16);
        _nameLabel.text = @"酒泉市公安局交警支队机动车专";
        //_nameLabel.numberOfLines = 0;
        [backView addSubview:_nameLabel];
        
        _statusLabel = [[UILabel alloc]initWithFrame:KFrame(_nameLabel.x, _nameLabel.maxY + 10, _nameLabel.width, 20)];
        _statusLabel.textColor = KRGB(96, 185, 250);
        _statusLabel.font = KBlodFont(12);
        _statusLabel.text = @"开业";
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:_statusLabel];
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:KFrame(_nameLabel.x, _statusLabel.maxY + 15, 90, 15)];
        label.textColor = KRGB(155, 155, 155);
        label.font = KFont(14);
        label.text = @"法定代表人：";
        [backView addSubview:label];
        
        self.peopleLabel = [[UILabel alloc]initWithFrame:KFrame(label.maxX + 5, label.y, backView.width - label.maxX -10 , label.height)];
        self.peopleLabel.textColor = KRGB(30, 158, 251);
        self.peopleLabel.font = KFont(14);
        self.peopleLabel.text = @"王叁寿";
        [backView addSubview:self.peopleLabel];
        
        
        UILabel *zijin = [[UILabel alloc]initWithFrame:KFrame(label.x, label.maxY+15, label.width, 15)];
        zijin.textColor = KRGB(158, 158, 158);
        zijin.text = @"注册 资金：";
        zijin.font = KFont(14);
        [backView addSubview:zijin];
        
        
        self.distanceLabel = [[UILabel alloc]initWithFrame:KFrame(backView.width - 10-100, zijin.y, 100 , zijin.height)];
        self.distanceLabel.textColor = KRGB(158, 158, 158);
        self.distanceLabel.font = KFont(14);
        self.distanceLabel.text = @"100m";
        self.distanceLabel.textAlignment = NSTextAlignmentRight;
        [backView addSubview:self.distanceLabel];
        
        
        self.moneyLabel = [[UILabel alloc]initWithFrame:KFrame(zijin.maxX + 5, zijin.y, backView.width - zijin.maxY - self.distanceLabel.width -10 , zijin.height)];
        self.moneyLabel.textColor = [UIColor blackColor];
        self.moneyLabel.font = KFont(14);
        self.moneyLabel.text = @"2000万人民币";
        [backView addSubview:self.moneyLabel];
    
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:KFrame(0, self.moneyLabel.maxY + 15, backView.width, 30)];
        //imageView.image = KImageName(@"areaBack");
        imageView.backgroundColor = KRGB(255, 247, 237);
        [backView addSubview:imageView];
        
        UIImageView *pointImageView = [[UIImageView alloc]initWithFrame:KFrame(imageView.width - 15 - 13, imageView.height /2-8, 13, 16)];
        pointImageView.image = KImageName(@"淡棕色定位icon");
        [imageView addSubview:pointImageView];
        
        self.areaLabel = [[UILabel alloc]initWithFrame:KFrame(15 ,0, imageView.width -30 - 10-13-10 , imageView.height)];
        self.areaLabel.textColor = KHexRGB(0xa8704c);
        self.areaLabel.font = KFont(12);
        self.areaLabel.text = @"北京市海淀区768创意产业园 B－11";
        [imageView addSubview:self.areaLabel];
        
    }
    
    return self;
}

-(void)setCompanyModel:(NearCompanyModel *)companyModel
{
    _companyModel = companyModel;
    
    self.nameLabel.text = companyModel.name;
    
    self.statusLabel.text = companyModel.registerStatus;
    CGFloat width = [Tools getWidthWithString:companyModel.registerStatus fontSize:12 maxHeight:15] + 10;
    
    CGRect frame = self.statusLabel.frame;
    frame.size.width = width;
    self.statusLabel.frame = frame;
    
    self.statusLabel.layer.borderColor = KHexRGB(0x1E9EFB).CGColor;
    self.statusLabel.layer.borderWidth = 1;
    self.statusLabel.layer.cornerRadius = 5;
    
    self.peopleLabel.text = companyModel.legalPerson;
    self.moneyLabel.text = companyModel.money;
    self.areaLabel.text = companyModel.area;
    self.distanceLabel.text = companyModel.distance;
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
