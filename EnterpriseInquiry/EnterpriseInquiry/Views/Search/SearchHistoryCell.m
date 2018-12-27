//
//  SearchHistoryCell.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/15.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "SearchHistoryCell.h"

@interface SearchHistoryCell ()

@property (nonatomic ,assign)SearchHistoryCellType type;
@property (nonatomic ,strong)NSArray *dataArray;

@end

@implementation SearchHistoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
    
}

-(void)buttonClick:(UIButton*)button
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(historyButtonClick:)])
    {
        [self.delegate historyButtonClick:button.titleLabel.text];
    }
}



- (void)setDataArray:(NSArray *)dataArray cellType:(SearchHistoryCellType)type{
    
    _dataArray = dataArray;
    _type = type;
    
    [self drawBtnView];
}


-(void)drawBtnView
{
    
    for(UIView *view in self.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    int width = 10;
    int height = 0;
    for(int i = 0;i<_dataArray.count;i++)
    {
        NSString *str = self.dataArray[i];
        
        CGFloat stringWidth = [Tools getWidthWithString:self.dataArray[i] fontSize:13 maxHeight:25]+30;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ((width + stringWidth +10) > KDeviceW)
        {
            
            height++;
            width = 10;
            button.frame = CGRectMake(width, 10*(height+1) + 30 *height, stringWidth, 30);
            
        }else{
            button.frame = CGRectMake(width, 10*(height+1) + 30*height, stringWidth, 30);
            
        }
        width = width+stringWidth + 10;
        
        button.backgroundColor = KHexRGB(0xf3f4f5);
        button.layer.cornerRadius = 15;
        button.clipsToBounds = YES;
        [button setTitleColor:KHexRGB(0xFFA44C) forState:UIControlStateNormal];
        button.titleLabel.font = KFont(13);
        [button setTitle:str forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        [self setButtonStyle:button];
    }
    
    
    CGRect frame = self.frame;
    
    frame.size.height = 10*(height+1) + 30*height + 30 +20;
    
    self.frame = frame;
}

- (void)setButtonStyle:(UIButton *)button{
    
    if (_type == SearchHistoryType) {
        button.backgroundColor = KHexRGB(0xf3f3f3);
        [button setTitleColor:KHexRGB(0x3f3f3f) forState:UIControlStateNormal];
        button.layer.borderWidth = 0;
    }else{
        
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:KHexRGB(0x458ef8) forState:UIControlStateNormal];
        button.layer.borderWidth = .5;
        button.layer.borderColor = KHexRGB(0x458ef8).CGColor;
    }
    
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

