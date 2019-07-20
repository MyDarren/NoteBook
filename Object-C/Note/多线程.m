/**
 卖票问题使用加锁，互斥锁
 加锁，锁定的代码尽量少。
 加锁范围内的代码， 同一时间只允许一个线程执行
 互斥锁的参数:任何继承 NSObject *对象都可以。
 要保证这个锁，所有的线程都能访问到, 而且是所有线程访问的是同一个锁对象
 */
-----------------------------------------------------------------
 nonatomic 非原子属性
 atomic 原子属性--默认属性
 原子属性就是针对多线程设计的。 原子属性实现 单(线程)写 多(线程)读
 "atomic(原子属性)在set方法内部加了一把自旋锁"
 "nonatomic（非原子属性）下，set和get方法都不会加锁"
// 原子属性内部使用的 自旋锁
// 自旋锁和互斥锁
// 共同点: 都可以锁定一段代码。 同一时间， 只有线程能够执行这段锁定的代码
// 区别：互斥锁，在锁定的时候，其他线程会睡眠，等待条件满足，再唤醒
// 自旋锁，在锁定的时候， 其他的线程会做死循环，一直等待这条件满足，一旦条件满足，立马去执行，少了一个唤醒过程

-----------------------------------------------------------------

 线程安全的概念: 就是在多个线程同时执行的时候，能够保证资源信息的准确性.
 
 "UI线程" -- 主线程
 ** UIKit 中绝对部分的类，都不是”线程安全“的
 
 "iOS里面是怎么解决这个线程不安全的问题？"
 苹果约定，所有程序的更新UI都在主线程进行，也就不会出现多个线程同时改变一个资源。
 
 // 在主线程更新UI，有什么好处？
 1. 只在主线程更新UI，就不会出现多个线程同时改变 同一个UI控件
 2. 主线程的优先级最高。也就意味UI的更新优先级高。 会让用户感觉很流畅



多线程的注意点（掌握）
1.不要同时开太多的线程（1~3条线程即可，不要超过5条）
2.线程概念
1> 主线程 ： UI线程，显示、刷新UI界面，处理UI控件的事件
2> 子线程 ： 后台线程，异步线程
3.不要把耗时的操作放在主线程，要放在子线程中执行

一、NSThread（掌握）
1.创建和启动线程的3种方式
1> 先创建，后启动
// 创建
NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(download:) object:nil];
// 启动
[thread start];

2> 创建完自动启动
[NSThread detachNewThreadSelector:@selector(download:) toTarget:self withObject:nil];

3> 隐式创建（自动启动）
[self performSelectorInBackground:@selector(download:) withObject:nil];

2.常见方法
1> 获得当前线程
+ (NSThread *)currentThread;

2> 获得主线程
+ (NSThread *)mainThread;

3> 睡眠（暂停）线程
+ (void)sleepUntilDate:(NSDate *)date;
+ (void)sleepForTimeInterval:(NSTimeInterval)ti;

4> 设置线程的名字
- (void)setName:(NSString *)n;
- (NSString *)name;

二、线程同步（掌握）
1.实质：为了防止多个线程抢夺同一个资源造成的数据安全问题

2.实现：给代码加一个互斥锁（同步锁）
@synchronized(self) {
    // 被锁住的代码
}

三、GCD
1.队列和任务
1> 任务 ：需要执行什么操作
* 用block来封装任务

2> 队列 ：存放任务
* 全局的并发队列 ： 可以让任务并发执行
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

* 自己创建的串行队列 ： 让任务一个接着一个执行
dispatch_queue_t queue = dispatch_queue_create("cn.heima.queue", NULL);

* 主队列 ： 让任务在主线程执行
dispatch_queue_t queue = dispatch_get_main_queue();

2.执行任务的函数
1> 同步执行 : 不具备开启新线程的能力
dispatch_sync...

2> 异步执行 : 具备开启新线程的能力
dispatch_async...

3.常见的组合（掌握）
1> dispatch_async + 全局并发队列
2> dispatch_async + 自己创建的串行队列

