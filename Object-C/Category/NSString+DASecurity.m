//
//  NSString+DASecurity.m
//  CategorySet
//
//  Created by apple on 2018/5/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NSString+DASecurity.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

#define FileHashDefaultChunkSizeForReadingData 4096

@implementation NSString (DASecurity)

#pragma mark -Base64编解码
/**
 可以将任意的二进制数据进行Base64编码
 所有的数据都能被编码为只用65个字符就能表示的文本文件。
 65字符：A~Z a~z 0~9 + / =
 对文件进行base64编码后文件数据的变化：编码后的数据~=编码前数据的4/3，会大1/3左右。
 
 命令行进行Base64编码和解码
 编码：base64 123.png -o 123.txt
 解码：base64 123.txt -o test.png -D

 Base64编码原理
 1)将所有字符转化为ASCII码；
 2)将ASCII码转化为8位二进制；
 3)将二进制3个归成一组(不足3个在后边补0)共24位，再拆分成4组，每组6位；
 4)统一在6位二进制前补两个0凑足8位；
 5)将补0后的二进制转为十进制；
 6)从Base64编码表获取十进制对应的Base64编码；
 
 处理过程说明：
 a.转换的时候，将三个byte的数据，先后放入一个24bit的缓冲区中，先来的byte占高位。
 b.数据不足3byte的话，于缓冲区中剩下的bit用0补足。然后，每次取出6个bit，按照其值选择查表选择对应的字符作为编码后的输出。
 c.不断进行，直到全部输入数据转换完成。
 d.如果最后剩下两个输入数据，在编码结果后加1个“=”；
 e.如果最后剩下一个输入数据，编码结果后加2个“=”；
 f.如果没有剩下任何数据，就什么都不要加，这样才可以保证资料还原的正确性
 */
+ (NSString *)base64EncodeString:(NSString *)string {
    //1.先把字符串转换为二进制数据
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //2.对二进制数据进行base64编码，返回编码后的字符串
    //这是苹果已经给我们提供的方法
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (NSString *)base64DecodeString:(NSString *)string {
    //1.将base64编码后的字符串『解码』为二进制数据
    //这是苹果已经给我们提供的方法
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    //2.把二进制数据转换为字符串返回
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark -单向散列函数
/**
 单向散列函数的特点：
 ①加密后密文的长度是定长的
 ②如果明文不一样，那么散列后的结果一定不一样
 ③如果明文一样，那么加密后的密文一定一样（对相同数据加密，加密后的密文一样）
 ④所有的加密算法是公开的
 ⑤不可以逆推反算(最重要的特点)
 ⑥速度非常快
 ⑦可以使用文件管理--辨别是否一致
 
 散列函数应用领域
 1）搜索 多个关键字，先对每个关键字进行散列，然后多个关键字进行或运算，如果值一致则搜索结果一致
 2）版权 对文件进行散列判断该文件是否是正版或原版的
 3）文件完整性验证 对整个文件进行散列，比较散列值判断文件是否完整或被篡改

 */

/**
 对字符串进行MD5加密可以得到一个32个字符的密文
 2）加密之后不能根据密文逆推出明文
 3）MD5已经被破解（暴力破解|碰撞检测）
 注意：MD5破解不代表其可逆，而是一段字符串加密后的密文，可以通过强大运算机计算出另一端字符串加密后可得到相同密文，证明不唯一而破解
 
 MD5加密进阶
 1）先加盐，然后再进行MD5
 2）先乱序，再进行MD5加密
 3）乱序|加盐，多次MD5加密等
 4）使用消息认证机制，即HMAC-MD5-先对密钥进行加密，加密之后进行两次MD5散列
 5）加密命令行
    MD5加密-字符串 $ echo -n "erer" | md5
    MD5加密-文件1 $ md5 erer.png
    SHA1加密： $ echo -n "erer" | openssl sha -sha1
    SHA256 $ echo -n "erer" | openssl sha -sha256
    SHA512 $ echo -n "erer" | openssl sha -sha512
    hmacMD5加密 $ echo -n "erer" |openssl dgst -md5 -hmac "123"
 */
// 散列函数--md5对字符串加密
- (NSString *)md5String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

// 散列函数--sha1对字符串加密
// 已经被破解
- (NSString *)sha1String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(str, (CC_LONG)strlen(str), buffer);
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

// 散列函数--sha256对字符串加密
- (NSString *)sha256String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), buffer);
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

// 散列函数--sha512对字符串加密
- (NSString *)sha512String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(str, (CC_LONG)strlen(str), buffer);
    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

/**
 *消息认证机制（HMAC）简单说明
 
 1）原理
 ①消息的发送者和接收者有一个共享密钥
 ②发送者使用共享密钥对消息加密计算得到MAC值（消息认证码）
 ③消息接收者使用共享密钥对消息加密计算得到MAC值
 ④比较两个MAC值是否一致
 2）使用
 ①客户端需要在发送的时候把（消息）+（消息·HMAC）一起发送给服务器
 ②服务器接收到数据后，对拿到的消息用共享的KEY进行HMAC，比较是否一致，如果一致则信任
 */
