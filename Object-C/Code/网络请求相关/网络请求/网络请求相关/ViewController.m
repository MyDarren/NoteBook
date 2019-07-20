//
//  ViewController.m
//  网络请求相关
//
//  Created by  夏发启 on 16/4/19.
//  Copyright © 2016年  夏发启. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)downLoadDataASync{
    NSURL *url = [NSURL URLWithString:@"http://tool.oschina.net/codeformat/json"];
    /*
     参数:
     url：资源路径
     cachePolicy：缓存策略
     
     NSURLRequestUseProtocolCachePolicy = 0,  //默认缓存策略，会自动缓存
     NSURLRequestReloadIgnoringLocalCacheData = 1,   //每次从服务器加载数据，忽略本地缓存
     //底下两个，一般用来离线访问，一般配合Reachability(苹果自带的检测网络连接的框架)使用
     //如果用户使用的wifi，就是用这个策略
     NSURLRequestReturnCacheDataElseLoad = 2,   //如果有缓存就用缓存，没有就上网加载
     //如果用户使用的是3G,就是用这个策略
     NSURLRequestReturnCacheDataDontLoad = 3,   //如果有缓存就用缓存，没有就返回空
     
     timeoutInterval：超时时长，默认为60秒，一般设置为15~20秒。超过这个时长之后，如果服务器还没有响应，就不继续等待
     SDWebImage超时时长为15秒
     AFNetWorking超时时长为60秒
     */
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15];
    /*
     建立连接，发送数据给服务器
     参数:
     request:请求
     queue:队列，这个队列，是完成以后，回调block执行的队列
     使用场景:1.如果下载的是压缩包，解压缩也是耗时操作，需要放到子线程
     2.如果回调的block中只需要更新UI,那么就可以指定queue为主队列
     Asynchronous:异步，开启新线程
     completionHandler:网络访问完成以后执行的代码块
     response:服务器的响应（包括响应行/响应头，下载的时候才去关心这个）
     data:返回的二进制数据
     connectionError:连接服务器时的错误
     */
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"---解压缩---%@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            //网络请求完成以后调用的代码从服务器获取数据
            /*
             NSJSONReadingMutableContainers = (1UL << 0),  容器是可变的，转成的结果是可变的类型
             NSJSONReadingMutableLeaves = (1UL << 1),      叶子节点是可变的
             NSJSONReadingAllowFragments = (1UL << 2)      允许根节点，可以不是NSArray,NSDictionary
             */
            
            /*
             id result = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:NULL];  plist解析
             // 初始化一个json的解码器，调用方法解析
             id result = [[JSONDecoder decoder] objectWithData:data];JSONKit解析
             */
            //反序列化
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"%@---更新UI---%@",result,[NSThread currentThread]);
        });
    }];
    
}

- (void)downLoadDataSyncOne{
    //同步方法，超时时长60秒
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img.pconline.com.cn/images/upload/upc/tx/photoblog/1512/22/c7/16739418_1450755319331_mthumb.jpg"]];
    self.myImageView.image = [UIImage imageWithData:data];
    [self.view addSubview:self.myImageView];
}

- (void)downLoadDataSyncTwo{
    NSURL *url = [NSURL URLWithString:@"http://tool.oschina.net/codeformat/json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15];
    NSURLResponse *response = nil;
    /*
     sendSynchronousRequest:发送同步请求
     returningResponse:服务器响应的地址
     error:错误信息的地址
     NULL:本质是0，表示的是地址是0
     nil:表示地址为0的空对象，可以给nil发送消息
     */
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
    NSLog(@"%@--%@--%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],[NSThread currentThread],response);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
