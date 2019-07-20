//
//  ViewController.m
//  图片下载
//
//  Created by Darren on 16/3/7.
//  Copyright © 2016年 Darren. All rights reserved.
//

#import "ViewController.h"
#import "DataModel.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
/**管理全局下载操作的队列*/
@property (nonatomic,strong)NSOperationQueue *queue;
/**所有图片的缓存*/
@property (nonatomic,strong)NSCache *imageCache;
/**所有下载操作的缓冲池*/
@property (nonatomic,strong)NSMutableDictionary *operationCache;

@end

@implementation ViewController

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
    }
    return _tableView;
}

- (NSMutableDictionary *)operationCache{
    if (_operationCache == nil) {
        _operationCache = [[NSMutableDictionary alloc] initWithCapacity:42];
    }
    return _operationCache;
}

- (NSCache *)imageCache{
    if (_imageCache == nil) {
        _imageCache = [[NSCache alloc] init];
    }
    return _imageCache;
}

- (NSOperationQueue *)queue{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:42];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"apps.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        for (NSDictionary *dict in array) {
            DataModel *model = [DataModel modelWithDict:dict];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

/**
 问题1: 如果网络比较慢，会比较卡
 解决办法：用异步下载
 
 问题2：图片没有frame,所有cell初始化的时候，给imageView的frame是0。 异步下载完成以后，不显示
 解决办法：使用占位图（如果占位图比较大，下载的图片比较小。自定义cell可以解决）
 
 问题3：如果图片下载速度不一致，同时用户快速滚动的时候，会因为cell的重用导致图片混乱
 解决办法：MVC，使用模型保持下载的图像。 再次刷新表格
 
 问题4：在用户快读滚动的时候，会重复添下载加操作到队列
 解决办法：建立一个下载操作的缓冲池，首先检查”缓冲池“里是否有当前图片下载操作，有。 就不创建操作了。保证一个图片只对应一个下载操作
 
 问题5：将图像保存到模型里优缺点
 优点：不用重复下载，利用MVC刷新表格，不会造成数据混乱.加载速度比较快
 缺点：内存：所有下载好的图像，都会记录在模型里。如果数据比较多(2000)
 造成内存警告
 
 --** 图像跟模型耦合性太强。导致清理内存非常困难
 解决办法: 模型跟图像分开。在控制器里做缓存
 
 问题6：下载操作缓冲池，会越来越大，想办法清理
 
 */

//cell里面的imageView子控件也是懒加载
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    DataModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.download;
    //判断当前图片缓存里是否有图片
    if ([self.imageCache objectForKey:model.icon]) {
        NSLog(@"缓存中有图片");
        cell.imageView.image = [self.imageCache objectForKey:model.icon];
    }else{
        NSLog(@"缓存中没有图片");
        UIImage *image = [UIImage imageWithContentsOfFile:[self cachePathWithUrl:model.icon]];
        if (image) {
            NSLog(@"从沙盒中读取图片");
            //将图片放在缓存中
            [self.imageCache setObject:image forKey:model.icon];
            cell.imageView.image = image;
        }else{
            //显示占位图
            cell.imageView.image = [UIImage imageNamed:@"1.jpg"];
            [self downloadImageWithIndexPath:indexPath];
        }
    }
    return cell;
}

/*
 拼接一个文件在沙盒的全路径
 */
- (NSString *)cachePathWithUrl:(NSString *)urlStr{
    //获取缓存路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //把路径和urlStr拼接起来
    return [cachePath stringByAppendingPathComponent:urlStr.lastPathComponent];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",self.operationCache);
    for (DataModel *model in self.dataArray) {
        NSLog(@"%@",[self.imageCache objectForKey:model.icon]);
    }
}

- (void)downloadImageWithIndexPath:(NSIndexPath *)indexPath{
    DataModel *model = self.dataArray[indexPath.row];
    //判断缓存池中是否存在当前图片的操作
    if (self.operationCache[model.icon]) {
        NSLog(@"正在下载");
        return;
    }
    //1、异步下载图片
    //block会有循环引用风险-----对外部变量的强引用
    //self要小心，可以借助dealloc方法判断是否循环引用
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:model.icon];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            //字典的赋值不能为nil
            //[NSNull null]，空对象，可以放到字典和数组中
            //NSArray *array = [NSArray arrayWithObjects:@"1", [NSNull null],@"2"];
            //NULL，C语言的指针，char *string = NULL，本质上是：(void*)0
            //nil，OC指向空对象的指针，NSString *string = nil，本质上是：(void *)0
            //Nil，空类，本质上也是：(void *)0，表示Objective-C类（Class）类型的变量值为空，Class anyClass = Nil
            //2、将下载的图片保存到模型
            [weakSelf.imageCache setObject:image forKey:model.icon];
            //3、将图片写入沙盒
            [data writeToFile:[self cachePathWithUrl:model.icon] atomically:YES];
        }
        //4、将操作从图片缓冲池删除
        [weakSelf.operationCache removeObjectForKey:model.icon];
        //5、更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }];
    }];
    //将操作添加到队列
    [self.queue addOperation:blockOperation];
    //将操作添加到缓冲池
    [self.operationCache setObject:blockOperation forKey:model.icon];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清理图片缓存
    [self.imageCache removeAllObjects];
    //清理操作缓存
    self.operationCache = [NSMutableDictionary dictionary];
    //取消下载队列里面的任务
    [self.queue cancelAllOperations];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