4.线程间的通信（掌握）
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // 执行耗时的异步操作...
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 回到主线程，执行UI刷新操作
    });
});

5.GCD的所有API都在libdispatch.dylib，Xcode会自动导入这个库
* 主头文件 ： #import <dispatch/dispatch.h>

6.延迟执行（掌握）
1> perform....
// 3秒后自动回到当前线程调用self的download:方法，并且传递参数：@"http://555.jpg"
[self performSelector:@selector(download:) withObject:@"http://555.jpg" afterDelay:3];

2> dispatch_after...
// 任务放到哪个队列中执行
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
double delay = 3; // 延迟多少秒
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), queue, ^{
    // 3秒后需要执行的任务
});

7.一次性代码（掌握）
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
    // 这里面的代码，在程序运行过程中，永远只会执行1次
});

四、NSOperation和NSOperationQueue
1.队列的类型
1> 主队列
* [NSOperationQueue mainQueue]
* 添加到"主队列"中的操作，都会放到主线程中执行

2> 非主队列
* [[NSOperationQueue alloc] init]
* 添加到"非主队列"中的操作，都会放到子线程中执行

2.队列添加任务
* - (void)addOperation:(NSOperation *)op;
* - (void)addOperationWithBlock:(void (^)(void))block;

3.常见用法
1> 设置最大并发数
- (NSInteger)maxConcurrentOperationCount;
- (void)setMaxConcurrentOperationCount:(NSInteger)cnt;

2> 队列的其他操作
* 取消所有的操作
- (void)cancelAllOperations;

* 暂停所有的操作
[queue setSuspended:YES];

* 恢复所有的操作
[queue setSuspended:NO];

4.操作之间的依赖（面试题）
* NSOperation之间可以设置依赖来保证执行顺序
* [operationB addDependency:operationA];
// 操作B依赖于操作A，等操作A执行完毕后，才会执行操作B
* 注意：不能相互依赖，比如A依赖B，B依赖A
* 可以在不同queue的NSOperation之间创建依赖关系

5.线程之间的通信
NSOperationQueue *queue = [[NSOperationQueue alloc] init];
[queue addOperationWithBlock:^{
    // 1.执行一些比较耗时的操作
    
    // 2.回到主线程
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
    }];
}];

五、从其他线程回到主线程的方式
1.perform...
[self performSelectorOnMainThread:<#(SEL)#> withObject:<#(id)#> waitUntilDone:<#(BOOL)#>];

2.GCD
dispatch_async(dispatch_get_main_queue(), ^{
    
});

3.NSOperationQueue
[[NSOperationQueue mainQueue] addOperationWithBlock:^{
    
}];

六、第三方框架的使用建议
1.用第三方框架的目的
1> 开发效率：快速开发，人家封装好的一行代码顶自己写的N行
2> 为了使用这个功能最牛逼的实现

2.第三方框架过多，很多坏处(忽略不计)
1> 管理、升级、更新
2> 第三方框架有BUG，等待作者解决
3> 第三方框架的作者不幸去世、停止更新（潜在的BUG无人解决）
4> 感觉：自己好水

3.比如
流媒体：播放在线视频、音频（边下载边播放）
非常了解音频、视频文件的格式
每一种视频都有自己的解码方式（C\C++）

4.总结
1> 站在巨人的肩膀上编程
2> 没有关系，使劲用那么比较稳定的第三方框架

七、SDWebImage的图片下载
1.面试题
1> 如何防止一个url对应的图片重复下载
* “cell下载图片思路 – 有沙盒缓存”

2> SDWebImage的默认缓存时长是多少？
* 1个星期

3> SDWebImage底层是怎么实现的？
* 上课PPT的“cell下载图片思路 – 有沙盒缓存”

2.SDWebImage
1> 常用方法
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

2> SDWebImageOptions
* SDWebImageRetryFailed : 下载失败后，会自动重新下载
* SDWebImageLowPriority : 当正在进行UI交互时，自动暂停内部的一些下载操作
* SDWebImageRetryFailed | SDWebImageLowPriority : 拥有上面2个功能
