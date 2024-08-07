//
//  MineModel.h
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MineHaderModel;
@class MineListModel;

@interface MineModel : NSObject

@property (nonatomic, strong) MineHaderModel *haderModel;
@property (nonatomic, strong) NSArray <MineListModel *> *listArr;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface MineHaderModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *avatar;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end


@interface MineListModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *isOpen;
@property (nonatomic, strong) NSString *listId;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
