//
//  WCAccount.h
//  WeChat
//
//  Created by  夏发启 on 16/8/9.
//  Copyright © 2016年  夏发启. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCAccount : NSObject

@property (nonatomic,copy)NSString *loginUserName;
@property (nonatomic,copy)NSString *loginPassword;
@property (nonatomic,assign)BOOL isLogin;
@property (nonatomic,copy)NSString *registerUserName;
@property (nonatomic,copy)NSString *registerPassword;
@property (nonatomic,copy)NSString *domain;
@property (nonatomic,copy)NSString *host;
@property (nonatomic,assign)NSInteger port;

+ (instancetype)shareAccount;
- (void)saveToSandBox;

@end