// 散列函数--HMAC md5加密
- (NSString *)md5HMACStringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgMD5, keyData, strlen(keyData), strData, strlen(strData), buffer);
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

// 散列函数--HMAC sha1加密
- (NSString *)sha1HMACStringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, keyData, strlen(keyData), strData, strlen(strData), buffer);
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

// 散列函数--HMAC sha256加密
- (NSString *)sha256HMACStringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, keyData, strlen(keyData), strData, strlen(strData), buffer);
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

// 散列函数--HMAC sha512加密
- (NSString *)sha512HMACStringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, keyData, strlen(keyData), strData, strlen(strData), buffer);
    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

// 散列函数--md5对文件加密
- (NSString *)fileMD5Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    CC_MD5_CTX hashCtx;
    CC_MD5_Init(&hashCtx);
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            CC_MD5_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(buffer, &hashCtx);
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

// 散列函数--sha1对文件加密
- (NSString *)fileSHA1Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    CC_SHA1_CTX hashCtx;
    CC_SHA1_Init(&hashCtx);
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            CC_SHA1_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(buffer, &hashCtx);
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

// 散列函数--sha256对文件加密
- (NSString *)fileSHA256Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    CC_SHA256_CTX hashCtx;
    CC_SHA256_Init(&hashCtx);
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            CC_SHA256_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_Final(buffer, &hashCtx);
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

// 散列函数--sha512对文件加密
- (NSString *)fileSHA512Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    CC_SHA512_CTX hashCtx;
    CC_SHA512_Init(&hashCtx);
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            CC_SHA512_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512_Final(buffer, &hashCtx);
    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

/** * 返回二进制 Bytes 流的字符串表示形式
 * @param bytes 二进制 Bytes 数组
 * @param length 数组长度
 * @return 字符串表示形式
 */
- (NSString *)stringFromBytes:(uint8_t *)bytes length:(int)length {
    NSMutableString *strM = [NSMutableString string];
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }
    return [strM copy];
}

#pragma mark -对称加密
/**
对称加密的特点
 1）加密/解密使用相同的密钥
 2）加密和解密的过程是可逆的（明文-》密文-》明文）
 
经典算法
 1）DES 数据加密标准
 2）3DES 使用3个密钥，对消息进行（密钥1·加密）+（密钥2·解密）+（密钥3·加密）
 3）AES 高级加密标准

分组密码简单说明
密码算法可以分为分组密码和流密码两种。
    分组密码：每次只能处理特定长度的一zu数据的一类密码算法。一个分组的比特数量就称之为分组长度。DES和3DES的分组长度都是64比特。即每次只能加密64比特的明文，并生成64比特的密文。AES的分组长度有128比特、192比特和256比特可以选择。
 
        ECB分组模式
        ECB模式的全称为Electronic CodeBook模式。又成为电子密码本模式。
            特点：
            1）使用ECB模式加密的时候，相同的明文分组会被转换为相同的密文分组。
            2）类似于一个巨大的明文分组-》密文分组的对照表。
 
            终端测试命令：
            加密 $ openssl enc -des-ecb -K 616263 -nosalt -in 123.txt -out 123.bin
            解密 $ openssl enc -des-ecb -K 616263 -nosalt -in 123.bin -out 1231.txt -d
 
        CBC分组模式
        CBC模式全称为Cipher Block Chainning模式（密文分组链接模式|电子密码链条）
        特点：在CBC模式中，首先将明文分组与前一个密文分组进行XOR运算，然后再进行加密。
 
        终端命令：
        加密 $ openssl enc -des-cbc -K 616263 -iv 0102030405060708 -nosalt -in a.txt -out a.bin
        解密 $ openssl enc -des-cbc -K 616263 -iv 0102030405060708 -nosalt -in a.bin -out a1.txt -d
 
    流密码：对数据流进行连续处理的一类算法。流密码中一般以1比特、8比特或者是32比特等作为单位俩进行加密和解密。
 
    服务端和客户端必须使用一样的密钥和初始向量IV。
    服务端和客户端必须使用一样的加密模式。
    服务端和客户端必须使用一样的Padding模式。

*/

