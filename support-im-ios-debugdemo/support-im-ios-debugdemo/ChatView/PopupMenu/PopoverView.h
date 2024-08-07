//
//  PopoverView.h
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/27.
//

#import <UIKit/UIKit.h>
#import "PopoverAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface PopoverView : UIView

@property (nonatomic, assign) BOOL hideAfterTouchOutside;

@property (nonatomic, assign) BOOL showShade;

@property (nonatomic, assign) PopoverViewStyle style;

+ (instancetype)popoverView;

- (void)showToView:(UIView *)pointView withActions:(NSArray<PopoverAction *> *)actions;


- (void)showToPoint:(CGPoint)toPoint withActions:(NSArray<PopoverAction *> *)actions;

@end

NS_ASSUME_NONNULL_END
