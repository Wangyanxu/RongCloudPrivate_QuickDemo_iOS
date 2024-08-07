//
//  PopoverAction.h
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, PopoverViewStyle) {
    PopoverViewStyleDefault = 0,
    PopoverViewStyleDark,
};

@interface PopoverAction : NSObject


@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) void(^handler)(PopoverAction *action);

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(PopoverAction *action))handler;

+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(void (^)(PopoverAction *action))handler;

@end

NS_ASSUME_NONNULL_END
