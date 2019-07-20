//
//  ViewController.m
//  GET和POST请求
//
//  Created by  夏发启 on 16/4/20.
//  Copyright © 2016年  夏发启. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)postLogin{
    NSString *username = @"张三";
    NSString *pwd = @"zhang";
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/login.php"];
    //可变请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15];
    //指定http的访问方法，默认的HTTPMethod为"GET"方法
    request.HTTPMethod = @"POST";
    //指定数据体，数据体的内容可以直接从firebug里面拷贝
    NSString *bodyStr = [NSString stringWithFormat:@"username=%@&password=%@",username,pwd];
    //跟服务器的交互，全部传递的二进制
    request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@",result);
    }]
}

- (void)getLogin{
    //1.url
    NSString *username = @"张三";
    NSString *pwd = @"zhang";
    /*
     http://127.0.0.1 主机地址
     login.php服务器负责登录的脚本(php,java)
     ?后面是参数，是给服务器传递的参数，参数格式为变量名=值
     如果有多个参数，使用&进行连接
     */
    NSString *urlStr = [NSString stringWithFormat:@"http://127.0.0.1/login.php?username=%@&password=%@",username,pwd];
    /*
     url中不能包含中文，空格，特殊字符，如果有需要进行转义
     */
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@",result);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
