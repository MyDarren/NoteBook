//
//  NSString+DASecurity.h
//  CategorySet
//
//  Created by apple on 2018/5/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DASecurity)

#pragma mark -Base64编解码
//Base64编码
+ (NSString *)base64EncodeString:(NSString *)string;
//Base64解码
+ (NSString *)base64DecodeString:(NSString *)string;

#pragma mark -单向散列函数
// 散列函数--md5对字符串加密
- (NSString *)md5String;
// 散列函数--sha1对字符串加密
- (NSString *)sha1String;
// 散列函数--sha256对字符串加密
- (NSString *)sha256String;
// 散列函数--sha512对字符串加密
- (NSString *)sha512String;

// 散列函数--HMAC md5加密
- (NSString *)md5HMACStringWithKey:(NSString *)key;
// 散列函数--HMAC sha1加密
- (NSString *)sha1HMACStringWithKey:(NSString *)key;
// 散列函数--HMAC sha256加密
- (NSString *)sha256HMACStringWithKey:(NSString *)key;
// 散列函数--HMAC sha512加密
- (NSString *)sha512HMACStringWithKey:(NSString *)key;

// 散列函数--md5对文件加密
- (NSString *)fileMD5Hash;
// 散列函数--sha1对文件加密
- (NSString *)fileSHA1Hash;
// 散列函数--sha256对文件加密
- (NSString *)fileSHA256Hash;
// 散列函数--sha512对文件加密
- (NSString *)fileSHA512Hash;

#pragma mark -对称加密
/**
 加密字符串并返回base64编码字符串
 plaintText 要加密的字符串
 keyString 加密密钥
 iv 初始化向量(8个字节)
 返回加密后的base64编码字符串
 */
// DES加密
+ (NSString *)desEncryptWithPlaintText:(NSString *)plaintText key:(NSString *)keyString;
+ (NSString *)desEncryptWithPlaintText:(NSString *)plaintText key:(NSString *)keyString iv:(NSString *)iv;

// AES加密
+ (NSString *)aesEncryptWithPlaintText:(NSString *)plaintText key:(NSString *)keyString;
+ (NSString *)aesEncryptWithPlaintText:(NSString *)plaintText key:(NSString *)keyString iv:(NSString *)iv;

/**
 解密字符串
 encryptText 加密并base64编码后的字符串
 keyString 解密密钥
 iv 初始化向量(8个字节)
 返回解密后的字符串
 */
// DES解密
+ (NSString *)desDecryptWithEncryptText:(NSString *)encryptText key:(NSString *)keyString;
+ (NSString *)desDecryptWithEncryptText:(NSString *)encryptText key:(NSString *)keyString iv:(NSString *)iv;
// AES解密
+ (NSString *)aesDecryptWithEncryptText:(NSString *)encryptText key:(NSString *)keyString;
+ (NSString *)aesDecryptWithEncryptText:(NSString *)encryptText key:(NSString *)keyString iv:(NSString *)iv;

#pragma mark -非对称加密
/**
 * 加密方法
 *
 * @param str 需要加密的字符串
 * @param path '.der'格式的公钥文件路径
 */
+ (NSString *)rsaEncryptString:(NSString *)str publicKeyWithContentsOfFile:(NSString *)path;

/**
 * 解密方法
 *
 * @param str 需要解密的字符串
 * @param path '.p12'格式的私钥文件路径
 * @param password 私钥文件密码
 */
+ (NSString *)rsaDecryptString:(NSString *)str privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password;

/**
 * 加密方法
 *
 * @param str 需要加密的字符串
 * @param pubKey 公钥字符串
 */
+ (NSString *)rsaEncryptString:(NSString *)str publicKey:(NSString *)pubKey;

/**
 * 解密方法
 *
 * @param str 需要解密的字符串
 * @param privKey 私钥字符串
 */
+ (NSString *)rsaDecryptString:(NSString *)str privateKey:(NSString *)privKey;

#pragma mark -数字签名

/**
 * 签名
 *
 * @param plainData 需要签名的数据
 * @param path      '.p12'格式的私钥文件路径
 * @param password  私钥文件密码
 */
+ (NSString *)rsaSHA256SignData:(NSData *)plainData privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password;

+ (NSString *)rsaSHA1SignData:(NSData *)plainData privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password;

/**
 * 签名
 *
 * @param plainData 需要签名的数据
 * @param privKey   私钥字符串
 * @param password  私钥文件密码
 */
+ (NSString *)rsaSHA256SignData:(NSData *)plainData privateKey:(NSString *)privKey password:(NSString *)password;

+ (NSString *)rsaSHA1SignData:(NSData *)plainData privateKey:(NSString *)privKey password:(NSString *)password;

/**
 * 校验签名
 *
 * @param plainData  需要签名的数据
 * @param path       '.der'格式的公钥文件路径
 * @param signature  签名值
 */
+ (BOOL)rsaSHA256VerifyData:(NSData *)plainData publicKeyWithContentsOfFile:(NSString *)path signature:(NSString *)signature;

+ (BOOL)rsaSHA1VerifyData:(NSData *)plainData publicKeyWithContentsOfFile:(NSString *)path signature:(NSString *)signature;

/**
 * 校验签名
 *
 * @param plainData  需要签名的数据
 * @param pubKey     公钥字符串
 * @param signature  签名值
 */
+ (BOOL)rsaSHA256VerifyData:(NSData *)plainData publicKey:(NSString *)pubKey signature:(NSString *)signature;

+ (BOOL)rsaSHA1VerifyData:(NSData *)plainData publicKey:(NSString *)pubKey signature:(NSString *)signature;

@end
