//
//  WCAddContactController.m
//  WeChat
//
//  Created by huhang on 2016/9/26.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "WCAddContactController.h"

@interface WCAddContactController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WCAddContactController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}


#pragma mark 点击添加按钮
- (IBAction)addButAction:(id)sender {
    
    NSString *user = self.textField.text;
    
    //1.不能添加自己为好友
    if ([user isEqualToString:[WCAccount shareAccount].LoginUser]) {
        [self showMsg:@"不能添加自己为好友"];
        return;
    }
    
    //2.不能添加已有的好友
    XMPPJID *userJid = [XMPPJID jidWithUser:user domain:[WCAccount shareAccount].domin resource:nil];
    BOOL userExists = [[WCXMPPTool sharedWCXMPPTool].rosterStorage userExistsWithJID:userJid xmppStream:[WCXMPPTool sharedWCXMPPTool].xmppStream];
    if (userExists) {
        [self showMsg:@"不能添加已有的好友"];
        return;
    }
    
    //3.添加好友
    [[WCXMPPTool sharedWCXMPPTool].roster subscribePresenceToUser:userJid];

}

- (void)showMsg:(NSString *)msg{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alertView show];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


@end
