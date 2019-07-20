//
//  ViewController.m
//  NSOperation
//
//  Created by Darren on 16/3/4.
//  Copyright © 2016年 Darren. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong)NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self invocationOperationOne];
//    [self invocationOperationTwo];
//    [self blockOperationOne];
//    [self blockOperationTwo];
//    [self operationConnect];
    [self maxConcurrentOperationCount];
//    [self dependecy];
}

/*
 NSOperation是一个抽象类，不具备封装操作的能力，必须使用它的子类
 NSOperation的子类:
 NSInvocationOperation
 NSBlockOperation
 自定义子类继承NSOperation，实现内部相应方法
 */

#pragma mark -单个NSInvocationOperation使用
- (void)invocationOperationOne{
    //创建操作
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage) object:nil];
    //启动，在当前线程执行
    //默认情况下，调用start方法并不会开辟新线程执行操作，而是在当前线程同步执行操作
    //创建队列，只有把操作放到队列中，才会自动异步执行操作
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

#pragma mark -多个NSInvocationOperation使用
- (void)invocationOperationTwo{
    //操作就是GCD中异步执行的任务
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    for (int i = 0; i < 10; i++) {
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage) object:nil];
        [queue addOperation:operation];
    }
}

#pragma mark -NSBlockOperation使用
- (void)blockOperationOne{
    //相当于GCD中的并发队列
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //主队列，跟GCD中的主队列一样
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    for (int i = 0; i < 10; i++) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"---%@---%d",[NSThread currentThread],i);
        }];
        [queue addOperation:operation];
    }
    NSLog(@"完成");
}

#pragma mark -NSBlockOperation更简单使用
- (void)blockOperationTwo{
    //只要是NSOperation的子类，就能添加到队列中
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    for (int i = 0; i < 10; i++) {
        [queue addOperationWithBlock:^{
            NSLog(@"---%@---%d",[NSThread currentThread],i);
        }];
    }
    NSBlockOperation *operationOne = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"BlockOperation--%@--",[NSThread currentThread]);
    }];
    [operationOne addExecutionBlock:^{
        NSLog(@"operationOne---%@---",[NSThread currentThread]);
    }];
    [queue addOperation:operationOne];
    NSInvocationOperation *operationTwo = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage) object:nil];
    [queue addOperation:operationTwo];
}

#pragma mark -线程通信
- (void)operationConnect{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSLog(@"耗时操作...%@",[NSThread currentThread]);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"更新UI...%@",[NSThread currentThread]);
        }];
    }];
}

#pragma mark -最大并发数
- (void)maxConcurrentOperationCount{
    //设置最大并发数
    //最大并发数不是线程的个数，而是同时执行的操作的数量
    //任务刚执行完的时候，线程会有一个回收到线程池，在拿出来使用的过程，所以这个时候，线程池里如果还有其他线程，就直接拿来使用
    self.queue.maxConcurrentOperationCount = 2;
    for (int i = 0; i < 20; i++) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            [NSThread sleepForTimeInterval:3.0];
            NSLog(@"--%@--%d",[NSThread currentThread],i);
        }];
        [self.queue addOperation:operation];
    }
}

#pragma mark -依赖关系
- (void)dependecy{
    /*
     例子:
     1、下载一个小说的压缩包
     2、解压缩，删除压缩包
     3、更新UI
     */
    NSBlockOperation *blockOperationOne = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1、下载小说--%@--",[NSThread currentThread]);
    }];
    NSBlockOperation *blockOperationTwo = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2、解压缩--%@--",[NSThread currentThread]);
    }];
    NSBlockOperation *blockOperationThree = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3、更新UI--%@--",[NSThread currentThread]);
    }];
    //指定队列之间的依赖关系，依赖关系可以跨队列(在主线程下载完，到主线程更新UI)
    [blockOperationTwo addDependency:blockOperationOne];
    [blockOperationThree addDependency:blockOperationTwo];
    //注意：一定不能出现循环依赖关系
    //[blockOperationOne addDependency:blockOperationThree];
    // waitUntilFinished 类似GCD的调度组的通知
    // NO 不等待，会直接执行NSLog(@"come here");
    // YES 等待上面的操作执行结束，再执行NSLog(@"hello,world");
    [self.queue addOperations:@[blockOperationOne,blockOperationTwo] waitUntilFinished:YES];
    [[NSOperationQueue mainQueue] addOperation:blockOperationThree];
    NSLog(@"hello,world");
}

- (NSOperationQueue *)queue{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

#pragma mark -全部取消
//取消队列里的所有操作
- (IBAction)cancelAll:(id)sender{
    [self.queue cancelAllOperations];  //会把任务从队列中全部删除
    NSLog(@"取消全部");
    //取消操作不会影响队列的挂起状态
    //取消队列的挂起状态
    self.queue.suspended = NO;
}

#pragma mark -挂起
//对队列的暂停和继续
- (IBAction)buttonClick{
    //判断操作的数量
    if (self.queue.operationCount == 0) {
        NSLog(@"没有操作");
        return;
    }
    self.queue.suspended = !self.queue.suspended;
    if (self.queue.suspended) {  //队列挂起以后，队列里面的操作还在
        NSLog(@"暂停");
    }else
        NSLog(@"继续");
}

- (void)downloadImage{
    NSLog(@"download---%@---",[NSThread currentThread]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
