//
//  SystemMessageCell.m
//  EnterpriseInquiry
//
//  Created by Ching on 15/11/26.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "SystemMessageCell.h"
#import "UserMessageModle.h"
#define SIZE_SCALE  ([UIScreen mainScreen].bounds.size.width / 320.0)
@implementation SystemMessageCell
{
    UILabel *_titleLable;
    UILabel *_timerLable;
    UILabel *_messageLable;
    UIView  *_lineView;
    UIView  *_readedView;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = KHexRGB_kAlpha(0xffffff, 0.8);
        _readedView = [[UIView alloc] initWithFrame:KFrame(15, 20, 8, 8)];
        _readedView.backgroundColor = KHexRGB(0xff3b50);
        _readedView.layer.cornerRadius = 4;
        [self.contentView addSubview:_readedView];
        
        _titleLable = [[UILabel alloc]init];
        _titleLable.font = KBlodFont(17);
        _titleLable.textColor = KHexRGB(0x333333);
        _titleLable.numberOfLines = 0;
        
        _messageLable = [[UILabel alloc]init];
        _messageLable.font = KFont(15);
        _messageLable.textColor = KHexRGB(0x666666);
        
        _messageLable.numberOfLines = 0;
        
        
        _timerLable = [[UILabel alloc]init];
        _timerLable.font = KFont(12);
        _timerLable.textColor = KHexRGB(0x999999);
        
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = KHexRGB(0xd9d9d9);
        
        [self addSubview:_titleLable];
        [self addSubview:_messageLable];
        [self addSubview:_timerLable];
        [self addSubview:_lineView];
        
    }
    return self;
}

-(void)cellDataWith:(NSDictionary*)dict
{

    _titleLable.text = dict[@"title"];
    _messageLable.text = dict[@"content"];
    _timerLable.text = dict[@"time"];
    
    _readedView.hidden = [dict[@"read"] boolValue];
    
    _titleLable.frame = CGRectMake(38, 15, KDeviceW - 38-15, 17);
    
    CGFloat height =  [Tools getHeightWithString:dict[@"content"] fontSize:15 maxWidth:KDeviceW - 53];
    _messageLable.frame = CGRectMake(38,CGRectGetMaxY(_titleLable.frame)+10, KDeviceW - 53, height);
    _timerLable.frame = CGRectMake(38,CGRectGetMaxY(_messageLable.frame)+10, KDeviceW - 53,12);
    _lineView.frame = CGRectMake(15, CGRectGetMaxY(_timerLable.frame)+15, KDeviceW - 15, 1);
    
    self.frame = KFrame(0, 0, KDeviceW, CGRectGetMaxY(_lineView.frame));
}

@end
