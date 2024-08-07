//
//  CustomMessage.h
//  support-im-ios-debugdemo
//
//  Created by 于艳平 on 2022/7/30.
//

#import <RongIMLibCore/RongIMLibCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomMessage : RCMessageContent <NSCoding>

@property (nonatomic, strong) NSString *content;

/*!
 初始化自定义消息

 @param content 文本内容
 @return        自定义消息对象
 */
+ (instancetype)messageWithContent:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
