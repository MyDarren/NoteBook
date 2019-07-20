//
//  ViewController.m
//  GCD
//
//  Created by Darren on 16/3/3.
//  Copyright © 2016年 Darren. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self gcdTestOne];
//    [self gcdTestTwo];
//    [self gcdTestThree];
//    [self gcdTestFour];
//    [self gcdTestFive];
//    [self gcdTestSix];
//    [self gcdTestSeven];
//    [self gcdTestEight];
//    [self downloadImage];
//    [self gcdTestNine];
//    [self gcdTestTen];
//    [self gcdOnceToken];
}

/*
 GCD的所有API都在libdispatch.dylib，Xcode会自动导入这个库
 主头文件 ： #import <dispatch/dispatch.h>
 */

#pragma mark -一次执行
- (void)gcdOnceToken{
    //保证某段代码在程序运行的时候只被执行一次，在单例设计模式中被广泛使用
    //是线程安全的
    static dispatch_once_t onceToken;
    NSLog(@"--%ld--",onceToken);
    for (int i = 0; i < 10; i++) {
        dispatch_once(&onceToken, ^{
            NSLog(@"~~%ld~~",onceToken);
        });
    }
    NSLog(@"完成了");
}

#pragma mark -调度组
- (void)gcdTestTen{
    /*
     应用场景:
     开发的时候，有时候出现多个网络请求，每一个网络请求时间长度不一定，都完成以后再统一通知用户
     */
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //把任务放到调度组中
    dispatch_group_async(group, queue, ^{
        NSLog(@"下载小说A--%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"下载小说B--%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"下载小说C--%@",[NSThread currentThread]);
    });
    
    //获得调度组里面所有异步任务完成以后的通知
//    dispatch_group_notify(group, queue, ^{
//        NSLog(@"下载完成--%@",[NSThread currentThread]);  //异步
//    });
    //在调度组完成通知里，可以跨队列通信
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"下载完成--%@",[NSThread currentThread]);
    });
}

#pragma mark-延迟操作
- (void)gcdTestNine{
    /*
     dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC))
     参数:
     DISPATCH_TIME_NOW ------  0
     NSEC_PER_SEC ------  很大的数字
     两者表示从现在开始经过多少纳秒执行代码块任务
     */
    //在哪一个队列里面延迟执行代码块任务
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
}

#pragma mark -线程通信
- (void)downloadImage{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:@"http://pica.nipic.com/2007-11-09/200711912453162_2.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        //线程间通信
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithData:data];
        });
    });
}

/*
 队列的选择:
 1、串行队列异步执行
 - 只开一条线程，按照顺序执行
 - 效率不高，执行速度慢，占用资源少---->省电
 适用场合:一般是3G网络，对性能要求不高
 
 2、并发队列异步执行
 - 开启多个线程，并发执行
 - 效率高，执行速度快，占用资源多---->费电
 适用场合:一般是WiFi，或者要求很快的响应，要求用户体验非常流畅
 对任务执行顺序没有要求
 
 3、同步任务
 一般只会在并发队列，需要阻塞后续任务，必须等待同步任务执行完毕，再去执行其他任务
 如果不考虑MRC中队列的释放，建议使用"全局队列+异步任务 "
 */

/*
 全局队列和并发队列的区别
 1.全局队列没有名称，并发队列有名称
 2.全局队列供所有的应用程序共享
 3.在MRC中，全局队列不需要释放
 */
#pragma mark -全局队列
- (void)gcdTestEight{
    /*
     第一个参数一般写0，可以适配iOS7和iOS8
      iOS7使用                                                                  iOS8使用
     - DISPATCH_QUEUE_PRIORITY_HIGH:       2   QOS_CLASS_USER_INITIATED
     - DISPATCH_QUEUE_PRIORITY_DEFAULT:   0   QOS_CLASS_DEFAULT
     - DISPATCH_QUEUE_PRIORITY_LOW:      -2    QOS_CLASS_UTILITY
     - DISPATCH_QUEUE_PRIORITY_BACKGROUND:   QOS_CLASS_BACKGROUND
     */
    //全局队列本质上就是一个并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%@--%d",[NSThread currentThread],i);
        });
    }
}

#pragma mark -同步队列的作用
- (void)gcdTestSeven{
    /*
     有一个小说网站，必须先登录，才能下载小说
     有三个任务
     1.用户登录
     2.下载小说A
     3.下载小说B
     */
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"用户登录:%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载小说A:%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载小说B:%@",[NSThread currentThread]);
    });
}

#pragma mark -主队列同步执行任务
- (void)gcdTestSix{
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"-----");
    for (int i = 0; i < 10; i++) {
        NSLog(@"调度前");
        //同步执行任务,把任务放到队列中，需要马上执行
        //造成主线程阻塞，产生死锁
        dispatch_sync(queue, ^{
            NSLog(@"%@--%d",[NSThread currentThread],i);
        });
    }
    NSLog(@"完成---");
}

#pragma mark -主队列异步执行任务
- (void)gcdTestFive{
    //获取主队列，程序一启动--至少有一个主线程开始就会创建主队列
    //主队列专门负责在主线程执行任务，不会在子线程调度任务，在主队列中不允许开新线程
    //在主队列中的任务，只能在主线程执行
    //结果:不开线程，只能在主线程上面顺序执行
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"-----");
    for (int i = 0; i < 10; i++) {
        NSLog(@"调度前");
        //异步执行任务，把任务放到主队列里，但是不会马上执行，等主线程有空再去执行
        dispatch_async(queue, ^{
            NSLog(@"%@--%d",[NSThread currentThread],i);
        });
    }
    NSLog(@"完成---");
}

#pragma mark -并发队列同步执行任务
- (void)gcdTestFour{
    //创建一个并发队列
    //并发队列:可以让多个任务并发执行(自动开启多个线程执行多个任务)
    //同步执行:不会开启新线程，在当前线程执行
    //结果:不开启新线程，顺序执行
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 10; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"%@--%d",[NSThread currentThread],i);
        });
    }
}

#pragma mark -并发队列异步执行任务
- (void)gcdTestThree{
    //创建一个并发队列，非ARC下需要手动释放创建的并发队列
    //并发队列:可以让多个任务并发执行(自动开启多个线程执行多个任务，可以取出多个任务，只要有线程去执行)
    //并发功能只有在dispatch_async才有效
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"开始");
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%@--%d",[NSThread currentThread],i);
        });
    }
    NSLog(@"结束");
}

#pragma mark -串行队列异步执行任务
- (void)gcdTestTwo{
    //下面两种写法都是一样的
    //dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue = dispatch_queue_create("queue", NULL);
    NSLog(@"开始");
    for (int i = 0; i < 10; i++) {
        //开启新线程，在新线程里面执行
        //串行队列异步执行只会创建一个新的线程，并且所有任务都在新线程里面执行
        dispatch_async(queue, ^{
            NSLog(@"%@--%d",[NSThread currentThread],i);
        });
    }
    NSLog(@"结束");
}

#pragma mark -串行队列同步执行任务
- (void)gcdTestOne{
    //创建一个串行队列，非ARC下需要手动释放创建的串行队列
    //串行队列:任务按照顺序一个一个执行，必须一个任务执行完毕后才能从队列中取出下一个任务
    //参数一:队列标签，参数二:队列属性
    NSLog(@"开始");
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    //同步任务:在当前线程执行，不会创建新线程
    //同步执行任务，一般只要使用同步执行，串行队列对添加的同步任务，会立即执行
    dispatch_sync(queue , ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    NSLog(@"完成");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
