//
//  NSString+DADeviceID.m
//  CategorySet
//
//  Created by test on 2018/7/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NSString+DADeviceID.h"
#import "NSString+DASecurity.h"
#import "DASSKeychain.h"
#import <UIKit/UIKit.h>

#define KeychainDeviceUUID @"keychainDeviceUUID"
#define KeychainServiceAccount [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"]
#define KeychainServicePassword @"KeychainServicePassword"

@implementation NSString (DADeviceID)

+ (NSString *)getDeviceIDFA{
    NSString *idfa = nil;
    Class ASIdentifierManagerClass = NSClassFromString(@"ASIdentifierManager");
    if (ASIdentifierManagerClass) { // a dynamic way of checking if AdSupport.framework is available
        SEL sharedManagerSelector = NSSelectorFromString(@"sharedManager");
        id sharedManager = ((id (*)(id, SEL))[ASIdentifierManagerClass methodForSelector:sharedManagerSelector])(ASIdentifierManagerClass, sharedManagerSelector);
        SEL advertisingIdentifierSelector = NSSelectorFromString(@"advertisingIdentifier");
        NSUUID *advertisingIdentifier = ((NSUUID* (*)(id, SEL))[sharedManager methodForSelector:advertisingIdentifierSelector])(sharedManager, advertisingIdentifierSelector);
        idfa = [advertisingIdentifier UUIDString];
    }
    return idfa;
}

+ (NSString *)getDeviceUUID{
    NSString *openUUID = [[NSUserDefaults standardUserDefaults] objectForKey:KeychainDeviceUUID];
    if (openUUID == nil) {
        
        CFUUIDRef puuid = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault,puuid);
        NSString *udidStr = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        openUUID = [udidStr md5String];
        
        NSString *uniqueKeyItem = [DASSKeychain  passwordForService:KeychainServiceAccount account:KeychainServicePassword];
        if (uniqueKeyItem == nil || [uniqueKeyItem length] == 0) {
            uniqueKeyItem = openUUID;
            [DASSKeychain setPassword:openUUID forService:KeychainServiceAccount account:KeychainServicePassword];
        }
        [[NSUserDefaults standardUserDefaults] setObject:uniqueKeyItem forKey:KeychainDeviceUUID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        openUUID = uniqueKeyItem;
    }
    return openUUID;
}

+ (NSString *)getDeviceIDFV{
    if(NSClassFromString(@"UIDevice") && [UIDevice instancesRespondToSelector:@selector(identifierForVendor)]){
        // only available in iOS >= 6.0
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    return nil;
}

//如果以上的都不支持,使用CFUUIDRef手动创建UUID
+ (NSString *)randomUUID{
    if(NSClassFromString(@"NSUUID")) { // only available in iOS >= 6.0
        return [[NSUUID UUID] UUIDString];
    }
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfuuid = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    CFRelease(uuidRef);
    NSString *uuid = [((__bridge NSString *) cfuuid) copy];
    CFRelease(cfuuid);
    return uuid;
}

//添加到Keychain
+ (void)setValue:(NSString *)value forKey:(NSString *)key inService:(NSString *)service {
    NSMutableDictionary *keychainItem = [[NSMutableDictionary alloc] init];
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlways;
    keychainItem[(__bridge id)kSecAttrAccount] = key;
    keychainItem[(__bridge id)kSecAttrService] = service;
    keychainItem[(__bridge id)kSecValueData] = [value dataUsingEncoding:NSUTF8StringEncoding];
    SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
}

@end
