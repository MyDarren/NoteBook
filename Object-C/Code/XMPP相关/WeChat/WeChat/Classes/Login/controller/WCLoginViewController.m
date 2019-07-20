//
//  WCLoginViewController.m
//  WeChat
//
//  Created by  夏发启 on 16/8/8.
//  Copyright © 2016年  夏发启. All rights reserved.
//

#import "WCLoginViewController.h"
#import "MBProgressHUD.h"

@interface WCLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (nonatomic,strong)MBProgressHUD *hud;
 
@end

@implementation WCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)loginButtonClick:(id)sender {
    //1、判断有没有输入用户名和密码
    if (self.userField.text.length == 0 || self.pwdField.text.length == 0) {
        NSLog(@"请输入用户名或密码");
        return;
    }
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //2、登录服务器
    //把用户名和密码保存到沙盒
    WCAccount *account = [WCAccount shareAccount];
    account.loginUserName = self.userField.text;
    account.loginPassword = self.pwdField.text;
    //block会对self进行强引用
    //第一种方式:弱引用
    //第二种方式:block使用完成之后将block置为nil
    __weak typeof(self) weakSelf = self;
    [[WCXMPPTool sharedWCXMPPTool] xmppLoginWithBlock:^(XMPPResultType resultType) {
        [weakSelf handleXMPPResultType:resultType];
    }];
}

- (void)handleXMPPResultType:(XMPPResultType)resultType{
    //回到主线程更新UI
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (resultType == XMPPResultLoginSuccess) {
            WCLog(@"登陆成功");
            weakSelf.hud.hidden = YES;
            //切换到主界面
            [weakSelf changeToMain];
            WCAccount *account = [WCAccount shareAccount];
            account.isLogin = YES;
            [account saveToSandBox];
        }else{
            WCLog(@"登陆失败");
            weakSelf.hud.labelText = @"登录失败";
            weakSelf.hud.labelFont = [UIFont systemFontOfSize:12];
            weakSelf.hud.minShowTime = 1;
            [weakSelf.hud hide:YES];
        }
    });
}

//切换到主界面
- (void)changeToMain{
    //获取Main.storyboard的第一个控制器
    id vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}

- (void)dealloc{
    WCLog(@"登录控制器销毁");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
