//
//  WCXMPPTool.m
//  WeChat
//
//  Created by  夏发启 on 16/8/10.
//  Copyright © 2016年  夏发启. All rights reserved.
//

#import "WCXMPPTool.h"

@interface WCXMPPTool ()<XMPPStreamDelegate>

@property (nonatomic,strong)XMPPStream *xmppStream;
@property (nonatomic,copy)XMPPResultBlock resultBlock;

@end

@implementation WCXMPPTool

singleton_implementation(WCXMPPTool)

#pragma mark -1、初始化XMPPStream
- (void)setupScream{
    self.xmppStream = [[XMPPStream alloc] init];
    //设置代理，使用全局队列则代理方法将在子线程调用
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    //添加XMPP模块
    //1、添加电子名片模块
    self.vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    self.vCardModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:self.vCardStorage];
    //激活
    [self.vCardModule activate:self.xmppStream];
    //2、添加头像
    self.vCardAvatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:self.vCardModule];
    [self.vCardAvatar activate:self.xmppStream];
}

#pragma mark -2、连接到服务器
- (void)connectToHost{
    if (_xmppStream == nil) {
        [self setupScream];
    }
    //NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString *user = nil;
    WCAccount *account = [WCAccount shareAccount];
    if (self.isRegister) {
        user = account.registerUserName;
    }else{
        user = account.loginUserName;
    }
    //1、设置jid
    XMPPJID *myGid = [XMPPJID jidWithUser:user domain:account.domain resource:@"iphone"];
    self.xmppStream.myJID = myGid;
    self.xmppStream.hostName = account.host;
    self.xmppStream.hostPort = account.port;
    NSError *error;
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        WCLog(@"%@",error);
    }else{
        WCLog(@"发起连接成功");
    }
}

#pragma mark -3、连接成功，发送密码
- (void)sendPwdToHost{
    NSError *error;
    //NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    NSString *pwd = [WCAccount shareAccount].loginPassword;
    [self.xmppStream authenticateWithPassword:pwd error:&error];
    if (error) {
        WCLog(@"%@",error);
    }
}

#pragma mark -发送"在线消息"给服务器，默认登录成功是不在线的，可以通知其他用户你在线
- (void)sendOnLine{
    //XMPP框架已经将所有指令封装成框架
    XMPPPresence *presence = [XMPPPresence presence];
    [self.xmppStream sendElement:presence];
}

#pragma mark -发送"离线消息"给服务器
- (void)sentOffLine{
    XMPPPresence *offPresence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:offPresence];
}

#pragma mark -连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    if (self.isRegister) {
        NSString *registerPwd = [WCAccount shareAccount].registerPassword;
        NSError *error;
        [self.xmppStream registerWithPassword:registerPwd error:&error];
        if (error) {
            WCLog(@"%@",error);
        }
    }else{
        [self sendPwdToHost];
    }
}

#pragma mark -与服务器断开连接
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    WCLog(@"%@",error);
}

#pragma mark -登录成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    WCLog(@"登录成功");
    if (self.resultBlock) {
        self.resultBlock(XMPPResultLoginSuccess);
    }
    //第二种方式在block使用完成时将其置为nil
    //self.resultBlock = nil;
    [self sendOnLine];
}

#pragma mark -登录失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    WCLog(@"登录失败");
    if (self.resultBlock) {
        self.resultBlock(XMPPResultLoginFailture);
    }
    //第二种方式在block使用完成时将其置为nil
    //self.resultBlock = nil;
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    WCLog(@"%@",error);
    if (self.resultBlock) {
        self.resultBlock(XMPPResultRegisterFailture);
    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    WCLog(@"注册成功");
    if (self.resultBlock) {
        self.resultBlock(XMPPResultRegisterSuccess);
    }
}

- (void)xmppLoginWithBlock:(XMPPResultBlock)resultBlock{
    //Error Domain=XMPPStreamErrorDomain Code=1 "Attempting to connect while already connected or connecting." UserInfo={NSLocalizedDescription=Attempting to connect while already connected or connecting.}
    [self.xmppStream disconnect];
    self.resultBlock = resultBlock;
    [self connectToHost];
}

- (void)xmppRegisterWithBlock:(XMPPResultBlock)resultBlock{
    [self.xmppStream disconnect];
    self.resultBlock = resultBlock;
    [self connectToHost];
}

- (void)xmppLogout{
    //1、发送离线消息给服务器
    [self sentOffLine];
    //2、断开与服务器的连接
    [self.xmppStream disconnect];
}

- (void)teardownStream{
    //移除代理
    [self.xmppStream removeDelegate:self];
    //取消模块
    [self.vCardModule deactivate];
    [self.vCardModule deactivate];
    //断开连接
    [self.xmppStream disconnect];
    //清空资源
    self.vCardModule = nil;
    self.vCardStorage = nil;
    self.vCardAvatar = nil;
    self.xmppStream = nil;
}

- (void)dealloc{
    [self teardownStream];
}

@end
