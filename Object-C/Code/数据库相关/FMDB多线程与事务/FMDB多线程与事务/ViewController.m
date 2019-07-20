//
//  ViewController.m
//  FMDB多线程与事务
//
//  Created by WaiLaiXing on 16/4/15.
//  Copyright © 2016年 WaiLaiXing. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"

@interface ViewController ()

@property (nonatomic,strong)FMDatabaseQueue *queue;

@end

@implementation ViewController

- (IBAction)insertData:(id)sender {
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL isSucceed1 = [db executeUpdate:@"insert into contact (name,money) values (?,?)",@"张三",@1000];
        if (isSucceed1) {
            NSLog(@"插入张三成功");
        }else
            NSLog(@"插入张三失败");
        BOOL isSucceed2 = [db executeUpdate:@"insert into contact (name,money) values (?,?)",@"李四",@500];
        if (isSucceed2) {
            NSLog(@"插入李四成功");
        }else
            NSLog(@"插入李四失败");
    }];
}

- (IBAction)deleteData:(id)sender {
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL isSucceed = [db executeUpdate:@"delete from contact"];
        if (isSucceed) {
            NSLog(@"删除成功");
        }else
            NSLog(@"删除失败");
    }];
}

- (IBAction)updateData:(id)sender {
    /*
     事务:把有联系的业务逻辑划分到一个事务里,比如转账,比如必须 两个同时修改成功,才能 交。
     注意:即使不 交事务,也会修改成功,需要判断操作有没有执行 对,如果发现事务里有一个操作不对,就主动回滚。
     注意把操作放在事务里,并不会自动有一个操作失败就会主动回 滚,需要我们自己处理,否则就会有有些执行,有些没执行。
     */
    /*方式一
    [_queue inDatabase:^(FMDatabase *db) {
        //开启事务
        [db beginTransaction];
        BOOL isSucceed1 = [db executeUpdate:@"update contact set money = ? where name = ?",@500,@"张三"];
        if (isSucceed1) {
            NSLog(@"张三更新成功");
        }else{
            NSLog(@"张三更新失败");
            //回滚，失败之后回滚还原
            [db rollback];
        }
        BOOL isSucceed2 = [db executeUpdate:@"update contact set money = ? where name = ?",@1000,@"李四"];
        if (isSucceed2) {
            NSLog(@"李四更新成功");
        }else{
            NSLog(@"李四更新失败");
            [db rollback];
        }
        //全部操作完成后提交
        [db commit];
    }];
     */
    //方式二
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isSucceed1 = [db executeUpdate:@"update contact set money = ? where name = ?",@500,@"张三"];
        if (isSucceed1) {
            NSLog(@"张三更新成功");
        }else{
            NSLog(@"张三更新失败");
        }
        BOOL isSucceed2 = [db executeUpdate:@"update contact set money = ? where name = ?",@1000,@"李四"];
        if (isSucceed2) {
            NSLog(@"李四更新成功");
        }else{
            NSLog(@"李四更新失败");
        }
        * rollback = YES;
    }];
}

- (IBAction)selectData:(id)sender {
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"select * from contact"];
        while ([result next]) {
            NSString *name = [result stringForColumn:@"name"];
            int money = [result intForColumn:@"money"];
            NSLog(@"name:%@--age:%d",name,money);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *cachePath =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"contact.sqlite"];
    //创建数据库实例
    _queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    //创建数据库表
    //提供了一个多线程安全的数据库实例
    [_queue inDatabase:^(FMDatabase *db) {
    BOOL isSucceed =  [db executeUpdate:@"create table if not exists contact (id integer primary key autoincrement,name text,money integer);"];
        if (isSucceed) {
            NSLog(@"创建表单成功");
        }else
            NSLog(@"创建表单失败");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
