1.在 podfile 文件中导入 SDK:
  pod 'RongCloudIM_Private', '5.6.2.50'
2.配置初始化 SDK 参数:
```objective-c
    // 配置初始化参数
    RCInitOption *option = [[RCInitOption alloc] init];
    // 配置导航地址服务
    option.naviServer = @"your naviServerUrl";
    // 配置文件服务; RCX 服务的需要设置文件服务器地址,FCS 服务不需要设置文件服务器地址
    option.fileServer = @"";
    // 配置内外网;字段取值有 内网：intranet、外网：extranet、其他：others、默认：default (外网)
    option.environment = @"";
    // 初始化 SDK
    [[RCIM sharedRCIM] initWithAppKey:@"your appkey" option:option];
```
3.连接 IM
```objective-c
    [[RCIM sharedRCIM] connectWithToken:@"your token" dbOpened:^(RCDBErrorCode code) {
    } success:^(NSString *userId) {
    } error:^(RCConnectErrorCode errorCode) {    
    }];
```
4.集成会话列表页面以及聊天页面:
https://doc.rongcloud.cn/im/IOS/5.X/ui/key-functions/conversation-list
https://doc.rongcloud.cn/im/IOS/5.X/ui/key-functions/conversation
5.更多功能:
https://doc.rongcloud.cn/im/IOS/5.X/ui/imkit-config-guide
6.注意事项:
如果导航 https 证书用了自签名，需要在原生端配置下 ssl 证书忽略  https://help.rongcloud.cn/t/topic/883
如何获取本地 log 请参考: https://help.rongcloud.cn/t/topic/871


Demo 代码结构:
初始化登录配置: LoginVC
会话列表页面: ChatListVC
会话页面: ChatVC
自定义消息参考:  CustomMessage
