//
//  CustomMediaMessage.h
//  support-im-ios-debugdemo
//
//  Created by 于艳平 on 2022/7/31.
//

#import <RongIMLibCore/RongIMLibCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomMediaMessage : RCMediaMessageContent <NSCoding>


/*!
 图片消息的缩略图
 */
@property (nonatomic, strong) UIImage *thumbnailImage;

/*!
 初始化

 @param localPath       本地路径
 @return            自定义消息对象
 */
+ (instancetype)messageWithLocalPath:(NSString *)localPath;

@end

NS_ASSUME_NONNULL_END
