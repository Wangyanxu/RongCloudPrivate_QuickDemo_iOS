//
//  TabBarController.m
//  support-im-ios-debugdemo
//
//  Created by 于艳平 on 2022/7/11.
//

#import "TabBarController.h"
#import "ChatListVC.h"
#import "MineVC.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //没有值 设置默认值
    NSArray *displayConversationTypeArray = [AppGlobalConfig shareInstance].displayConversationTypeArray;
    if(displayConversationTypeArray.count <=0){
        displayConversationTypeArray = @[@(ConversationType_PRIVATE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)];
        [[AppGlobalConfig shareInstance] setDisplayConversationTypeArray:displayConversationTypeArray];
    }
    //没有值 设置默认值
    NSArray *collectionTypeArray = [AppGlobalConfig shareInstance].collectionConversationTypeArray;
    if (collectionTypeArray.count <=0) {
        collectionTypeArray = @[@(ConversationType_SYSTEM)];
        [[AppGlobalConfig shareInstance] setCollectionConversationTypeArray:collectionTypeArray];
    }
    
    ChatListVC *listVC = [[ChatListVC alloc] initWithDisplayConversationTypes:displayConversationTypeArray collectionConversationType:collectionTypeArray];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:listVC];
    UIImage *normalImageNav1 = [[UIImage imageNamed:@"tabbar_chat"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImageNav1 = [[UIImage imageNamed:@"tabbar_chat_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"会话"
                                                   image:normalImageNav1
                                           selectedImage:selectedImageNav1];
    
    
    MineVC *mineVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MineVC"];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:mineVC];

    UIImage *normalImageNav3 = [[UIImage imageNamed:@"tabbar_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImageNav3 = [[UIImage imageNamed:@"tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                   image:normalImageNav3
                                           selectedImage:selectedImageNav3];

    
    self.viewControllers = @[nav1, nav3];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBadgeValueForTabBarItem)
                                                 name:@"updateBadgeValueNotification"
                                               object:nil];
    
    
}


- (void)updateBadgeValueForTabBarItem{
    //获取所有会话未读数
    
    NSArray *displayConversationTypeArray = [AppGlobalConfig shareInstance].displayConversationTypeArray;
    int badgeValue = [[RCCoreClient sharedCoreClient] getUnreadCount:displayConversationTypeArray containBlocked:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        UITabBarItem *chatBarItem = [[[self tabBar] items] objectAtIndex:0];
        [chatBarItem setBadgeValue:badgeValue > 0 ? (badgeValue < 100 ? [@(badgeValue) stringValue] : @"99+") : nil];
    });
    
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
