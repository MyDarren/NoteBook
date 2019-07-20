//
//  WCRegisterViewController.m
//  WeChat
//
//  Created by  夏发启 on 16/8/11.
//  Copyright © 2016年  夏发启. All rights reserved.
//

#import "WCRegisterViewController.h"
#import "MBProgressHUD.h"

@interface WCRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation WCRegisterViewController

- (IBAction)cancleButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerButtonClick:(id)sender {
    if (self.userNameTextField.text.length == 0 || self.pwdTextField.text.length == 0) {
        NSLog(@"请输入用户名或密码");
        return;
    }
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WCAccount shareAccount].registerUserName = self.userNameTextField.text;
    [WCAccount shareAccount].registerPassword = self.pwdTextField.text;
    [WCXMPPTool sharedWCXMPPTool].isRegister = YES;
    __weak typeof(self) weakSelf = self;
    [[WCXMPPTool sharedWCXMPPTool] xmppRegisterWithBlock:^(XMPPResultType resultType) {
        [weakSelf handleXMPPResultType:resultType];
    }];
}

- (void)handleXMPPResultType:(XMPPResultType)resultType{
    //回到主线程更新UI
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (resultType == XMPPResultRegisterSuccess) {
            WCLog(@"注册成功");
            weakSelf.hud.hidden = YES;
        }else{
            WCLog(@"注册失败");
            weakSelf.hud.labelText = @"注册失败";
            weakSelf.hud.labelFont = [UIFont systemFontOfSize:12];
            weakSelf.hud.minShowTime = 1;
            [weakSelf.hud hide:YES];
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
