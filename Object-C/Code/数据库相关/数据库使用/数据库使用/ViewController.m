//
//  ViewController.m
//  数据库使用
//
//  Created by WaiLaiXing on 16/4/14.
//  Copyright © 2016年 WaiLaiXing. All rights reserved.
//

#import "ViewController.h"
#import "SQLiteTool.h"
#import "StudentModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *sql = @"create table if not exists Student (id integer primary key autoincrement,name text,age integer);";
    [SQLiteTool exexuteSQLWithString:sql];
}

- (IBAction)insertData:(id)sender {
    NSString *insertSql = @"insert into Student (name,age) values ('zhangsan',18);";
    [SQLiteTool exexuteSQLWithString:insertSql];
}

- (IBAction)deleteData:(id)sender {
    NSString *deleteSql = @"delete from Student where age = 20;";
    [SQLiteTool exexuteSQLWithString:deleteSql];
}

- (IBAction)updateData:(id)sender {
    NSString *updateSql = @"update Student set age = 20 where name = 'zhangsan';";
    [SQLiteTool exexuteSQLWithString:updateSql];
}

- (IBAction)selectData:(id)sender {
    NSString *selectSql = @"select * from Student";
    NSArray *array = [SQLiteTool seleteSQLWithString:selectSql];
    for (StudentModel *student in array) {
        NSLog(@"name:%@,age:%ld",student.name,student.age);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
