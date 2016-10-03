//
//  WCXMPPTool.m
//  WeChat
//
//  Created by huhang on 16/9/24.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "WCXMPPTool.h"

@interface WCXMPPTool ()<XMPPStreamDelegate>
{
    XMPPResultBlock _resultBlock; //结果回调的block
   
    WCAccount *_account; //模型类
}

@end

@implementation WCXMPPTool

singleton_implementation(WCXMPPTool)

#pragma mark - 用户登录
- (void)xmppLogin:(XMPPResultBlock)resultBlock{
    
    //强制断开连接
    [self disconnectToHost];
    
    _resultBlock = resultBlock;
    //连接服务器
    [self connectToHost];
}

#pragma mark 用户注册
- (void)xmppRegister:(XMPPResultBlock)resultBlock{

    /**注册步骤
     1.发送"注册jid"给服务器,请求一个长连接
     2.连接成功,发送注册密码
     */
    
    //强制断开
    [self disconnectToHost];

    //保存block
    _resultBlock = resultBlock;
    //连接服务器
    [self connectToHost];
}

#pragma mark 用户注销
- (void)xmppLogout{
    //发送离线状态
    [self sendOffline];
    //断开服务器连接
    [self disconnectToHost];
}

#pragma mark - 私有方法
#pragma mark 连接主机
- (void)connectToHost{
    
    if (!_xmppStream) {
        [self setupStream];
    }
    
    XMPPJID *myJid = nil;
    
    WCAccount *account = [WCAccount shareAccount];
    _account = account;
    if (self.isRegisterOpteration) {//注册
        myJid = [XMPPJID jidWithUser:account.registerUser domain:account.domin resource:nil];
    }else{//登录
        myJid = [XMPPJID jidWithUser:account.LoginUser domain:account.domin resource:nil];
    }
    //1.设置jid
    _xmppStream.myJID = myJid;
    //2.设置主机地址
    _xmppStream.hostName = account.host;
    //3.设置主机端口 (默认5222,可以不用设置)
    _xmppStream.hostPort = account.port;
    
    //4.发起连接
    NSError *error;
    //缺少必要的参数时就会发起连接失败
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        NSLog(@"%@",error);
    }else{
        NSLog(@"发起连接成功");
    }
}

#pragma mark 初始化Steam
- (void)setupStream{
    
    //创建XMPPStream
    _xmppStream = [[XMPPStream alloc]init];
    
    //添加xmpp模块
    //添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    //激活
    [_vCard activate:_xmppStream];
    
    //电子名片模块会配置头像模块一起使用
    //添加 头像模块
    _avatar = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    
    //添加花名册模块
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc]init];
    _roster = [[XMPPRoster alloc]initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    
    //添加消息模块
    _megArchivingStorage = [[XMPPMessageArchivingCoreDataStorage alloc]init];
    _megArchiving = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_megArchivingStorage];
    [_megArchiving activate:_xmppStream];
    
    //设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}

#pragma mark 卸载stream
- (void)teardownStream{

    //取消代理
    [_xmppStream removeDelegate:self];
    
    //取消激活模块
    [_vCard deactivate];
    [_avatar deactivate];
    [_roster deactivate];
    [_megArchiving deactivate];
    
    //清空资源
    _megArchiving = nil;
    _megArchivingStorage = nil;
    _xmppStream = nil;
    _vCardStorage = nil;
    _vCard = nil;
    _avatar = nil;
    _rosterStorage = nil;
    _roster = nil;
    
}

- (void)dealloc{
    [self teardownStream];
}

#pragma mark - XMPPStream的代理
#pragma mark 连接建立成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    NSError *error;
    if (self.isRegisterOpteration) {//注册
        //连接成功之后,发送注册密码
        [_xmppStream registerWithPassword:_account.registerPwd error:&error];
    }else{//登录
        //连接成功之后,发送登录密码
        [_xmppStream authenticateWithPassword:_account.LoginPwd error:&error];
    }
    if (error) {
        NSLog(@"%@",error);
    }
}

#pragma mark - 登录成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    [self sendOnline];
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
}

#pragma mark 登录失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
}

#pragma mark - 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
}

#pragma mark 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterFailure);
    }
}

#pragma mark 发送在线消息
- (void)sendOnline{
    //发送在线消息
    //xmpp框架,已经把所有的指令封闭成对象
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
    
}

#pragma mark 发送离线消息
- (void)sendOffline{
    
    //发送离线消息
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
}

#pragma mark 断开连接
- (void)disconnectToHost{
    
    [_xmppStream disconnect];
}

@end
