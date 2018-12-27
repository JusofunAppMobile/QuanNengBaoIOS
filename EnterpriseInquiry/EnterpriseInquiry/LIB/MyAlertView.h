//
//  MyAlertView.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/18.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyAlertViewDelegate;

@interface MyAlertView : UIView<CAAnimationDelegate>
@property (strong ,nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIImageView *contentView;
@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;
@property (weak,nonatomic) id<MyAlertViewDelegate> delegate;

@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;

@property (strong, nonatomic) UIView *alertView;
@property (strong, nonatomic) UITextField *alertTf;


@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *buttonTitleArray;


- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon message:(NSString *)message delegate:(id<MyAlertViewDelegate>)delegate buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

//
//-(instancetype)initWithTitle:(NSString *)title delegate:(id<MyAlertViewDelegate>)delegate buttonTitles:(NSString *)buttonTitles,...NS_REQUIRES_NIL_TERMINATION;
//
//-(instancetype)initShareViewWithTitle:(NSString *)title icon:(UIImage *)icon andMeaasge:(NSString *)message deklegate:(id<MyAlertViewDelegate>) delegate buttonTitles:(NSString *)buttonTitles,...NS_REQUIRES_NIL_TERMINATION;



- (void)show;

- (void)hide;

- (void)setTitleColor:(UIColor *)color fontSize:(CGFloat)size;

- (void)setMessageColor:(UIColor *)color fontSize:(CGFloat)size;

- (void)setButtonTitleColor:(UIColor *)color fontSize:(CGFloat)size atIndex:(NSInteger)index;
@end

@protocol MyAlertViewDelegate <NSObject>

-(void)alertView:(MyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@optional
-(void)shareButtonClickWithType:(NSInteger)buttonIndex;
-(void)hideWithOtherWork;

@end
