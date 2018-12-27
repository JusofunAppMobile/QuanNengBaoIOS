//
//  Tools.h
//  框架
//
//  Created by WangZhipeng on 16/5/18.
//  Copyright © 2016年 WangZhipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "jusfounCore/JAddField.h"
#import <CRToast.h>


typedef void (^NavigationBarMessageBlock)(NSDictionary *messageDic);


@interface Tools : NSObject


//方法功能：根据字体大小与限宽，计算高度
+(CGFloat)getHeightWithString:(NSString*)string fontSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth;

+(CGFloat)getWidthWithString:(NSString*)string fontSize:(CGFloat)fontSize maxHeight:(CGFloat)maxHeight;

// 生成指定大小的图片
+ (UIImage *)scaleImage:(UIImage*)image size:(CGSize)newsize;

// 生成一张指定颜色的图片
+ (UIImage *)imageWithColor:(UIColor*)color size:(CGSize)newsize;


+(NSString *) md5:(NSString *)str;


//加密
+ (NSMutableDictionary*)addDictionary:(NSMutableDictionary*)dic;

//获取现在的时间
+(NSDate *)GetCurrentTime;

+(int )GetCurrentTimeStamp:(NSDate *)date;


/**
 时间戳转时间
 
 @param timestamp 时间戳
 @return 时间
 */
+(NSString *)timestampSwitchTime:(NSString*)timestamp;

/**
 验证邮箱

 @param emailStr 邮箱字符串
 @return yes or no
 */
+(BOOL)isEmailAddress:(NSString*)emailStr;


/**
 字典转json
 
 @param dic 字典
 @return json字符串
 */
+(NSString *)dictionaryConvertToJsonData:(NSDictionary *)dic;



/**
 将url分割成字典
 
 @param str url
 @param separatStr 用什么分割
 @return 字典
 */
+(NSDictionary*)stringChangeToDictionary:(NSString*)str separatStr:(NSString*)separatStr;

/**
 检查是否为空
 
 @param key key
 @return bool
 */
+(BOOL)checkNull:(NSString*)key;

/**
 展示消息

 @param messageDic 消息字典
 @param tapBlock   点击回调block
 */
+(void)showNavigaitonBarMessage:(NSDictionary *)messageDic tapBlock:(NavigationBarMessageBlock)tapBlock;


/**
 将字符串返回AttributedString

 @param title      想要处理的字符串
 @param otherColor 不加颜色的字符串的颜色

 @return 处理好的字符串
 */
+(NSMutableAttributedString *)titleNameWithTitle:(NSString *)title otherColor:(UIColor*)otherColor;

@end
