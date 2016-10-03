//
//  WCAccount.m
//  WeChat
//
//  Created by huhang on 16/9/23.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "WCAccount.h"

#define kLoginUserKey @"LoginUser"
#define kLoginPwdKey @"LoginPwd"
#define kLoginKey @"login"

static NSString *domin = @"teacher.local";
static NSString *host = @"127.0.0.1";
static int port = 5222;

@implementation WCAccount

+ (instancetype)shareAccount{
    return [[self alloc]init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static WCAccount *account;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = [super allocWithZone:zone];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        account.LoginUser = [defaults objectForKey:kLoginUserKey];
        account.LoginPwd = [defaults objectForKey:kLoginPwdKey];
        account.login = [defaults boolForKey:kLoginKey];
    });
    return account;
}

- (void)saveToSandBox{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.LoginUser forKey:kLoginUserKey];
    [defaults setObject:self.LoginPwd forKey:kLoginPwdKey];
    [defaults setBool:self.isLogin forKey:kLoginKey];
    [defaults synchronize];
}

- (NSString *)domin{
    return domin;
}

- (NSString *)host{
    return host;
}

- (int)port{
    return port;
}

@end
