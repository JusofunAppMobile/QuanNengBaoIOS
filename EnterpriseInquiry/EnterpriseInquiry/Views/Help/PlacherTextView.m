//
//  PlacherTextView.m
//  EnterpriseInquiry
//
//  Created by clj on 16/8/12.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "PlacherTextView.h"

@implementation PlacherTextView
@synthesize placeHolderLabel;

@synthesize placeholder;

@synthesize placeholderColor;

@synthesize placeholdFrame;

- (id)initWithFrame:(CGRect)frame

{
    if( (self = [super initWithFrame:frame]) )
        
    {
        _isCustomePlaceFrame  = NO;
        [self setPlaceholder:@""];
        [self setPlaceholderColor:KHexRGB(0xA6A6A6)];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame withIsCustomPlaceFrame:(BOOL)isCustomPlaceHoldFrame andPlaceFrame:(CGRect)placeFrame

{
    if( (self = [super initWithFrame:frame]) )
    {
        _isCustomePlaceFrame  = isCustomPlaceHoldFrame;
        placeholdFrame = placeFrame;
        [self setPlaceholder:@""];
        [self setPlaceholderColor:KHexRGB(0xA6A6A6)];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}





- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}
- (void)setText:(NSString *)text {
    
    [super setText:text];
    
    [self textChanged:nil];
    
}

- (void)drawRect:(CGRect)rect

{
    
    if( [[self placeholder] length] > 0 )
        
    {
        
        if ( placeHolderLabel == nil )
            
        {
            
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            if (_isCustomePlaceFrame) {
                placeHolderLabel.frame = placeholdFrame;
            }
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            placeHolderLabel.numberOfLines = 0;
            
            placeHolderLabel.font = self.font;
            
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            
            placeHolderLabel.textColor = self.placeholderColor;
            
            placeHolderLabel.alpha = 0;
            placeHolderLabel.text = [self placeholder];
            
            placeHolderLabel.tag = 999;
            
            [self addSubview:placeHolderLabel];
            
        }
        
        placeHolderLabel.text = self.placeholder;
        
        [placeHolderLabel sizeToFit];
        
        [self sendSubviewToBack:placeHolderLabel];
        
    }
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
        
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    [super drawRect:rect];
    
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    if (_isCustomePlaceFrame) {
        return CGRectInset(bounds,0,0.0);
    }else
    {
        return CGRectInset(bounds,10,0.0);
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    if (_isCustomePlaceFrame) {
        return CGRectInset(bounds,0,0.0);
    }else
    {
        return CGRectInset(bounds,10,0.0);
    }
    
}


@end
