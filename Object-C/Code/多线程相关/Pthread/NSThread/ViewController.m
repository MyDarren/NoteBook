//
//  ViewController.m
//  NSThread
//
//  Created by Darren on 16/2/29.
//  Copyright © 2016年 Darren. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,assign)int ticketCount;
@property (nonatomic,strong)NSLock *lock;
//atomic，原子属性，默认属性
//针对多线程设计，原子属性实现单写多读
@property (atomic,strong)NSObject *obj;

@end

@implementation ViewController

 /*
 线程安全:在多个线程同时执行的时候，能够保证资源信息的准确性
 UIKit中绝大多数的类，都不是线程安全的
 为解决线程不安全的问题，苹果约定，所有程序更新UI的操作都是在主线程进行，也就不会出现多个线程同时改变同一资源
 在主线程中更新UI有什么好处:
 1.只在主线程中更新UI，就不会出现多个线程同时改变同一UI控件
 2.主线程的优先级最高，因而UI更新的优先级更高，使用户感觉流畅
 */


//如果同时重写setter和getter方法，"_成员变量"不会生成
//可以使用@synthesize合成指令，告诉编译器属性的名称
@synthesize obj = _obj;

//atomic情况下，只要重写了setter方法，getter方法也必须重写；如果重写了getter方法，setter方法也必须重写
- (NSObject *)obj{
    return _obj;
}

//只锁住setter方法，不会锁住getter方法
- (void)setObj:(NSObject *)obj{
    //原子属性内部使用的是自旋锁，比互斥锁性能高
    //自旋锁和互斥锁:
    //共同点:都可以锁定一段代码，同一时间，只有同一个线程能够执行这段锁定的代码
    //区别:互斥锁，在锁定的时候，其他线程睡眠等待条件满足，再唤醒
    //自旋锁，在锁定的时候，其他线程会做死循环，一直等待条件满足，一旦条件满足，立即执行，少了一个唤醒过程
    @synchronized(self) {  //模拟锁，真实情况下不是互斥锁
        _obj = obj;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.ticketCount = 20;
    NSThread *threadA = [[NSThread alloc] initWithTarget:self selector:@selector(sellTickets) object:nil];
    threadA.name = @"threadA";
    [threadA start];
    
    NSThread *threadB = [[NSThread alloc] initWithTarget:self selector:@selector(sellTickets) object:nil];
    threadB.name = @"threadB";
    [threadB start];
    
    _lock = [[NSLock alloc] init];
}

- (void)sellTickets{
    while (1) {
        [NSThread sleepForTimeInterval:1.0];
        /*
         加锁，互斥锁
         加锁，锁定的代码范围尽量小
         加锁范围内的代码，同一时间内只允许一个线程执行
         互斥锁的参数，任何继承自NSObject *的对象都可以
         要保证这个锁，所有线程都能够访问，并且要保证所有线程访问的都是同一个锁对象这种方式无效
         NSObject *objc = [[NSObject alloc] init];
         @synchronized(objc)
         
         */
        
        @synchronized(self) {  //开发的时候一般使用self就可以了
            if (self.ticketCount > 0) {
                self.ticketCount--;
                NSLog(@"%@--余票:%d张",[NSThread currentThread],self.ticketCount);
            }else{
                NSLog(@"没票了");
                break;
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
