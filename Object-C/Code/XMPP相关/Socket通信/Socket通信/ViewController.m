//
//  ViewController.m
//  Socket通信
//
//  Created by  夏发启 on 16/5/8.
//  Copyright © 2016年  夏发启. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSStreamDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)NSInputStream *inputStream;
@property (nonatomic,strong)NSOutputStream *outputStream;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic,strong)NSMutableArray *messageArray;

@end

@implementation ViewController

#define kWLXScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kWLXScreenWidth [[UIScreen mainScreen] bounds].size.width

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self makeUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHiden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)makeUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWLXScreenWidth, kWLXScreenHeight - 50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.textField.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kWLXScreenWidth, 50)];
    self.bottomView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.bottomView];
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, kWLXScreenWidth - 40, 30)];
    self.textField.backgroundColor = [UIColor yellowColor];
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeySend;
    [self.bottomView addSubview:self.textField];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.textLabel.text = self.messageArray[indexPath.row];
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *textString = textField.text;
    if (textString.length == 0) {
        return NO;
    }
    NSString *sendString = [@"msg:" stringByAppendingString:textString];
    [self sendDataWithString:sendString];
    return YES;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)kbWillShow:(NSNotification *)notification{
    CGFloat kbHeight = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y;
    NSNumber *duration = notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"];
    NSNumber *curve = notification.userInfo[@"UIKeyboardAnimationCurveUserInfoKey"];
    [UIView animateWithDuration:duration.floatValue animations:^{
        [UIView setAnimationCurve:curve.integerValue];
        self.bottomView.frame = CGRectMake(0, kbHeight - 50, kWLXScreenWidth, 50);
    }];
}

- (void)kbWillHiden:(NSNotification *)notification{
    NSNumber *duration = notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"];
    NSNumber *curve = notification.userInfo[@"UIKeyboardAnimationCurveUserInfoKey"];
    [UIView animateWithDuration:duration.floatValue animations:^{
        [UIView setAnimationCurve:curve.integerValue];
        self.bottomView.frame = CGRectMake(0, kWLXScreenHeight - 50, kWLXScreenWidth, 50);
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (IBAction)connectAction:(id)sender {
    //iOS实现socket连接，使用C语言
    //1、与服务器通过三次握手建立连接
    NSString *host = @"127.0.0.1";
    int port = 12345;
    //2、定义输入输出流
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    //3、分配输入输出流的内存空间
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host, port, &readStream, &writeStream);
    //4、把C语言的输入输出流转成OC对象
    self.inputStream = (__bridge NSInputStream *)readStream;
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    //5、设置代理，监听数据接收的状态
    self.inputStream.delegate = self;
    self.outputStream.delegate = self;
    //把输入输出流添加到主运行循环(RunLoop)
    [self.inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    //6、打开输入输出流
    [self.inputStream open];
    [self.outputStream open];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    /*
     NSStreamEventNone = 0,
     NSStreamEventOpenCompleted = 1UL << 0,
     NSStreamEventHasBytesAvailable = 1UL << 1,
     NSStreamEventHasSpaceAvailable = 1UL << 2,
     NSStreamEventErrorOccurred = 1UL << 3,
     NSStreamEventEndEncountered = 1UL << 4
     */
    /*
     代理方法是在主线程执行
     */
    NSLog(@"%@",[NSThread currentThread]);
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"%@",aStream);
            NSLog(@"成功建立连接,形成输入输出的传输通道");
            break;
        case NSStreamEventHasBytesAvailable:
            [self readData];
            NSLog(@"有数据可读");
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"可以发送数据");
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"有错误发生,连接失败");
        case NSStreamEventEndEncountered:
            NSLog(@"正常断开连接");
            [self.inputStream close];
            [self.outputStream close];
            [self.inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            [self.outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        default:
            break;
    }
}

- (void)sendDataWithString:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //uint8_t *字符数组
    [self.outputStream write:data.bytes maxLength:data.length];
}

- (IBAction)loginAction:(id)sender {
    //发送登录请求，使用输出流
    NSString *loginStr = @"iam:zhangsan";
    [self sendDataWithString:loginStr];
}

- (void)readData{
    //定义缓冲区
    uint8_t buf[1024];
    //读取数据，length为服务器读取到的实际字节数
    NSInteger length =  [self.inputStream read:buf maxLength:sizeof(buf)];
    //把缓冲区里的实际字节数转成字符串
    NSString *receivStr =  [[NSString alloc] initWithBytes:buf length:length encoding:NSUTF8StringEncoding];
    NSLog(@"%@",receivStr);
    [self.messageArray addObject:receivStr];
    [self.tableView reloadData];
}

- (NSMutableArray *)messageArray{
    if (_messageArray == nil) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
