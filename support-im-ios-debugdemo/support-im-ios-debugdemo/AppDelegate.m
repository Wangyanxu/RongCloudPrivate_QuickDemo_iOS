//
//  AppDelegate.m
//  support-im-ios-debugdemo
//
//  Created by 于艳平 on 2022/7/11.
//

#import "AppDelegate.h"
#import "LoginVC.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRootController:) name:@"APP_LOGOUT_SUCESS_NOTIFICATION" object:nil];
    _window.backgroundColor = [UIColor whiteColor];
    [self configIMTalkWithApp:application andOptions:launchOptions];
    return YES;
}


- (void)refreshRootController:(NSNotification*)notification{

    UIStoryboard *msgSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *loginNavVC = [msgSb instantiateViewControllerWithIdentifier:@"NavigationStoryboardID"];
    [[UIApplication sharedApplication].keyWindow setRootViewController:loginNavVC];

}

- (void)configIMTalkWithApp:(UIApplication *)application andOptions:(NSDictionary *)launchOptions {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMessageNotification:)
                                                 name:RCKitDispatchMessageNotification
                                               object:nil];
    
    /**
     * 推送处理 1
     */
    [self registerRemoteNotification:application];
    
    /**
     * 统计推送，并获取融云推送服务扩展字段
     */
    [self recordLaunchOptions:launchOptions];
    
}

// app 进入后台调用此方法
- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([RCCoreClient sharedCoreClient].sdkRunningMode == RCSDKRunningMode_Background ) {
        
        int unreadMsgCount = [[RCCoreClient sharedCoreClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP)] containBlocked:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
        });
    }
}

// app 从后台进入前台调用此方法
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if ([RCCoreClient sharedCoreClient].sdkRunningMode == RCSDKRunningMode_Background) {
        int unreadMsgCount = [[RCCoreClient sharedCoreClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP)] containBlocked:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
        });
    }
}


- (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    NSNumber *left = [notification.userInfo objectForKey:@"left"];
    if ([RCCoreClient sharedCoreClient].sdkRunningMode == RCSDKRunningMode_Background && 0 == left.integerValue) {
        int unreadMsgCount = [[RCCoreClient sharedCoreClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_GROUP)] containBlocked:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
        });
    }
}


#pragma mark - private method
- (void)registerRemoteNotification:(UIApplication *)application {
    /**
     *  推送说明：
     *
     我们在知识库里还有推送调试页面加了很多说明，当遇到推送问题时可以去知识库里搜索还有查看推送测试页面的说明。
     *
     首先必须设置deviceToken，可以搜索本文件关键字“推送处理”。模拟器是无法获取devicetoken，也就没有推送功能。
     *
     当使用"开发／测试环境"的appkey测试推送时，必须用Development的证书打包，并且在后台上传"开发／测试环境"的推送证书，证书必须是development的。
     当使用"生产／线上环境"的appkey测试推送时，必须用Distribution的证书打包，并且在后台上传"生产／线上环境"的推送证书，证书必须是distribution的。
     */
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
            settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
                  categories:nil];
        [application registerUserNotificationSettings:settings];
#pragma clang diagnostic pop
    } else {
        //注册推送，用于iOS8之前的系统
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType myTypes =
            UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
#pragma clang diagnostic pop
    }
}

- (void)recordLaunchOptions:(NSDictionary *)launchOptions {
    /**
     * 获取融云推送服务扩展字段1
     */
    NSDictionary *pushServiceData = [[RCCoreClient sharedCoreClient] getPushExtraFromLaunchOptions:launchOptions];
    if (pushServiceData) {
        NSLog(@"该启动事件包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"%@", pushServiceData[key]);
        }
    } else {
        NSLog(@"该启动事件不包含来自融云的推送服务");
    }
    //打印原始的远程推送内容
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationUserInfo) {
        NSLog(@"远程推送原始内容为 %@", remoteNotificationUserInfo);
    }
}
/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
    didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    /*
     设置 deviceToken（已兼容 iOS 13），推荐使用，需升级 SDK 版本至 2.9.25
     不需要开发者对 deviceToken 进行处理，可直接传入。
     */
    
    NSLog(@"deviceToken=====%@",deviceToken);
    
    [[RCCoreClient sharedCoreClient] setDeviceTokenData:deviceToken];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {

}

/**
 * 推送处理4
 * userInfo内容请参考官网文档
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    /**
     * 统计推送打开率2
     */
    [[RCCoreClient sharedCoreClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段2
     */
    NSDictionary *pushServiceData = [[RCCoreClient sharedCoreClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    /**
     * 统计推送打开率3
     */
    [[RCCoreClient sharedCoreClient] recordLocalNotificationEvent:notification];
}

@end
