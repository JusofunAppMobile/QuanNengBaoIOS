//
//  HotInformationCell.m
//  EnterpriseInquiry
//
//  Created by 方首滔 on 16/9/22.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "HotInformationCell.h"

@implementation HotInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAddLayout];
    }
    return self;
}

#pragma mark - 布局赋值
-(void)setModel:(NewsModel *)newsModel{
    _newsModel = newsModel;
    
    [self.InformationImg sd_setImageWithURL:[NSURL URLWithString:newsModel.newsimgurl] placeholderImage:[UIImage imageNamed:@"info_moretu"]];
    self.InfomationLabel.text = newsModel.newstitle;
    self.InfomationreadNum.text = [NSString stringWithFormat:@"%@阅读",newsModel.newreadcount];
}

-(void)setAddLayout{
    
      [self.contentView addSubview:self.InformationImg];
      [self.contentView addSubview:self.InfomationLabel];
      [self.contentView addSubview:self.InfomationreadNum];
    
    
    [self.InformationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@60);
        make.height.equalTo(@45);
        make.top.equalTo(@10);
        make.left.equalTo(@15);
        
    }];
    
   
    [self.InfomationreadNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@65);
        make.right.equalTo(@-15);
        make.centerY.equalTo(self);
    }];
    [self.InfomationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_InformationImg.mas_right).offset(15);
        make.right.equalTo(_InfomationreadNum.mas_left).offset(-11.5);
        make.centerY.equalTo(self);
    }];
}



-(void)setNewsModel:(NewsModel *)newsModel{
    _newsModel = newsModel;
    
    [_InformationImg sd_setImageWithURL:[NSURL URLWithString:newsModel.newsimgurl] placeholderImage:[UIImage imageNamed:@"info_moretu"]];
    _InfomationLabel.text = [NSString stringWithFormat:@"%@",newsModel.newstitle];
    _InfomationreadNum.text = [NSString stringWithFormat:@"%@阅读",newsModel.newreadcount];
}
#pragma mark - 懒加载

-(UIImageView *)InformationImg
{
    if (_InformationImg == nil) {
        
        _InformationImg = [[UIImageView alloc]init];
            }
    return _InformationImg;
}


-(UILabel *)InfomationLabel{
    
    if (_InfomationLabel == nil) {
        _InfomationLabel = [[UILabel alloc]init];
        _InfomationLabel.font = [UIFont systemFontOfSize:15.0f];
        _InfomationLabel.numberOfLines = 2;
        _InfomationLabel.textColor = KHexRGB(0x666666);

    }
    return _InfomationLabel;
}


-(UILabel *)InfomationreadNum{
    if (_InfomationreadNum == nil) {
        _InfomationreadNum =[[UILabel alloc]init];
        _InfomationreadNum.textAlignment = NSTextAlignmentRight;
        _InfomationreadNum.font = [UIFont systemFontOfSize:12.0f];
        _InfomationreadNum.textColor = KHexRGB(0x666666);
     
    }
    return _InfomationreadNum;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
