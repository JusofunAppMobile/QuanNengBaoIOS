//
//  CustomAlert.h
//  NetworkTest
//
//  Created by JUSFOUN on 2017/10/16.
//  Copyright © 2017年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AlertStylePlain,//只含标题的样式
    AlertStyleTextField,//包含输入框的样式
    AlertStyleAgreement,//用户协议类型
} AlertStyle;


typedef void(^Callback)(NSString *text);

typedef void(^ContentCallback)();

@interface CustomAlert : UIView

@property (nonatomic ,copy) Callback handler;

@property (nonatomic ,copy) ContentCallback contentCallback;

//AlertStylePlain样式下placeholder传nil
- (instancetype)initWithTitle:(NSString *)title style:(AlertStyle)style placeholder:(NSString *)placeholder callBack:(Callback)handler;

//自定义按钮title
- (instancetype)initWithTitle:(NSString *)title style:(AlertStyle)style placeholder:(NSString *)placeholder cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherTitle callBack:(Callback)handler;

- (instancetype)initWithTitle:(NSAttributedString*)title cancelButtonTitle:( NSString *)cancelTitle otherButtonTitle:(NSString *)otherTitle callBack:(Callback)handler contentCallBack:(ContentCallback)handler2;

- (void)showInView:(UIView *)view;


@end

