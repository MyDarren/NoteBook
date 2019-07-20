//
//  main.m
//  ChatServer
//
//  Created by  夏发启 on 16/7/29.
//  Copyright © 2016年  夏发启. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatServer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        ChatServer *chatServer = [[ChatServer alloc] init];
        [chatServer startChatServer];
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
