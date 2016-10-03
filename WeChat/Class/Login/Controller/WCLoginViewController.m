//
//  WCLoginViewController.m
//  WeChat
//
//  Created by huhang on 16/9/24.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import "WCLoginViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+HM.h"

@interface WCLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@end

@implementation WCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.userField.text = [WCAccount shareAccount].user;
//    self.pwdField.text = [WCAccount shareAccount].pwd;

}

#pragma mark 点击登录
- (IBAction)loginBtnClick:(id)sender {
    
    // 1.判断有没有输入用户名和密码
    if (self.userField.text.length == 0 || self.pwdField.text.length == 0) return;
    
    //给用户提示
    [MBProgressHUD showMessage:@"正在登录..."];
    
    [WCAccount shareAccount].LoginUser = self.userField.text;
    [WCAccount shareAccount].LoginPwd = self.pwdField.text;
    //登录时,置NO
    [WCXMPPTool sharedWCXMPPTool].registerOpteration = NO;
    
    // 2.登录服务器
    // 2.1调用AppDelegate的xmppLogin方法
    __weak typeof(self) weakSelf = self;
    [[WCXMPPTool sharedWCXMPPTool] xmppLogin:^(XMPPResultType resultType) {
        
        [weakSelf handleWithLoginType:resultType];
        
    }];
}

#pragma mark 处理登录状态
- (void)handleWithLoginType:(XMPPResultType)resultType{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //隐藏提示
        [MBProgressHUD hideHUD];
        
        if (resultType == XMPPResultTypeLoginSuccess) {//登录成功
            
            //保存登录状态
            [WCAccount shareAccount].login = YES;
            //用户名和密码保存到沙盒
            [[WCAccount shareAccount] saveToSandBox];
            //登录成功切换到主界面
            [UIStoryboard showInitialVCWithName:@"Main"];
            
        }else{//登录失败
            [MBProgressHUD showError:@"用户名或者密码不正确"];
        }
    });
}

@end
