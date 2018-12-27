//
//  Tools.m
//  框架
//
//  Created by WangZhipeng on 16/5/18.
//  Copyright © 2016年 WangZhipeng. All rights reserved.
//

#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Tools

#pragma mark --长度宽度相关方法

//方法功能：根据字体大小与限宽，计算高度
+(CGFloat)getHeightWithString:(NSString*)string fontSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth
{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return [string boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                             attributes:attribute context:nil].size.height;
}



//方法功能：根据字体大小与限高，计算宽度
+(CGFloat)getWidthWithString:(NSString*)string fontSize:(CGFloat)fontSize maxHeight:(CGFloat)maxHeight
{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, maxHeight)
                                options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                             attributes:attribute context:nil].size.width;
}


// 生成指定大小的图片
+ (UIImage *)scaleImage:(UIImage*)image size:(CGSize)newsize;
{
    //UIGraphicsBeginImageContext(newsize);
    UIGraphicsBeginImageContextWithOptions(newsize, NO, 0.0);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;

}

// 生成一张指定颜色的图片
+ (UIImage *)imageWithColor:(UIColor*)color size:(CGSize)imageSize
{
    CGRect rect = (CGRect){{0,0},{imageSize.width,imageSize.height}};
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


#pragma mark - MD5
+(NSString *) md5:(NSString *)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    unsigned int kk = (int)strlen(original_str);
    CC_MD5(original_str, kk, result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}


//加密
+ (NSMutableDictionary*)addDictionary:(NSMutableDictionary*)dic
{
    NSDate *cdate = [Tools GetCurrentTime];
    CGFloat Offset = [[KUserDefaults objectForKey:@"CurrentTimeToServerOffset"] floatValue];
    cdate = [NSDate dateWithTimeInterval:Offset sinceDate:cdate];
    
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:cdate];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:cdate];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
    CGFloat timestamp = [cdate timeIntervalSince1970] - gmtInterval;
    
    int t = (int)timestamp;
    
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [returnDic setObject:[NSString stringWithFormat:@"%d",t] forKey:@"t"];
#warning =======
    if([HOSTURL rangeOfString:@"jinshangmei"].location !=NSNotFound)//存在就是线上预上线
    {
        [returnDic setObject:[JAddField releaseAddField:cdate] forKey:@"m"];
    }
    else//不存在就是线下
    {
        [returnDic setObject:[JAddField debugAddField:cdate] forKey:@"m"];
    }
    
    

    return returnDic;
    
}


+(int )GetCurrentTimeStamp:(NSDate *)date{
    
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:date];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:date];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    return  (int)date.timeIntervalSince1970 - gmtInterval;
}




+(NSDate *)GetCurrentTime{
    NSDate *date = [NSDate date];
    
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:date];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:date];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:date];
    
    return destinationDate;
}

/**
 时间戳转时间
 
 @param timestamp 时间戳
 @return 时间
 */
+(NSString *)timestampSwitchTime:(NSString*)timestamp {
    
    if(timestamp.length == 0)
    {
        return @"--";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}


/**
 验证邮箱
 
 @param emailStr 邮箱字符串
 @return yes or no
 */
+(BOOL)isEmailAddress:(NSString*)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}


/**
 将url分割成字典

 @param str url
 @param separatStr 用什么分割
 @return 字典
 */
+(NSDictionary*)stringChangeToDictionary:(NSString*)str separatStr:(NSString*)separatStr
{
    if (str == nil) {
        return nil;
    }
    str = [self decodeFromPercentEscapeString:str];
    NSMutableDictionary*dic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSArray *strArray = [str componentsSeparatedByString:separatStr];
    for(NSString *tmpStr in strArray)
    {
        if(tmpStr.length>0)
        {
            NSArray *dicStrArray = [tmpStr componentsSeparatedByString:@"&"];
            for(NSString *dicStr in dicStrArray)
            {
                NSArray *keyValueArray = [dicStr componentsSeparatedByString:@"="];
                NSString *key = [keyValueArray.firstObject stringByRemovingPercentEncoding];
                NSString *value = @"";
                if(dicStr.length >= (key.length+1))
                {
                    value = [dicStr substringFromIndex:key.length+1];
                }
                
                [dic setObject:value forKey:key];
                
            }
            
            return dic;
            
            break;
        }
    }
    
    
    return nil;
}



/**
 检查是否为空

 @param key key
 @return bool
 */