/**
 * 终端测试指令
 *
 * DES(ECB)加密
 * $ echo -n 520it | openssl enc -des-ecb -K 616263 -nosalt | base64
 *
 * DES(CBC)加密
 * $ echo -n 520it | openssl enc -des-cbc -iv 0102030405060708 -K 616263 -nosalt | base64
 *
 * AES(ECB)加密
 * $ echo -n 520it | openssl enc -aes-128-ecb -K 616263 -nosalt | base64
 *
 * AES(CBC)加密
 * $ echo -n 520it | openssl enc -aes-128-cbc -iv 0102030405060708 -K 616263 -nosalt | base64
 ***********************************************************************
 * DES(ECB)解密
 * $ echo -n VqYjXo2ZlU4= | base64 -D | openssl enc -des-ecb -K 616263 -nosalt -d
 *
 * DES(CBC)解密
 * $ echo -n 7MCnAFj6DpQ= | base64 -D | openssl enc -des-cbc -iv 0102030405060708 -K 616263 -nosalt -d
 *
 * AES(ECB)解密
 * $ echo -n FqRpCOQG9IL2QrKBHhM+fA== | base64 -D | openssl enc -aes-128-ecb -K 616263 -nosalt -d
 *
 * AES(CBC)解密
 * $ echo -n Kd9MN/rNEI40hdLhayPbUw== | base64 -D | openssl enc -aes-128-cbc -iv 0102030405060708 -K 616263 -nosalt -d
 *
 * AES(ECB)解密
 * $ echo -n FqRpCOQG9IL2QrKBHhM+fA== | base64 -D | openssl enc -aes-128-ecb -K 616263 -nosalt -d
 * * AES(CBC)解密
 * $ echo -n Kd9MN/rNEI40hdLhayPbUw== | base64 -D | openssl enc -aes-128-cbc -iv 0102030405060708 -K 616263 -nosalt -d
 *
 * 提示：
 * 1> 加密过程是先加密，再base64编码
 * 2> 解密过程是先base64解码，再解密
 */
+ (NSString *)desEncryptWithPlaintText:(NSString *)plaintText key:(NSString *)keyString{
    return [self desEncryptWithPlaintText:plaintText key:keyString iv:nil];
}

+ (NSString *)desEncryptWithPlaintText:(NSString *)plaintText key:(NSString *)keyString iv:(NSString *)iv{
    return [self encryptWithPlaintText:plaintText key:keyString iv:[iv dataUsingEncoding:NSUTF8StringEncoding] algorithm:kCCAlgorithmDES keySize:kCCKeySizeDES blockSize:kCCBlockSizeDES];
}

+ (NSString *)aesEncryptWithPlaintText:(NSString *)plaintText key:(NSString *)keyString{
    return [self aesEncryptWithPlaintText:plaintText key:keyString iv:nil];
}

+ (NSString *)aesEncryptWithPlaintText:(NSString *)plaintText key:(NSString *)keyString iv:(NSString *)iv{
    return [self encryptWithPlaintText:plaintText key:keyString iv:[iv dataUsingEncoding:NSUTF8StringEncoding] algorithm:kCCAlgorithmAES keySize:kCCKeySizeAES128 blockSize:kCCBlockSizeAES128];
}

+ (NSString *)encryptWithPlaintText:(NSString *)plaintText key:(NSString *)keyString iv:(NSData *)iv algorithm:(uint32_t)algorithm keySize:(int)keySize blockSize:(int)blockSize{
    
    // 设置秘钥
    NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t cKey[keySize];
    bzero(cKey, sizeof(cKey));
    [keyData getBytes:cKey length:keySize];
    
    // 设置iv
    uint8_t cIv[blockSize];
    bzero(cIv, blockSize);
    int option = 0;
    
    /**
     kCCOptionPKCS7Padding CBC 的加密
     kCCOptionPKCS7Padding | kCCOptionECBMode ECB 的加密
     */
    
    if (iv) {
        [iv getBytes:cIv length:blockSize];
        option = kCCOptionPKCS7Padding;
    } else {
        option = kCCOptionPKCS7Padding | kCCOptionECBMode;
    }
    
    // 设置输出缓冲区
    NSData *data = [plaintText dataUsingEncoding:NSUTF8StringEncoding];
    size_t bufferSize = [data length] + blockSize;
    void *buffer = malloc(bufferSize);
    // 开始加密
    size_t encryptedSize = 0;
    /* CCCrypt 对称加密算法的核心函数(加密/解密)
     第一个参数：kCCEncrypt 加密/ kCCDecrypt 解密
     第二个参数：加密算法，默认使用的是 AES/DES
     第三个参数：加密选项 ECB/CBC
     kCCOptionPKCS7Padding CBC 的加密
     kCCOptionPKCS7Padding | kCCOptionECBMode ECB 的加密
     第四个参数：加密密钥
     第五个参数：密钥的长度
     第六个参数：初始向量
     第七个参数：加密的数据
     第八个参数：加密的数据长度
     第九个参数：密文的内存地址
     第十个参数：密文缓冲区的大小
     第十一个参数：加密结果的大小
     */
    CCCryptorStatus cryptStatus = CCCrypt(
        kCCEncrypt,
        algorithm,
        option,
        cKey,
        keySize,
        cIv,
        [data bytes],
        [data length],
        buffer,
        bufferSize,
        &encryptedSize
    );
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
    } else {
        free(buffer);
        NSLog(@"[错误] 加密失败|状态编码: %d", cryptStatus);
    }
    return [result base64EncodedStringWithOptions:0];
}

