//
//  CustomMessageCell.h
//  support-im-ios-debugdemo
//
//  Created by 于艳平 on 2022/7/31.
//

#import <RongIMKit/RongIMKit.h>
#import "CustomMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomMessageCell : RCMessageCell
/*!
 文本内容的Label
*/
@property (strong, nonatomic) UILabel *textLabel;

@end

NS_ASSUME_NONNULL_END
