//
//  WCXMPPTool.h
//  WeChat
//
//  Created by huhang on 16/9/24.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

typedef NS_ENUM(NSInteger,XMPPResultType){
    
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure, //登录失败
    XMPPResultTypeRegisterSuccess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
};

typedef void(^XMPPResultBlock)(XMPPResultType);

@interface WCXMPPTool : NSObject

singleton_interface(WCXMPPTool)

/** 与服务器交互的核心类 */
@property(nonatomic,strong,readonly)XMPPStream *xmppStream;

/** 电子名片模块 */
@property (nonatomic,strong,readonly)XMPPvCardTempModule *vCard;
/** 电子名片数据储存 */
@property (nonatomic,strong,readonly)XMPPvCardCoreDataStorage *vCardStorage;

/** 电子名片头像模块 */
@property (nonatomic,strong,readonly)XMPPvCardAvatarModule *avatar;

/** 花名册模块 */
@property (nonatomic,strong,readonly)XMPPRoster *roster;
/** 花名册数据模块 */
@property (nonatomic,strong,readonly)XMPPRosterCoreDataStorage *rosterStorage;

/** 消息模块 */
@property (nonatomic,strong,readonly)XMPPMessageArchiving *megArchiving;
/** 消息模块数据存储 */
@property (nonatomic,strong,readonly)XMPPMessageArchivingCoreDataStorage *megArchivingStorage;


/* 是否注册 */
@property (nonatomic,assign,getter=isRegisterOpteration)BOOL registerOpteration;

/**
 *  XMPP用户登录
 */
- (void)xmppLogin:(XMPPResultBlock)resultBlock;

/**
 *  XMPP用户注册
 *
 */
- (void)xmppRegister:(XMPPResultBlock)resultBlock;

/**
 *  xmpp用户注销
 */
- (void)xmppLogout;

@end