+ (NSString *)desDecryptWithEncryptText:(NSString *)encryptText key:(NSString *)keyString{
    return [self desDecryptWithEncryptText:encryptText key:keyString iv:nil];
}

+ (NSString *)desDecryptWithEncryptText:(NSString *)encryptText key:(NSString *)keyString iv:(NSString *)iv{
    return [self decryptWithEncryptText:encryptText key:keyString iv:[iv dataUsingEncoding:NSUTF8StringEncoding] algorithm:kCCAlgorithmDES keySize:kCCKeySizeDES blockSize:kCCBlockSizeDES];
}

+ (NSString *)aesDecryptWithEncryptText:(NSString *)encryptText key:(NSString *)keyString{
    return [self aesDecryptWithEncryptText:encryptText key:keyString iv:nil];
}

+ (NSString *)aesDecryptWithEncryptText:(NSString *)encryptText key:(NSString *)keyString iv:(NSString *)iv{
    return [self decryptWithEncryptText:encryptText key:keyString iv:[iv dataUsingEncoding:NSUTF8StringEncoding] algorithm:kCCAlgorithmAES128 keySize:kCCKeySizeAES128 blockSize:kCCBlockSizeAES128];
}

+ (NSString *)decryptWithEncryptText:(NSString *)encryptText key:(NSString *)keyString iv:(NSData *)iv algorithm:(uint32_t)algorithm keySize:(int)keySize blockSize:(int)blockSize{
    
    // 设置秘钥
    NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t cKey[keySize];
    bzero(cKey, sizeof(cKey));
    [keyData getBytes:cKey length:keySize];
    
    // 设置iv
    uint8_t cIv[blockSize];
    bzero(cIv, blockSize);
    int option = 0;
    if (iv) {
        [iv getBytes:cIv length:blockSize];
        option = kCCOptionPKCS7Padding;
    } else {
        option = kCCOptionPKCS7Padding | kCCOptionECBMode;
    }
    
    // 设置输出缓冲区
    NSData *data = [[NSData alloc] initWithBase64EncodedString:encryptText options:0];
    size_t bufferSize = [data length] + blockSize;
    void *buffer = malloc(bufferSize);
    
    // 开始解密
    size_t decryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(
        kCCDecrypt,
        algorithm,
        option,
        cKey,
        keySize,
        cIv,
        [data bytes],
        [data length],
        buffer,
        bufferSize,
        &decryptedSize
    );
    
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
    } else {
        free(buffer);
        NSLog(@"[错误] 解密失败|状态编码: %d", cryptStatus);
    }
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

#pragma mark -非对称加密
/**
 1.非对称加密的特点
    1）使用公钥加密，使用私钥解密
    2）公钥是公开的，私钥保密
    3）加密处理安全，但是性能极差
 
 2.经典算法---RSA
    1）RSA 原理
        1）求N，准备两个质数p和q,N = p x q
        2）求L,L是p-1和q-1的最小公倍数。L = lcm（p-1,q-1）
        3）求E，E和L的最大公约数为1（E和L互质）
        4）求D，E x D mode L = 1
 
    2）RSA加密小实践
        1）p = 17,q = 19 => N = 323
        2）lcm（p-1,q-1）=> lcm（16，18）=> L = 144
        3）gcd（E,L）= 1 => E = 5
        4）E乘以几可以mode L = 1 ? D = 29可以满足
        5）得到公钥为：E = 5,N = 323
        6）得到私钥为：D = 29,N = 323
        7）加密 明文的E次方 mod N = 123的5次方 mod 323 = 225（密文）
        8）解密 密文的D次方 mod N = 225的29次方 mod 323 = 123（明文）
 
 3.openssl生成密钥命令
    生成强度是 512 的 RSA 私钥：$ openssl genrsa -out private.pem 512
    以明文输出私钥内容：$ openssl rsa -in private.pem -text -out private.txt
    校验私钥文件：$ openssl rsa -in private.pem -check
    从私钥中提取公钥：$ openssl rsa -in private.pem -out public.pem -outform PEM -pubout
    以明文输出公钥内容：$ openssl rsa -in public.pem -out public.txt -pubin -pubout -text
    使用公钥加密小文件：$ openssl rsautl -encrypt -pubin -inkey public.pem -in msg.txt -out msg.bin
    使用私钥解密小文件：$ openssl rsautl -decrypt -inkey private.pem -in msg.bin -out a.txt
    将私钥转换成 DER 格式：$ openssl rsa -in private.pem -out private.der -outform der
    将公钥转换成 DER 格式：$ openssl rsa -in public.pem -out public.der -pubin -outform der
 */

/**
 数字签名
 
 1.数字签名的应用场景
    答：需要严格验证发送方身份信息情况
 
 2.数字签名原理
    1）客户端处理
        ①对"消息"进行 HASH 得到 "消息摘要"
        ②发送方使用自己的私钥对"消息摘要" 加密(数字签名)
        ③把数字签名附着在"报文"的末尾一起发送给接收方
    2）服务端处理
        ①对"消息" HASH 得到 "报文摘要"
        ②使用公钥对"数字签名" 解密
        ③对结果进行匹配
 */

