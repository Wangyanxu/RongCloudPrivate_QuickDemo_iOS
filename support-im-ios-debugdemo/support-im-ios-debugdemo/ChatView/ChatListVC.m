//
//  ChatListVC.m
//  support-im-ios-debugdemo
//
//  Created by 于艳平 on 2022/7/11.
//

#import "ChatListVC.h"
#import "PopoverView.h"
#import "PopupMenuViewController.h"
#import "ChatVC.h"

@interface ChatListVC ()

@property (nonatomic, strong) UIButton *menuButton;
@end

@implementation ChatListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"会话列表";
    [self setNavigationItem];
    
    
}

- (void)setNavigationItem{
    
    RCButton *menuButton = [RCButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, 44, 44);
    [menuButton setImage:[UIImage imageNamed:@"chat_add"] forState:UIControlStateNormal];
    self.menuButton = menuButton;
    [menuButton addTarget:self action:@selector(didClickAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)didClickAction{
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.showShade = YES;
    [popoverView showToView:self.menuButton withActions:[self menuAction]];
}

#pragma mark - Getter && Setter
- (NSArray<PopoverAction *> *)menuAction {
    __weak typeof(self) weakSelf = self;
    PopoverAction *chatAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"chat_message"] title:@"发起聊天" handler:^(PopoverAction *action) {
        
        PopupMenuViewController *popVC = [[PopupMenuViewController alloc] init];
        
        [popVC setStartChatMessageBlock:^(RCConversationType conversationType, NSString * _Nonnull targetId) {
            // 发起聊天
            ChatVC * chatVC = [[ChatVC alloc] init];
            chatVC.conversationType = conversationType;
            chatVC.targetId = targetId;
            chatVC.hidesBottomBarWhenPushed = YES;
            chatVC.enableNewComingMessageIcon = YES; //开启消息提醒
            chatVC.enableUnreadMessageIcon = YES;//显示右上角的未读消息数按钮
            if (conversationType == ConversationType_GROUP) {
                RCGroup * groupInfo = [[RCIM sharedRCIM] getGroupInfoCache:targetId];
                chatVC.title = groupInfo.groupName;
            } else if (conversationType == ConversationType_PRIVATE) {
                //显示发送方用户名
                chatVC.displayUserNameInCell = NO;
                //设置默认拉取消息数
                chatVC.defaultLocalHistoryMessageCount = 20;
                RCUserInfo * userInfo = [[RCIM sharedRCIM] getUserInfoCache:targetId];
                chatVC.title = userInfo.name;
            }
            [weakSelf.navigationController pushViewController:chatVC animated:YES];
        }];
        popVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        popVC.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
        [weakSelf presentViewController:popVC animated:YES completion:nil];
        
    }];
    return @[chatAction];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    ChatVC *vc = [[ChatVC alloc] initWithConversationType:model.conversationType targetId:model.targetId];
    vc.title = model.conversationTitle;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


//收到消息监听
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    //调用父类刷新未读消息数
    [super didReceiveMessageNotification:notification];
    //刷新UI 
    [super refreshConversationTableViewIfNeeded];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBadgeValueNotification" object:nil];
}

/*!
 即将更新未读消息数的回调，该方法在非主线程回调，如果想在本方法中操作 UI，请手动切换到主线程。

 @discussion 当收到消息或删除会话时，会调用此回调，您可以在此回调中执行未读消息数相关的操作。
 */
- (void)notifyUpdateUnreadMessageCount{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBadgeValueNotification" object:nil];
}
@end
