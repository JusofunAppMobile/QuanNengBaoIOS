//
//  StockCell.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/12/28.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "StockCell.h"

@implementation StockCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView *backView = [[UIView alloc]initWithFrame:KFrame(15, 10, KDeviceW - 30, 105)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.shadowColor =  [UIColor lightGrayColor].CGColor;;
        backView.layer.shadowOffset = CGSizeMake(0.3, .2);//0,-3
        backView.layer.shadowRadius = 3;// 阴影扩散的范围控制
        backView.layer.shadowOpacity = 0.8;// 阴影透明度
        backView.layer.cornerRadius = 5;
        [self.contentView addSubview:backView];
        
        UILabel *wenhao = [[UILabel alloc]initWithFrame:KFrame(15, 15, 75, 15)];
        wenhao.textColor = KRGB(158, 158, 158);
        wenhao.text = @"登记编号：";
        wenhao.font = KFont(14);
        [backView addSubview:wenhao];
        
        self.numLabel = [[UILabel alloc]initWithFrame:KFrame(wenhao.maxX + 5, wenhao.y, backView.width - wenhao.maxX -20 , wenhao.height)];
        self.numLabel.textColor = [UIColor blackColor];
        self.numLabel.font = KFont(14);
        [backView addSubview:self.numLabel];
        
        UILabel *leixing = [[UILabel alloc]initWithFrame:KFrame(wenhao.x, wenhao.maxY+15, wenhao.width, 15)];
        leixing.textColor = KRGB(158, 158, 158);
        leixing.text = @"出质人：";
        leixing.font = KFont(14);
        [backView addSubview:leixing];
        
        self.chuZhiLabel = [[UILabel alloc]initWithFrame:KFrame(leixing.maxX + 5, leixing.y, self.numLabel.width , leixing.height)];
        self.chuZhiLabel.textColor = [UIColor blackColor];
        self.chuZhiLabel.font = KFont(14);
        [backView addSubview:self.chuZhiLabel];
        
        
        UILabel *riqi = [[UILabel alloc]initWithFrame:KFrame(wenhao.x, leixing.maxY+15, wenhao.width, 15)];
        riqi.textColor = KRGB(158, 158, 158);
        riqi.text = @"质权人：";
        riqi.font = KFont(14);
        [backView addSubview:riqi];
        
        self.zhiQuanLabel = [[UILabel alloc]initWithFrame:KFrame(riqi.maxX + 5, riqi.y, self.numLabel.width , riqi.height)];
        self.zhiQuanLabel.textColor = [UIColor blackColor];
        self.zhiQuanLabel.font = KFont(14);
        [backView addSubview:self.zhiQuanLabel];
        
        
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