/**
 数字证书
 
 1.简单说明
 证书和驾照很相似，里面记有姓名、组织、地址等个人信息，以及属于此人的公钥，并有认证机构施加数字签名,只要看到公钥证书，我们就可以知道认证机构认证该公钥的确属于此人
 
 2.数字证书的内容
    1）公钥
    2）认证机构的数字签名
 
 3.证书的生成步骤
    1）生成私钥 openssl genrsa -out private.pem 1024
    2）创建证书请求 openssl req -new -key private.pem -out rsacert.csr
    3）生成证书并签名，有效期10年 openssl x509 -req -days 3650 -in rsacert.csr -signkey private.pem -out rsacert.crt
    4）将 PEM 格式文件转换成 DER 格式（公钥） openssl x509 -outform der -in rsacert.crt -out rsacert.der
    5）导出P12文件（私钥） openssl pkcs12 -export -out p.p12 -inkey private.pem -in rsacert.crt
 
 4.iOS开发中的注意点
    1）在iOS开发中，不能直接使用 PEM 格式的证书，因为其内部进行了Base64编码，应该使用的是DER的证书，是二进制格式的
    2）OpenSSL默认生成的都是PEM格式的证书
 */

/**
 HTTPS的基本使用
 
 1.https简单说明
    HTTPS（全称：Hyper Text Transfer Protocol over Secure Socket Layer），是以安全为目标的HTTP通道，简单讲是HTTP的安全版。
    即HTTP下加入SSL层，HTTPS的安全基础是SSL，因此加密的详细内容就需要SSL。 它是一个URI scheme（抽象标识符体系），句法类同http:体系。用于安全的HTTP数据传输。
    https:URL表明它使用了HTTP，但HTTPS存在不同于HTTP的默认端口及一个加密/身份验证层（在HTTP与TCP之间）。
 
 2.HTTPS和HTTP的区别主要为以下四点：
    1）https协议需要到ca申请证书，一般免费证书很少，需要交费。
    2）http是超文本传输协议，信息是明文传输，https 则是具有安全性的ssl加密传输协议。
    3）http和https使用的是完全不同的连接方式，用的端口也不一样，前者是80，后者是443。
    4）http的连接很简单，是无状态的；HTTPS协议是由SSL+HTTP协议构建的可进行加密传输、身份认证的网络协议，比http协议安全。
 
 3.简单说明
    1）HTTPS的主要思想是在不安全的网络上创建一安全信道，并可在使用适当的加密包和服务器证书可被验证且可被信任时，对窃听和中间人攻击提供合理的保护。
    2）HTTPS的信任继承基于预先安装在浏览器中的证书颁发机构（如VeriSign、Microsoft等）（意即“我信任证书颁发机构告诉我应该信任的”）。
    3）因此，一个到某网站的HTTPS连接可被信任，如果服务器搭建自己的https 也就是说采用自认证的方式来建立https信道，这样一般在客户端是不被信任的。
    4）所以我们一般在浏览器访问一些https站点的时候会有一个提示，问你是否继续
 
 4.对开发的影响
    4.1 如果是自己使用NSURLSession来封装网络请求，涉及代码如下
    - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"https://www.apple.com"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }];
        [task resume];
    }
 
    只要请求的地址是HTTPS的, 就会调用这个代理方法
    我们需要在该方法中告诉系统, 是否信任服务器返回的证书
    Challenge: 挑战 质问 (包含了受保护的区域)
    protectionSpace : 受保护区域
    NSURLAuthenticationMethodServerTrust : 证书的类型是 服务器信任
    - (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
        // NSLog(@"didReceiveChallenge %@", challenge.protectionSpace);
        NSLog(@"调用了最外层");
        // 1.判断服务器返回的证书类型, 是否是服务器信任
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            NSLog(@"调用了里面这一层是服务器信任的证书");
 
            //NSURLSessionAuthChallengeUseCredential = 0, 使用证书
            //NSURLSessionAuthChallengePerformDefaultHandling = 1, 忽略证书(默认的处理方式)
            //NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2, 忽略书证, 并取消这次请求
            //NSURLSessionAuthChallengeRejectProtectionSpace = 3, 拒绝当前这一次, 下一次再询问
 
            NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust]; completionHandler(NSURLSessionAuthChallengeUseCredential, card);
        }
    }
 
 5.ATS
    1）iOS9中新增App Transport Security（简称ATS）特性, 让原来请求时候用到的HTTP，全部都转向TLS1.2协议进行传输。
    2）这意味着所有的HTTP协议都强制使用了HTTPS协议进行传输。
    3）如果我们在iOS9下直接进行HTTP请求是会报错。系统会告诉我们不能直接使用HTTP进行请求，需要在Info.plist中控制ATS的配置。
        NSAppTransportSecurity是ATS配置的根节点，配置了节点表示告诉系统要走自定义的ATS设置。
        NSAllowsAritraryLoads节点控制是否禁用ATS特性，设置YES就是禁用ATS功能。
    4）有两种解决方法，一种是修改配置信息继续使用以前的设置。
    另一种解决方法是所有的请求都基于基于"TLS 1.2"版本协议。（该方法需要严格遵守官方的规定，如选用的加密算法、证书等）
 
 6.ATS默认的条件
    1)服务器TLS版本至少是1.2版本
    2)连接加密只允许几种先进的加密
    3)证书必须使用SHA256或者更好的哈希算法进行签名，要么是2048位或者更长的RSA密钥，要么就是256位或更长的ECC密钥。
 
    AFSecurityPolicy属性含义如下：
        AFSSLPinningMode SSLPinningMode; //该属性标明了AFSecurityPolicy是以何种方式来验证
        BOOL allowInvalidCertificates; //是否允许不信任的证书通过验证，默认为NO
        BOOL validatesDomainName; //是否验证主机名，默认为YES
 
    AFSSLPinningMode枚举类型值含义如下。
        AFSSLPinningModeNone代表了AFSecurityPolicy不做更严格的验证，"只要是系统信任的证书"就可以通过验证，不过，它受到allowInvalidCertificates和validatesDomainName的影响；
        AFSSLPinningModePublicKey是通过"比较证书当中公钥(PublicKey)部分"来进行验证，通过SecTrustCopyPublicKey方法获取本地证书和服务器证书，然后进行比较，如果有一个相同，则通过验证，此方式主要适用于自建证书搭建的HTTPS服务器和需要较高安全要求的验证；
        AFSSLPinningModeCertificate则是直接将本地的证书设置为信任的根证书，然后来进行判断，并且比较本地证书的内容和服务器证书内容是否相同，来进行二次判断，此方式适用于较高安全要求的验证
    如果HTTPS服务器满足ATS默认的条件，而且SSL证书是通过权威的CA机构认证过的，那么什么都不用做。如果上面的条件中有任何一个不成立，那么都只能修改ATS配置
 
 */
