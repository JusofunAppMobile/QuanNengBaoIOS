//
//  PaopaoView.m
//  jusfounData
//
//  Created by jusfoun on 15/9/14.
//  Copyright (c) 2015年 jusfoun. All rights reserved.
//

#import "PaopaoView.h"

@implementation PaopaoView

-(instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if(self)
    {
        
       CGSize size =  [self labelAutoCalculateRectWith:title FontSize:16 MaxSize:CGSizeMake(KDeviceW -40, 50)];
        
        CGFloat width = size.width +20 +25;
        
        CGFloat height = size.height + 15 + 10 ;
        
        self.frame = KFrame(0, 0, width, height);
        
        UIImageView *backImageView1 = [[UIImageView alloc]initWithFrame:KFrame(0, 0, (width)/2, height)];
    
        backImageView1.image = [[UIImage imageNamed:@"leftPao"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10,10,10) ] ;
        
        [self addSubview:backImageView1];
        
        
        UIImageView *backImageView2 = [[UIImageView alloc]initWithFrame:KFrame((width)/2, 0, (width)/2, height)];
        
        backImageView2.image = [[UIImage imageNamed:@"rightPao"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10,10,10) ] ;
        
        [self addSubview:backImageView2];
        
        UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:KFrame(width-16-10, height/2-8-2, 16, 16)];
        rightImageView.image = [UIImage imageNamed:@"icon-Right"];
        [self addSubview:rightImageView];
        
        
        //paopao
        UILabel *label = [[UILabel alloc]initWithFrame:KFrame(10, self.height/2-size.height/2-2.5, size.width+ 10, size.height)];
        label.text = title;
        label.textColor = KRGB(249, 110, 23);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = KFont(16);
        [self addSubview:label];
    }
    
    return self;
}

- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize

{
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    
    
    labelSize.height=ceil(labelSize.height);
    
    labelSize.width=ceil(labelSize.width);
    
    return labelSize;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
