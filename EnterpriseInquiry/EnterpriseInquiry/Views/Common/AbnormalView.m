//
//  AbnormalView.m
//  EnterpriseInquiry
//
//  Created by jusfoun on 15/11/27.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "AbnormalView.h"
@interface AbnormalView ()
{
    //异常图片
    UIImageView *abmormalImageView;
    //提示语
    UILabel *hintLabel;
    
    //转圈的图片
    UIImageView *loopimageView;
    
    //操作 887
    UILabel *handleLabel;
    
    UIView *reloadView;
    
    float hintSizeHight;
    
    NSTimer *timer;
    
    int  num;
    
    UILabel *numLabel;
}

@end

@implementation AbnormalView


-(instancetype)initWithFrame:(CGRect)frame withAbnormalImage:(NSString *)imageName withHint:(NSString *)hintStr isReload:(BOOL)isReload
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        if(imageName.length == 0)
        {
            imageName = @"NetworkBroken";
        }
        
        if(hintStr.length == 0)
        {
            hintStr = @"网络异常";
        }
        
        UIImage *image = [UIImage imageNamed:imageName];
        
        abmormalImageView = [[YYAnimatedImageView alloc]initWithImage:image];
        abmormalImageView.size = image.size;
        abmormalImageView.center = CGPointMake(frame.size.width/2, frame.size.height/2-image.size.height/2 - 35);
        [self addSubview:abmormalImageView];
        
       // CGSize hintSize = [hintStr getStringSizeWithFont:[UIFont fontWithName:FoneName size:16] width:frame.size.width-30];
        CGFloat hintHight = [Tools getHeightWithString:hintStr fontSize:16 maxWidth:frame.size.width-30];

        hintSizeHight = hintHight +5;
        hintLabel = [[UILabel alloc]initWithFrame:KFrame(15, 0, frame.size.width-30, hintSizeHight)];
        hintLabel.font = KFont(16);
        hintLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        hintLabel.text = hintStr;
        hintLabel.numberOfLines = 0;
        hintLabel.textAlignment = NSTextAlignmentCenter;
        hintLabel.textColor = [UIColor blackColor];
        [self addSubview:hintLabel];
        
        if(isReload)
        {
            reloadView = [[UIView alloc]init];
            [self addSubview:reloadView];
            
            loopimageView = [[UIImageView alloc]initWithImage:[Tools scaleImage:KImageName(@"不能刷新") size:CGSizeMake(15, 15)]];
            loopimageView.frame = KFrame(0, 0, 15, 15);
            [reloadView addSubview:loopimageView];
            
            handleLabel = [[UILabel alloc]init];
            handleLabel.font = KFont(15);
            handleLabel.textColor = KRGB(102, 102, 102);
            handleLabel.textAlignment = NSTextAlignmentCenter;
            NSString *str = @"点击页面刷新";
            
            CGFloat sizeWidth = [Tools getWidthWithString:str fontSize:15 maxHeight:frame.size.width];
            handleLabel.text = str;
            handleLabel.frame = KFrame(20, 0, sizeWidth, 15);
            [reloadView addSubview:handleLabel];
            
            reloadView.frame = KFrame(0, 0, sizeWidth + 20, 15);
            reloadView.center = CGPointMake(frame.size.width/2, frame.size.height/2 + hintSizeHight);
            
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reload:)];
            [self addGestureRecognizer:tap];
            
        }
        
        
        
    }
    
    return self;
}

-(void)reload:(UITapGestureRecognizer *)tap
{
    
    [self removeGestureRecognizer:tap];
    
    NSString *str = @"正在刷新";
    
     CGFloat sizeWidth = [Tools getWidthWithString:str fontSize:15 maxHeight:self.frame.size.width];
    
    //CGSize size = [str getStringSizeWithFont:[UIFont fontWithName:FoneName size:15] width:self.frame.size.width];
    handleLabel.text = str;
    
  
    
    handleLabel.frame = KFrame(0, 0, sizeWidth, 15);
    
    numLabel = [[UILabel alloc]initWithFrame:KFrame(CGRectGetMaxX(handleLabel.frame), CGRectGetMinY(handleLabel.frame), 40, 15)];
    numLabel.text = @"";
    [reloadView addSubview:numLabel];
    reloadView.frame = KFrame(0, 0, sizeWidth + 40, 15);
    reloadView.center = CGPointMake(self.frame.size.width/2 + 15, self.frame.size.height/2 + hintSizeHight );
    loopimageView.hidden = YES;
    hintLabel.hidden = YES;
    
    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource: @"LoadingImage" ofType :@"bundle"];
    
    NSMutableArray *nameArray = [NSMutableArray arrayWithCapacity:1];
    
    for(int i = 1;i<=21;i++)
    {
        NSString *str = [NSString stringWithFormat:@"Loading%d.png",i];
        [nameArray addObject:str];
    }
    
    NSMutableArray *imagePath = [NSMutableArray arrayWithCapacity:1];
    for(NSString *nameStr in nameArray)
    {
        NSString *imgPath= [bundlePath stringByAppendingPathComponent:nameStr];
        
        
        NSData *data = [NSData dataWithContentsOfFile:imgPath];
        [imagePath addObject:data];
    }
    
    
   
   
    UIImage *images = [[YYFrameImage alloc]initWithImageDataArray:imagePath oneFrameDuration:0.1 loopCount:0];
    CGRect frame = abmormalImageView.frame;
    frame.size = images.size;
    abmormalImageView.frame = frame;
    abmormalImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 35);
    abmormalImageView.image = images;
    
    num = 1;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(labelChange) userInfo:nil repeats:YES];
    
    if(self.delegate&&[self.delegate respondsToSelector:@selector(reloadView)])
    {
       [self.delegate reloadView];
        
    }
    
  
}

-(void)labelChange
{
    
    
    num ++;
    
    NSString *str;
    if(num == 2)
    {
        str = @" . ";
    }
    if(num == 3)
    {
        str = @" . . ";
    }
    
    if(num == 4)
    {
        str = @" . . . ";
        
    }
    if(num == 5)
    {
        str = @" ";
        num = 1;
    }
    
 
    
    numLabel.text = str;
   
}


-(void)dealloc
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}



@end
