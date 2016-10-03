//
//  WCAccount.h
//  WeChat
//
//  Created by huhang on 16/9/23.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCAccount : NSObject

#pragma mark 登录
/** 用户名 */
@property (nonatomic,copy)NSString *LoginUser;
/** 密码 */
@property (nonatomic,copy)NSString *LoginPwd;
/** 是否登录 */
@property (nonatomic,assign,getter=isLogin)BOOL login;

#pragma mark 注册
/** 注册名 */
@property (nonatomic,copy)NSString *registerUser;
/** 注册密码 */
@property (nonatomic,copy)NSString *registerPwd;

/** 主机名 */
@property (nonatomic,copy,readonly)NSString *domin;
/** 主机ip */
@property (nonatomic,copy,readonly)NSString *host;
/* 端口 */
@property (nonatomic,assign,readonly)int port;

+ (instancetype)shareAccount;

- (void)saveToSandBox;

@end
