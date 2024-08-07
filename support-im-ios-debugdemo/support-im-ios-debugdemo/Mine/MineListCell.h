//
//  MineListCell.h
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/13.
//

#import <UIKit/UIKit.h>
#import "MineModel.h"

NS_ASSUME_NONNULL_BEGIN


@class MineListCell;

@protocol MineListCellDelegate <NSObject>

- (void)tableViewCell:(MineListCell *)mineListCell didSelectLauguageMineListModel:(nonnull MineListModel *)listModel;

- (void)tableViewCell:(MineListCell *)mineListCell didSetProfileListModel:(MineListModel *)listModel;

@end


@interface MineListCell : UITableViewCell

@property (nonatomic ,strong) MineListModel * listModel;

@property (nonatomic ,weak) id<MineListCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
