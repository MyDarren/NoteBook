//
//  WCAccount.m
//  WeChat
//
//  Created by  夏发启 on 16/8/9.
//  Copyright © 2016年  夏发启. All rights reserved.
//

#import "WCAccount.h"

#define kUserKey @"user"
#define kPwdKey @"pwd"
#define kLoginKey @"isLogin"

static NSString *domain = @"127.0.0.1";
static NSString *host = @"127.0.0.1";
static NSInteger port = 5222;

@implementation WCAccount

+ (instancetype)shareAccount{
    static WCAccount *account = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = [[WCAccount alloc] init];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        account.loginUserName = [defaults objectForKey:kUserKey];
        account.loginPassword = [defaults objectForKey:kPwdKey];
        account.isLogin = [defaults boolForKey:kLoginKey];
    });
    return account;
}

- (void)saveToSandBox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.loginUserName forKey:kUserKey];
    [defaults setObject:self.loginPassword forKey:kPwdKey];
    [defaults setBool:self.isLogin forKey:kLoginKey];
    [defaults synchronize];
}

- (NSString *)domain{
    return domain;
}

- (NSString *)host{
    return host;
}

- (NSInteger)port{
    return port;
}

@end
