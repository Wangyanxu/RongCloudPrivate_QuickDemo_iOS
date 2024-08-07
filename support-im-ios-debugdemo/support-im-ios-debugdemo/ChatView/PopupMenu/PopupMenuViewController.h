//
//  PopupMenuViewController.h
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopupMenuViewController : UIViewController

@property (nonatomic, copy) void (^startChatMessageBlock)(RCConversationType conversationType, NSString *targetId);

@end

NS_ASSUME_NONNULL_END
