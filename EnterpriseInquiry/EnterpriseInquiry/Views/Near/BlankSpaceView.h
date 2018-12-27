//
//  BlankSpaceView.h
//  jusfounData
//
//  Created by Jusfoun on 15/8/4.
//  Copyright (c) 2015年 jusfoun. All rights reserved.
//空白页View

#import <UIKit/UIKit.h>

@protocol BlankSpaceViewDelegate <NSObject>

-(void)blankSpaceViewTag;

@end
@interface BlankSpaceView : UIView

@property(nonatomic,assign)id<BlankSpaceViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame image:(NSString *)image text:(NSString *)string;

@end
