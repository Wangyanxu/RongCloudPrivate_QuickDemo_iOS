//
//  AppGlobalConfig.m
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/25.
//

#import "AppGlobalConfig.h"

@implementation AppGlobalConfig

+ (instancetype)shareInstance {
    static AppGlobalConfig *_sharedGlobalConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedGlobalConfig = [[AppGlobalConfig alloc] init];
       
    });
    return _sharedGlobalConfig;
}
//appKey  从融云开发者平台创建应用后获取到的 App Key
- (void)setAppKey:(NSString * _Nonnull)appKey{
    if (appKey.length <=0) {return;}
    [[NSUserDefaults standardUserDefaults] setObject:appKey forKey:@"appKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)appKey{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"appKey"];
}

- (void)removeAppkey{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"appKey"];
}
//token   从您服务器端获取的 token (用户身份令牌)
- (void)setToken:(NSString * _Nonnull)token{
    if (token.length <=0) {return;}
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)token{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

- (void)removeToken{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
}

- (void)setSecret:(NSString * _Nonnull)secret{
    if (secret.length <=0) {return;}
    [[NSUserDefaults standardUserDefaults] setObject:secret forKey:@"secret"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)secret{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"secret"];
}

- (void)removeSecret{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"secret"];
}

- (void)setUserId:(NSString *)userId{
    if (userId.length <=0) {return;}
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)userId{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
}

- (void)removeUserId{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
}

- (void)setDisplayConversationTypeArray:(NSArray * _Nonnull)displayConversationTypeArray{
    if (displayConversationTypeArray.count <=0) {return;}
    [[NSUserDefaults standardUserDefaults] setObject:displayConversationTypeArray forKey:@"displayConversationTypeArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)displayConversationTypeArray{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"displayConversationTypeArray"];
}

- (void)setCollectionConversationTypeArray:(NSArray * _Nonnull)collectionConversationTypeArray{
    if (collectionConversationTypeArray.count <=0) {return;}
    [[NSUserDefaults standardUserDefaults] setObject:collectionConversationTypeArray forKey:@"collectionConversationTypeArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)collectionConversationTypeArray{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"collectionConversationTypeArray"];
}
//导航服务器地址
- (void)setNaviServer:(NSString * _Nonnull)naviServer{
    if (naviServer.length <=0) {return;}
    [[NSUserDefaults standardUserDefaults] setObject:naviServer forKey:@"naviServer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (NSString *)naviServer{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"naviServer"];
}
//文件服务器地址
- (void)setFileServer:(NSString * _Nonnull)fileServer{
    if (fileServer.length <=0) {return;}
    [[NSUserDefaults standardUserDefaults] setObject:fileServer forKey:@"fileServer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (NSString *)fileServer{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"fileServer"];
}

#pragma mark - GROUP
- (NSString *)groupId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"groupId"];
}
- (void)setGroupId:(NSString *)groupId {
    if (groupId.length <= 0) {return;}
    [[NSUserDefaults standardUserDefaults] setObject:groupId forKey:@"groupId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeGroupId {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"groupId"];
}

#pragma mark UltraGroup
- (NSString *)ultraGroupId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ultraGroupId"];
}
- (void)setUltraGroupId:(NSString * _Nonnull)ultraGroupId {
    if (ultraGroupId.length <= 0) {return;}
    [[NSUserDefaults standardUserDefaults] setObject:ultraGroupId forKey:@"ultraGroupId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeUltraGroupId {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ultraGroupId"];
}

- (NSString *)channelId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"channelId"];
}

- (void)setChannelId:(NSString * _Nonnull)channelId {
    if (channelId.length <= 0) {return;}
    [[NSUserDefaults standardUserDefaults] setObject:channelId forKey:@"channelId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeChannelId {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"channelId"];
}

@end
