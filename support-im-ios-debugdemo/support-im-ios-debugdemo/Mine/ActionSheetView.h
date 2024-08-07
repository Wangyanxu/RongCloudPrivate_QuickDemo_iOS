//
//  ActionSheetView.h
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActionSheetView : UIView

-(instancetype)initWithCancleTitle:(NSString *)cancleTitle withOtherTitles:(NSArray *)titles compete:(void (^)(NSString *title))competeBlock;

-(void)show;

@end

NS_ASSUME_NONNULL_END
