//
//  ChatServer.m
//  ChatServer
//
//  Created by  夏发启 on 16/7/29.
//  Copyright © 2016年  夏发启. All rights reserved.
//

#import "ChatServer.h"
#import "GCDAsyncSocket.h"

@interface ChatServer ()<GCDAsyncSocketDelegate>

@property (nonatomic,strong)GCDAsyncSocket *socket;
@property (nonatomic,strong)dispatch_queue_t globalQueue;
@property (nonatomic,strong)NSMutableArray *clientSocket;

@end

@implementation ChatServer

- (NSMutableArray *)clientSocket{
    if (_clientSocket == nil) {
        _clientSocket = [NSMutableArray array];
    }
    return _clientSocket;
}

- (instancetype)init{
    if (self = [super init]) {
        self.globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //1、创建服务端的socket
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.globalQueue];
    }
    return self;
}

- (void)startChatServer{
    //2、打开监听端口
    NSError *error;
    [self.socket acceptOnPort:12345 error:&error];
    if (error) {
        NSLog(@"服务开启失败");
    }else{
        NSLog(@"服务开启成功");
    }
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    /*
     sock:服务器的socket
     newSocket:客户端的socket
     */
    NSLog(@"%s",__func__);
    NSLog(@"sock:%p--newSocket:%p",sock,newSocket);
    [self.clientSocket addObject:newSocket];
    //sock 服务端的socket 服务端的socket只负责客户端的连接，不负责数据的读取
    //先读取数据
    [newSocket readDataWithTimeout:-1 tag:100];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    [sock readDataWithTimeout:-1 tag:100];
}

#pragma mark -接收客户端发过来的数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    /*
     sock:客户端的socket
     */
    NSLog(@"%p",sock);
    NSString *receiveString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"length:%ld",receiveString.length);
    receiveString = [receiveString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    receiveString = [receiveString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if ([receiveString hasPrefix:@"iam:"]) {
        NSString *userName = [receiveString componentsSeparatedByString:@":"][1];
        NSString *responseString = [NSString stringWithFormat:@"%@has joined",userName];
        [sock writeData:[responseString dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    }
    if ([receiveString hasPrefix:@"msg:"]) {
        NSString *messageString = [receiveString componentsSeparatedByString:@":"][1];
        [sock writeData:[messageString dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    }
    if ([receiveString isEqualToString:@"quit"]) {
        //断开连接
        [sock disconnect];
        [self.clientSocket removeObject:sock];
    }
    NSLog(@"%s",__func__);
}

@end
