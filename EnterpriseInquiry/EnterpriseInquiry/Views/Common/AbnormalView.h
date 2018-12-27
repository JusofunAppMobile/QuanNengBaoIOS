//
//  AbnormalView.h
//  EnterpriseInquiry
//
//  Created by jusfoun on 15/11/27.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYFrameImage.h>
#import <YYAnimatedImageView.h>
@protocol AbnormalDelegate <NSObject>

-(void)reloadView;


@end

@interface AbnormalView : UIView


-(instancetype)initWithFrame:(CGRect)frame withAbnormalImage:(NSString *)imageName withHint:(NSString *)hintStr isReload:(BOOL)isReload ;


@property(nonatomic,assign) id<AbnormalDelegate> delegate;

@end
