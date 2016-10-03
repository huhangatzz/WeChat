//
//  WCRegisterViewController.m
//  WeChat
//
//  Created by huhang on 16/9/24.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "WCRegisterViewController.h"

@interface WCRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@end

@implementation WCRegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark 取消注册
- (IBAction)cancleBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 点击注册
- (IBAction)registerBtnAction:(id)sender {
    
    //保存注册的用户名和密码
    [WCAccount shareAccount].registerUser = self.userField.text;
    [WCAccount shareAccount].registerPwd = self.pwdField.text;
    
    [MBProgressHUD showMessage:@"正在注册中..."];
    //注册时设置YES
    [WCXMPPTool sharedWCXMPPTool].registerOpteration = YES;
    
    __weak typeof(self) weakSelf = self;
    [[WCXMPPTool sharedWCXMPPTool] xmppRegister:^(XMPPResultType resultType) {
        
        [weakSelf handleXmppResult:resultType];
        
    }];
}

#pragma mark 处理注册结果
- (void)handleXmppResult:(XMPPResultType)resultType{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //隐藏提示
        [MBProgressHUD hideHUD];
        
        if (resultType == XMPPResultTypeRegisterSuccess) {
            [MBProgressHUD showSuccess:@"恭喜注册成功"];
            [UIStoryboard showInitialVCWithName:@"Login"];
        }else{
            [MBProgressHUD showError:@"用户名重复"];
        }
    });
    
}

@end
