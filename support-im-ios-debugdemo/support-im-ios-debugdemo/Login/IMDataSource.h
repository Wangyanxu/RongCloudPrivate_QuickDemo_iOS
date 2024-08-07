//
//  IMDataSource.h
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/28.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

#define RCDataSource [IMDataSource sharedInstance]

@interface IMDataSource : NSObject <RCIMUserInfoDataSource, RCIMGroupInfoDataSource, RCIMGroupUserInfoDataSource, RCIMGroupMemberDataSource, RCIMReceiveMessageDelegate>

+ (IMDataSource *)sharedInstance;


@end

NS_ASSUME_NONNULL_END
