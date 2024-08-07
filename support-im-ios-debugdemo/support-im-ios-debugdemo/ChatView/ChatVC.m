//
//  ChatVC.m
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/27.
//

#import "ChatVC.h"
#import "CustomMessage.h"
#import "CustomMessageCell.h"
#import "CustomMediaMessage.h"
#import "CustomMediaMessageCell.h"

@interface ChatVC ()<RCMessageExpansionDelegate>

@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.chatSessionInputBarControl.pluginBoardView insertItem:[UIImage imageNamed:@"customMessage"] highlightedImage:[UIImage imageNamed:@"customMessage"] title:@"自定义消息" tag:20080];
    [self.chatSessionInputBarControl.pluginBoardView insertItem:[UIImage imageNamed:@"customMediaMessage"] highlightedImage:[UIImage imageNamed:@"customMediaMessage"] title:@"自定义媒体消息" tag:20090];
    [RCCoreClient sharedCoreClient].messageExpansionDelegate = self;
    
    
}

// SDK >= 5.2.4 注册自定义消息Cell
- (void)registerCustomCellsAndMessages {
    [super registerCustomCellsAndMessages];
    ///注册自定义测试消息Cell
    [self registerClass:[CustomMessageCell class] forMessageClass:[CustomMessage class]];
    [self registerClass:[CustomMediaMessageCell class] forMessageClass:[CustomMediaMessage class]];
}


// 处理扩展项点击事件
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    if (tag == 20080) {
        CustomMessage *message = [CustomMessage messageWithContent:@"自定义消息\n点击自定义消息更新消息扩展"];
        RCMessage *msg = [[RCMessage alloc] initWithType:self.conversationType targetId:self.targetId direction:MessageDirection_SEND content:message];
        msg.canIncludeExpansion = YES;
        msg.expansionDic = @{@"count":@"0"};
        [[RCIM sharedRCIM] sendMessage:msg pushContent:@"自定义消息" pushData:nil successBlock:^(RCMessage *successMessage) {
            
        } errorBlock:^(RCErrorCode nErrorCode, RCMessage *errorMessage) {
            
        }];
    } else if (tag == 20090) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"rc" ofType:@"png"];
        CustomMediaMessage *message = [CustomMediaMessage messageWithLocalPath:filePath];
        [[RCIM sharedRCIM] sendMediaMessage:self.conversationType targetId:self.targetId content:message pushContent:@"自定义媒体消息" pushData:nil progress:^(int progress, long messageId) {
            
        } success:^(long messageId) {
            
        } error:^(RCErrorCode errorCode, long messageId) {
            
        } cancel:^(long messageId) {
            
        }];
    } else {
        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    }
}

- (void)didTapMessageCell:(RCMessageModel *)model {
    if ([model.objectName isEqualToString:RCDCustomMessageTypeIdentifier]) {
        RCMessage *msg = [[RCCoreClient sharedCoreClient] getMessage:model.messageId];
        NSDictionary *dict = msg.expansionDic;
        NSInteger value = 0;
        if ([dict.allKeys containsObject:@"count"]) {
            NSString *v = dict[@"count"];
            value = v.integerValue;
        }
        [[RCCoreClient sharedCoreClient] updateMessageExpansion:@{@"count":[NSString stringWithFormat:@"%ld", value + 1]} messageUId:model.messageUId success:^{
            NSUInteger row = [self.conversationDataRepository indexOfObject:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.conversationMessageCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            });
            
        } error:^(RCErrorCode status) {
            
        }];
    } else {
        [super didTapMessageCell:model];
    }
}

// 消息扩展信息更改的回调
- (void)messageExpansionDidUpdate:(NSDictionary<NSString *,NSString *> *)expansionDic message:(RCMessage *)message {
    for (int i = 0; i < self.conversationDataRepository.count; i++) {
        RCMessageModel *model = self.conversationDataRepository[i];
        if ([model.messageUId isEqualToString:message.messageUId]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.conversationMessageCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            });
            break;
        }
    }
}


//消息扩展信息删除的回调

- (void)messageExpansionDidRemove:(NSArray<NSString *> *)keyArray
                          message:(RCMessage *)message {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)notifyUpdateUnreadMessageCount{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBadgeValueNotification" object:nil];
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
