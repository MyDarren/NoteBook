//
//  ViewController.m
//  POST上传
//
//  Created by  夏发启 on 16/4/21.
//  Copyright © 2016年  夏发启. All rights reserved.
//

#import "ViewController.h"
#import "NSMutableURLRequest+upload.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self postJSON];
}

- (void)postJSON{
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/post/postjson.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15];
    request.HTTPMethod = @"POST";
    NSDictionary *dict1 = @{@"name":@"zhangsan",@"age":@20};
    NSDictionary *dict2 = @{@"name":@"lisi",@"age":@18};
    NSArray *array = @[dict1,dict2];
    /*
     Top level object is an NSArray or NSDictionary
     顶级节点是字典或者数组
     - All objects are NSString, NSNumber, NSArray, NSDictionary, or NSNull
     所有的对象是 NSString, NSNumber, NSArray, NSDictionary, or NSNull
     - All dictionary keys are NSStrings
     所有字典的key是NSString类型
     - NSNumbers are not NaN or infinity
     NSNumbers必须指定，不能是无穷大
     */
    //用来检验给定的对象是否能够被序列化
    if (![NSJSONSerialization isValidJSONObject:array]) {
        NSLog(@"数据格式不正确，不能被序列化");
        return ;
    }
    // 上传json类型数据 (本质就是一个字符串，特殊的字符串)
    // 序列化，将NSArray/NSDictionary转成 特殊数据类型 的二进制数据
    // 反序列化, 将服务器返回的二进制转成NSArray/NSDictionary
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:array options:0 error:NULL];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        id result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",result);
    }];
}

- (void)postFile{
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/post/upload.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15 localFilePath:[[NSBundle mainBundle] pathForResource:@"autorun.ico" ofType:nil] fileName:@"test2.ico"];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        //反序列化
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@",result);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
