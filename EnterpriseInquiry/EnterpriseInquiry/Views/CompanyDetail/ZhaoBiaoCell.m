//
//  ZhaoBiaoCell.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/10.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "ZhaoBiaoCell.h"

@implementation ZhaoBiaoCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView *backView = [[UIView alloc]initWithFrame:KFrame(15, 10, KDeviceW - 30, 160)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.shadowColor =  [UIColor lightGrayColor].CGColor;;
        backView.layer.shadowOffset = CGSizeMake(0.3, .2);//0,-3
        backView.layer.shadowRadius = 3;// 阴影扩散的范围控制
        backView.layer.shadowOpacity = 0.8;// 阴影透明度
        backView.layer.cornerRadius = 5;
        [self.contentView addSubview:backView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:KFrame(15,10, backView.width - 30 , 50)];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = KFont(16);
        self.nameLabel.numberOfLines = 0;
        [backView addSubview:self.nameLabel];
        
        
        UILabel *wenhao = [[UILabel alloc]initWithFrame:KFrame(15, _nameLabel.maxY + 10, 80, 15)];
        wenhao.textColor = KRGB(158, 158, 158);
        wenhao.text = @"所属地区：";
        wenhao.font = KFont(14);
        [backView addSubview:wenhao];
        
        self.areaLabel = [[UILabel alloc]initWithFrame:KFrame(wenhao.maxX + 5, wenhao.y, backView.width - wenhao.maxX -20 , wenhao.height)];
        self.areaLabel.textColor = [UIColor blackColor];
        self.areaLabel.font = KFont(14);
        [backView addSubview:self.areaLabel];
        
        UILabel *leixing = [[UILabel alloc]initWithFrame:KFrame(wenhao.x, wenhao.maxY+15, wenhao.width, 15)];
        leixing.textColor = KRGB(158, 158, 158);
        leixing.text = @"发布日期：";
        leixing.font = KFont(14);
        [backView addSubview:leixing];
        
        self.dateLabel = [[UILabel alloc]initWithFrame:KFrame(leixing.maxX + 5, leixing.y, self.areaLabel.width , leixing.height)];
        self.dateLabel.textColor = [UIColor blackColor];
        self.dateLabel.font = KFont(14);
        [backView addSubview:self.dateLabel];
        
        
        UILabel *riqi = [[UILabel alloc]initWithFrame:KFrame(wenhao.x, leixing.maxY+15, wenhao.width, 15)];
        riqi.textColor = KRGB(158, 158, 158);
        riqi.text = @"项目分类：";
        riqi.font = KFont(14);
        [backView addSubview:riqi];
        
        self.typeLabel = [[UILabel alloc]initWithFrame:KFrame(riqi.maxX + 5, riqi.y, self.areaLabel.width , riqi.height)];
        self.typeLabel.textColor = KHexRGB(0x1E9EFB);
        self.typeLabel.font = KFont(14);
        [backView addSubview:self.typeLabel];
        
        
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
