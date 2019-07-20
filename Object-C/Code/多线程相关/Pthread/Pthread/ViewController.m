//
//  ViewController.m
//  Pthread
//
//  Created by Darren on 16/2/29.
//  Copyright © 2016年 Darren. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self test];
}

void *run(void *param){
    NSString *str = (__bridge NSString *)(param);
    for (int i = 0; i < 10000; i++) {
        NSLog(@"%@--%@",[NSThread currentThread],str);
    }
    return NULL;
}

- (void)test{
    //声明一个线程变量
    pthread_t threadId;
    /*
     参数一:要开辟的线程变量
     参数二:线程的属性
     参数三:在这个子线程中要执行的函数
     参数四:执行这个函数需要传递的参数
     */
//    pthread_create(<#pthread_t *restrict#>, <#const pthread_attr_t *restrict#>, <#void *(*)(void *)#>, <#void *restrict#>)
    id str = @"hello world!";
    //id需要转换成void *
    //(__bridge void *)(str) 这里只是临时把str对象转换成void *，不改变对象的所有权
    //CFBridgingRetain(str) 把对象的所有权交出去，在这个函数中把str转成void *
    //在MRC中，不需要进行桥联，可以直接设置这个参数
    pthread_create(&threadId, NULL, run, (__bridge void *)(str));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
