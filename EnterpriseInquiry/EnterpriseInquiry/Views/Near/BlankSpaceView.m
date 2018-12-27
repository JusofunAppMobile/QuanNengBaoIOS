//
//  BlankSpaceView.m
//  jusfounData
//
//  Created by Jusfoun on 15/8/4.
//  Copyright (c) 2015年 jusfoun. All rights reserved.
//

#import "BlankSpaceView.h"
@implementation BlankSpaceView

- (id)initWithFrame:(CGRect)frame image:(NSString *)image text:(NSString *)string
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setupViewWithImage:image text:string];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadData)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setupViewWithImage:(NSString *)image text:(NSString *)string
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:KFrame((self.frame.size.width - 100) / 2, self.frame.size.height / 2 - 120, 100, 100)];
    imageView.image = KImageName(image);
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:KFrame(0, imageView.frame.origin.y + imageView.frame.size.height + 15, KDeviceW, 40)];
    label.text = string;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font =[UIFont fontWithName:@"Helvetica" size:16];
    //label.font = [UIFont systemFontOfSize:16];
    [self addSubview:label];
}


-(void)loadData
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(blankSpaceViewTag)])
    {
        [self.delegate blankSpaceViewTag];
    }

}






@end