+(BOOL)checkNull:(NSString*)key
{
    if(key.length == 0||[key isEqualToString:@"null"]||[key isEqualToString:@"NULL"]||[key isEqualToString:@"<null>"]||[key isEqualToString:@"-"]||[key isEqualToString:@"(null)"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


//url解码
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input

{
    
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    
    [outputStr replaceOccurrencesOfString:@"+"
     
                               withString:@""
     
                                  options:NSLiteralSearch
     
                                    range:NSMakeRange(0,[outputStr length])];
    
    return
    
    [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}



/**
 字典转json

 @param dic 字典
 @return json字符串
 */
+(NSString *)dictionaryConvertToJsonData:(NSDictionary *)dic
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
   // NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    //[mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    //NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
   // [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}




/**
 展示消息
 
 @param messageDic 消息字典
 @param tapBlock   点击回调block [[[messageDic objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"]
 */
+(void)showNavigaitonBarMessage:(NSDictionary *)messageDic tapBlock:(NavigationBarMessageBlock)tapBlock
{
    
//    NSLog(@"messageDic:  %@",messageDic);
    NSDictionary *options = @{
                              kCRToastNotificationTypeKey:@(CRToastTypeNavigationBar),
                              kCRToastNotificationPresentationTypeKey:@(CRToastPresentationTypeCover),
                              kCRToastUnderStatusBarKey:@(YES),
                              kCRToastTimeIntervalKey:@(1),
                              kCRToastTextKey :@"企信宝",
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastFontKey:[UIFont boldSystemFontOfSize:17],
                              kCRToastTextColorKey: KHexRGB(0x333333),
                              kCRToastSubtitleTextKey:[messageDic objectForKey:@"a"]  ,
                              kCRToastSubtitleFontKey:[UIFont systemFontOfSize:15],
                              kCRToastSubtitleTextColorKey: KHexRGB(0x666666),
                              kCRToastSubtitleTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : [KHexRGB(0xffffff) colorWithAlphaComponent:0.8],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationOutTypeKey: @(CRToastAnimationTypeLinear),
                              kCRToastAnimationInDirectionKey : @( CRToastAnimationDirectionTop ),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastNotificationPreferredPaddingKey:
                                  @(5),
                              kCRToastInteractionRespondersKey:@[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap
                                                                                                                 automaticallyDismiss:YES
                                                                                                                                block:^(CRToastInteractionType interactionType){
                                                                                                                                    
                                                                                                            tapBlock(messageDic);
                                                                                                                                     }]],
                              };
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{
                                    NSLog(@"Completed");
                                }];
}



/**
 *  字符串加颜色
 *
 *  @param title title
 *
 *  @return 加颜色的字符串
 */

+(NSMutableAttributedString *)titleNameWithTitle:(NSString *)title otherColor:(UIColor*)otherColor
{
    NSMutableAttributedString *name;
    if(title.length == 0)
    {
        return name;
    }
    
    NSString *coloStr = @"";
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] init];
    
    //    NSMutableString *titleStr = [[NSMutableString alloc]initWithString:@""];
    
    //  NSMutableArray * titleArray = [NSMutableArray arrayWithCapacity:1];
    
    NSArray *backArray = [title componentsSeparatedByString: @"</font>" ];
    if(backArray.count >=2)
    {
        for( NSString *str in backArray)
        {
            NSArray *otherStrArray = [str componentsSeparatedByString: @"<"];
            if(otherStrArray.count >= 2)
            {
                for(int i = 0;i< 2;i++)
                {
                    NSString *other2 = [otherStrArray objectAtIndex:i];
                    if(other2.length != 0)
                    {
                        NSArray *tmpArray = [other2 componentsSeparatedByString: @">"];
                        if(tmpArray.count == 2)
                        {
                            for(int i = 0;i< 2;i++)
                            {
                                NSString *other3 = [tmpArray objectAtIndex:i];
                                NSArray *lastArray = [other3 componentsSeparatedByString: @"'"];
                                if(lastArray.count == 3)
                                {
                                    coloStr = [lastArray objectAtIndex:1];
                                }
                                else
                                {
                                    NSMutableAttributedString *tmpAttriString = [[NSMutableAttributedString alloc] initWithString:other3];
                                    [tmpAttriString addAttribute:NSForegroundColorAttributeName
                                                           value:KHexRGB(0xff772e)
                                                           range:NSMakeRange(0, other3.length)];
                                    [attriString appendAttributedString:tmpAttriString];
                                }
                                
                            }
                        }
                        else
                        {
                            
                            NSMutableAttributedString *tmpAttriString = [[NSMutableAttributedString alloc] initWithString:other2];
                            [tmpAttriString addAttribute:NSForegroundColorAttributeName
                                                   value:otherColor
                                                   range:NSMakeRange(0, other2.length)];
                            [attriString appendAttributedString:tmpAttriString];
                            
                        }
                        
                    }
                    
                }
                
            }
            else
            {
                for(NSString *str in otherStrArray)
                {
                    //NSString *tmpSte = backArray[0];
                    
                    NSMutableAttributedString *tmpAttriString = [[NSMutableAttributedString alloc] initWithString:str ];
                    [tmpAttriString addAttribute:NSForegroundColorAttributeName
                                           value:otherColor
                                           range:NSMakeRange(0, str.length)];
                    [attriString appendAttributedString:tmpAttriString];
                }
            }
            
            
            
            
        }
        
    }
    else
    {
        NSString *tmpSte = backArray[0];
        
        NSMutableAttributedString *tmpAttriString = [[NSMutableAttributedString alloc] initWithString:tmpSte ];
        [tmpAttriString addAttribute:NSForegroundColorAttributeName
                               value:otherColor
                               range:NSMakeRange(0, tmpSte.length)];
        [attriString appendAttributedString:tmpAttriString];
        
    }
    
    
    //if()
    
    
    return attriString;
}


@end
