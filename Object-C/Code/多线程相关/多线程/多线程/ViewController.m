//
//  ViewController.m
//  多线程
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
    [self downloadImage];
    //[self performSelectorInBackground:@selector(downloadImage) withObject:nil];
}

- (void)downloadImage{
    //每个线程都有一个RunLoop，但是只有主线程的RunLoop会默认启动，子线程的RunLoop不会自动启动，一般不处理触摸事件，不会自动创建自动释放池，子线程里面autorelease的对象，就会没有池子释放，造成内存泄露，所以需要手动创建
    @autoreleasepool {
        NSLog(@"%@",[NSThread currentThread]);
        NSURL *url = [NSURL URLWithString:@"http://pica.nipic.com/2007-11-09/200711912453162_2.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        //self.imageView.image = [UIImage imageWithData:data];
        //线程间通信
        //在这个需要把数据传到主线程，在主线程更新UI
        [self performSelectorOnMainThread:@selector(downloadFinish:) withObject:data waitUntilDone:NO];
        //[self performSelector:@selector(downloadFinish:) onThread:[NSThread mainThread] withObject:data waitUntilDone:NO];
        //UIImage *image = [UIImage imageWithData:data];
        //[self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        //waitUntilDone表示是否等待@selector(downloadFinish:)执行完成再执行下面的代码
        NSLog(@"子线程");
    }
}

- (void)downloadFinish:(NSData *)data{
    NSLog(@"%s",__func__);
    self.imageView.image = [UIImage imageWithData:data];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
