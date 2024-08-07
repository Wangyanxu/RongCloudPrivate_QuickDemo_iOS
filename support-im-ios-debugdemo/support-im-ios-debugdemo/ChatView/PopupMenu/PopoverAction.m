//
//  PopoverAction.m
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/27.
//

#import "PopoverAction.h"

@interface  PopoverAction ()

@property (nonatomic, strong, readwrite) UIImage *image;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) void(^handler)(PopoverAction *action);

@end

@implementation PopoverAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(PopoverAction *action))handler {
    return [self actionWithImage:nil title:title handler:handler];
}

+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(void (^)(PopoverAction *action))handler {
    PopoverAction *action = [[self alloc] init];
    action.image = image;
    action.title = title ? : @"";
    action.handler = handler ? : NULL;
    
    return action;
}

@end
