//
//  AESEncrypt.h
//  Encrypt
//
//  Created by JUSFOUN on 2017/8/2.
//  Copyright © 2017年 JUSFOUN. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KAESKey @"0123456WhoAreYou"

@interface AESEncrypt : NSObject


/**
 加密

 @param content 需要加密的字符串
 @param key 加密的AESKEY
 @return 加密结果
 */
+ (NSString *)aesEncryptString:(NSString *)content aesKey:(NSString *)key;


/**
 解密

 @param content 需要解密的字符串
 @param key AESKEY
 @return 解密结果
 */
+ (NSString *)aesDecryptString:(NSString *)content aesKey:(NSString *)key;
@end