static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

#pragma mark - 使用'.der'公钥文件加密
//加密
+ (NSString *)rsaEncryptString:(NSString *)str publicKeyWithContentsOfFile:(NSString *)path{
    if (!str || !path)
        return nil;
    return [self rsaEncryptString:str publicKeyRef:[self getPublicKeyRefWithContentsOfFile:path]];
}

//获取公钥
+ (SecKeyRef)getPublicKeyRefWithContentsOfFile:(NSString *)filePath{
    
    // 从一个 DER 表示的证书创建一个证书对象
    NSData *certData = [NSData dataWithContentsOfFile:filePath];
    if (!certData) { return nil; }
    
    SecCertificateRef cert = SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)certData);
    if (cert == NULL) {
        NSLog(@"公钥文件错误");
    }
    
    SecKeyRef key = NULL;
    // 包含信任管理信息的结构体
    SecTrustRef trust = NULL;
    SecPolicyRef policy = NULL;
    
    if (cert != NULL) {
        // 返回一个默认 X509 策略的公钥对象，使用之后需要调用 CFRelease 释放
        policy = SecPolicyCreateBasicX509();
        if (policy) {
            // 基于证书和策略创建一个信任管理对象
            if (SecTrustCreateWithCertificates((CFTypeRef)cert, policy, &trust) == noErr) {
                // 信任结果
                SecTrustResultType result;
                // 评估指定证书和策略的信任管理是否有效
                if (SecTrustEvaluate(trust, &result) == noErr) {
                    key = SecTrustCopyPublicKey(trust);
                    if (key == NULL) {
                        NSLog(@"公钥创建失败");
                    }
                }else{
                    NSLog(@"信任评估失败");
                }
            }else{
                NSLog(@"创建信任管理对象失败");
            }
        }
    }
    if (policy) CFRelease(policy);
    if (trust) CFRelease(trust);
    if (cert) CFRelease(cert);
    return key;
}

+ (NSString *)rsaEncryptString:(NSString *)str publicKeyRef:(SecKeyRef)publicKeyRef{
    if(![str dataUsingEncoding:NSUTF8StringEncoding]){
        return nil;
    }
    if(!publicKeyRef){
        return nil;
    }
    NSData *data = [self rsaEncryptData:[str dataUsingEncoding:NSUTF8StringEncoding] withKeyRef:publicKeyRef];
    NSString *ret = base64_encode_data(data); return ret;
}

#pragma mark - 使用'.12'私钥文件解密
//解密
+ (NSString *)rsaDecryptString:(NSString *)str privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password{
    if (!str || !path) return nil;
    if (!password) password = @"";
    return [self rsaDecryptString:str privateKeyRef:[self getPrivateKeyRefWithContentsOfFile:path password:password]];
}

