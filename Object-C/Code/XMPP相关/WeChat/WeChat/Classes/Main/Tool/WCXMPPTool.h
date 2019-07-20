//
//  WCXMPPTool.h
//  WeChat
//
//  Created by  夏发启 on 16/8/10.
//  Copyright © 2016年  夏发启. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"

typedef enum {
    XMPPResultLoginSuccess,  //登陆成功
    XMPPResultLoginFailture,   //登录失败
    XMPPResultRegisterSuccess,
    XMPPResultRegisterFailture
}XMPPResultType;

//与服务器交互的结果
typedef void(^XMPPResultBlock)(XMPPResultType resultType);

@interface WCXMPPTool : NSObject

singleton_interface(WCXMPPTool)
@property (nonatomic,assign)BOOL isRegister;
//电子名片模块
@property (nonatomic,strong)XMPPvCardTempModule *vCardModule;
//电子名片数据存储
@property (nonatomic,strong)XMPPvCardCoreDataStorage *vCardStorage;
//电子名片头像
@property (nonatomic,strong)XMPPvCardAvatarModule *vCardAvatar;
- (void)xmppLoginWithBlock:(XMPPResultBlock)resultBlock;
- (void)xmppLogout;
- (void)xmppRegisterWithBlock:(XMPPResultBlock)resultBlock;

@end
