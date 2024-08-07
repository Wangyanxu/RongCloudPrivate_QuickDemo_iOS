//
//  PopoverViewCell.h
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/27.
//

#import <UIKit/UIKit.h>
#import "PopoverAction.h"

UIKIT_EXTERN float const PopoverViewCellHorizontalMargin;
UIKIT_EXTERN float const PopoverViewCellVerticalMargin;
UIKIT_EXTERN float const PopoverViewCellTitleLeftEdge;

NS_ASSUME_NONNULL_BEGIN

@interface PopoverViewCell : UITableViewCell

@property (nonatomic, assign) PopoverViewStyle style;

+ (UIFont *)titleFont;

+ (UIColor *)bottomLineColorForStyle:(PopoverViewStyle)style;

- (void)setAction:(PopoverAction *)action;

- (void)showBottomLine:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