//获取私钥
+ (SecKeyRef)getPrivateKeyRefWithContentsOfFile:(NSString *)filePath password:(NSString*)password{
    
    NSData *p12Data = [NSData dataWithContentsOfFile:filePath];
    if (!p12Data) {
        return nil;
    }
    
    SecKeyRef privateKeyRef = NULL;
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    [options setObject: password forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    // 返回 PKCS #12 格式数据中的标示和证书
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12Data, (__bridge CFDictionaryRef)options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        // 从 PKCS #12 证书中提取标示和证书
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        // 提取私钥
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    return privateKeyRef;
}

+ (NSString *)rsaDecryptString:(NSString *)str privateKeyRef:(SecKeyRef)privKeyRef{
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (!privKeyRef) {
        return nil;
    }
    data = [self rsaDecryptData:data withKeyRef:privKeyRef];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

#pragma mark - 使用公钥字符串加密

/* START: Encryption with RSA public key */

//使用公钥字符串加密
+ (NSString *)rsaEncryptString:(NSString *)str publicKey:(NSString *)pubKey{
    NSData *data = [self rsaEncryptData:[str dataUsingEncoding:NSUTF8StringEncoding] publicKey:pubKey];
    NSString *ret = base64_encode_data(data);
    return ret;
}

+ (NSData *)rsaEncryptData:(NSData *)data publicKey:(NSString *)pubKey{
    if(!data || !pubKey){
        return nil;
    }
    SecKeyRef keyRef = [self addPublicKey:pubKey];
    if(!keyRef){
        return nil;
    }
    return [self rsaEncryptData:data withKeyRef:keyRef];
}

+ (SecKeyRef)addPublicKey:(NSString *)key{
    
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    // Add persistent version of the key to system keychain
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id) kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id) kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int idx = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80)
        idx += c_key[idx] - 0x80 + 1;
    else
        idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] = { 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80)
        idx += c_key[idx] - 0x80 + 1;
    else
        idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return ([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

+ (NSData *)rsaEncryptData:(NSData *)data withKeyRef:(SecKeyRef)keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(
            keyRef,
            kSecPaddingPKCS1,
            srcbuf + idx,
            data_len,
            outbuf,
            &outlen
        );
        
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

/* END: Encryption with RSA public key */

#pragma mark - 使用私钥字符串解密

/* START: Decryption with RSA private key */

//使用私钥字符串解密
+ (NSString *)rsaDecryptString:(NSString *)str privateKey:(NSString *)privKey{
    if (!str) return nil;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self rsaDecryptData:data privateKey:privKey];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

+ (NSData *)rsaDecryptData:(NSData *)data privateKey:(NSString *)privKey{
    if(!data || !privKey){
        return nil;
    }
    SecKeyRef keyRef = [self addPrivateKey:privKey];
    if(!keyRef){
        return nil;
    }
    return [self rsaDecryptData:data withKeyRef:keyRef];
}

+ (SecKeyRef)addPrivateKey:(NSString *)key{
    
    NSRange spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPrivateKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PrivKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
    [privateKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [privateKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)privateKey);
    
    // Add persistent version of the key to system keychain
    [privateKey setObject:data forKey:(__bridge id)kSecValueData];
    [privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id) kSecAttrKeyClass];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id) kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
        
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [privateKey removeObjectForKey:(__bridge id)kSecValueData];
    [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

+ (NSData *)stripPrivateKeyHeader:(NSData *)d_key{
    
    // Skip ASN.1 private key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int idx = 22;  //magic byte at offset 22
    
    if (0x04 != c_key[idx++]) return nil;
    
    //calculate length of the key
    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    
    if (!det) {
        
        c_len = c_len & 0x7f;
    } else {
        
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++; byteCount--;
        }
        c_len = accum;
    }
    // Now make a new NSData from this buffer
    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}

+ (NSData *)rsaDecryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(
            keyRef,
            kSecPaddingNone,
            srcbuf + idx,
            data_len,
            outbuf,
            &outlen
        );
        
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
            
        }else{
            
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ ) {
                if ( outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            [ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        }
    }
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

/* END: Decryption with RSA private key */

#pragma mark -数字签名
//对数据进行sha256签名
+ (NSString *)rsaSHA256SignData:(NSData *)plainData privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password{
    SecKeyRef key = [self getPrivateKeyRefWithContentsOfFile:path password:password];
    return [self rsaSignData:plainData keyRef:key secPadding:kSecPaddingPKCS1SHA256];
}

+ (NSString *)rsaSHA1SignData:(NSData *)plainData privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password{
    SecKeyRef key = [self getPrivateKeyRefWithContentsOfFile:path password:password];
    return [self rsaSignData:plainData keyRef:key secPadding:kSecPaddingPKCS1SHA1];
}

+ (NSString *)rsaSHA256SignData:(NSData *)plainData privateKey:(NSString *)privKey password:(NSString *)password{
    SecKeyRef key = [self addPrivateKey:privKey];
    return [self rsaSignData:plainData keyRef:key secPadding:kSecPaddingPKCS1SHA256];
}

+ (NSString *)rsaSHA1SignData:(NSData *)plainData privateKey:(NSString *)privKey password:(NSString *)password{
    SecKeyRef key = [self addPrivateKey:privKey];
    return [self rsaSignData:plainData keyRef:key secPadding:kSecPaddingPKCS1SHA1];
}

//这边对签名的数据进行验证 验签成功，则返回YES
+ (BOOL)rsaSHA256VerifyData:(NSData *)plainData publicKeyWithContentsOfFile:(NSString *)path signature:(NSString *)signature{
    SecKeyRef key = [self getPublicKeyRefWithContentsOfFile:path];
    return [self rsaVerifyData:plainData keyRef:key signature:signature secPadding:kSecPaddingPKCS1SHA256];
}

+ (BOOL)rsaSHA1VerifyData:(NSData *)plainData publicKeyWithContentsOfFile:(NSString *)path signature:(NSString *)signature{
    SecKeyRef key = [self getPublicKeyRefWithContentsOfFile:path];
    return [self rsaVerifyData:plainData keyRef:key signature:signature secPadding:kSecPaddingPKCS1SHA1];
}

+ (BOOL)rsaSHA256VerifyData:(NSData *)plainData publicKey:(NSString *)pubKey signature:(NSString *)signature{
    SecKeyRef key = [self addPublicKey:pubKey];
    return [self rsaVerifyData:plainData keyRef:key signature:signature secPadding:kSecPaddingPKCS1SHA256];
}

+ (BOOL)rsaSHA1VerifyData:(NSData *)plainData publicKey:(NSString *)pubKey signature:(NSString *)signature{
    SecKeyRef key = [self addPublicKey:pubKey];
    return [self rsaVerifyData:plainData keyRef:key signature:signature secPadding:kSecPaddingPKCS1SHA1];
}

+ (NSString *)rsaSignData:(NSData *)plainData keyRef:(SecKeyRef)privateKey secPadding:(SecPadding)secPadding{
    
    size_t signedHashBytesSize = SecKeyGetBlockSize(privateKey);
    uint8_t *signedHashBytes = malloc(signedHashBytesSize);
    memset(signedHashBytes, 0x0, signedHashBytesSize);
    
    size_t hashBytesSize = CC_SHA1_DIGEST_LENGTH;
    
    if (secPadding == kSecPaddingPKCS1SHA1) {
        hashBytesSize = CC_SHA1_DIGEST_LENGTH;
    }else if (secPadding == kSecPaddingPKCS1SHA256){
        hashBytesSize = CC_SHA256_DIGEST_LENGTH;
    }
    
    uint8_t* hashBytes = malloc(hashBytesSize);
    
    if (secPadding == kSecPaddingPKCS1SHA1) {
        if (!CC_SHA1([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
            return nil;
        }
    }else if (secPadding == kSecPaddingPKCS1SHA256){
        if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
            return nil;
        }
    }
    
    SecKeyRawSign(
        privateKey,
        secPadding,
        hashBytes,
        hashBytesSize,
        signedHashBytes,
        &signedHashBytesSize
    );
    
    NSData* signedHash = [NSData dataWithBytes:signedHashBytes length:(NSUInteger)signedHashBytesSize];
    
    if (hashBytes)
        free(hashBytes);
    if (signedHashBytes)
        free(signedHashBytes);
    return base64_encode_data(signedHash);
}

+ (BOOL)rsaVerifyData:(NSData *)plainData keyRef:(SecKeyRef)publicKey signature:(NSString *)signature secPadding:(SecPadding)secPadding{
    
    NSData *signatureData = base64_decode(signature);
    
    size_t signedHashBytesSize = SecKeyGetBlockSize(publicKey);
    const void *signedHashBytes = [signatureData bytes];
    
    size_t hashBytesSize = CC_SHA1_DIGEST_LENGTH;
    
    if (secPadding == kSecPaddingPKCS1SHA1) {
        hashBytesSize = CC_SHA1_DIGEST_LENGTH;
    }else if (secPadding == kSecPaddingPKCS1SHA256){
        hashBytesSize = CC_SHA256_DIGEST_LENGTH;
    }
    
    uint8_t *hashBytes = malloc(hashBytesSize);
    
    if (secPadding == kSecPaddingPKCS1SHA1) {
        if (!CC_SHA1([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
            return nil;
        }
    }else if (secPadding == kSecPaddingPKCS1SHA256){
        if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
            return nil;
        }
    }
    
    OSStatus status = SecKeyRawVerify(
        publicKey,
        secPadding,
        hashBytes,
        hashBytesSize,
        signedHashBytes,
        signedHashBytesSize
    );
    
    return status == errSecSuccess;
}

@end
