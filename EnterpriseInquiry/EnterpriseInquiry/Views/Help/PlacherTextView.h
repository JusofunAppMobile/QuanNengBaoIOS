//
//  PlacherTextView.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/12.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacherTextView : UITextView

@property(nonatomic, retain) UILabel *placeHolderLabel;

@property(nonatomic, retain) NSString *placeholder;

@property(nonatomic, retain) UIColor *placeholderColor;

@property (nonatomic, assign) CGRect placeholdFrame;

@property (nonatomic,assign) BOOL isCustomePlaceFrame;

-(void)textChanged:(NSNotification*)notification;


- (id)initWithFrame:(CGRect)frame withIsCustomPlaceFrame:(BOOL)isCustomPlaceHoldFrame andPlaceFrame:(CGRect)placeFrame;

@end
