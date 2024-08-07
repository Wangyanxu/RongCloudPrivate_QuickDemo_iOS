//
//  MineModel.m
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/13.
//

#import "MineModel.h"

@implementation MineModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        if ([dict objectForKey:@"header"]) {
            NSDictionary * headerDict = [dict objectForKey:@"header"];
            self.haderModel = [[MineHaderModel alloc] initWithDictionary:headerDict];
        }
      
        if ([dict objectForKey:@"list"]) {
            NSArray * tempArr = [dict objectForKey:@"list"];
            NSMutableArray * mutArr = @[].mutableCopy;
            for (NSDictionary * tempDict in tempArr) {
                MineListModel * listModel = [[MineListModel alloc] initWithDictionary:tempDict];
                [mutArr addObject:listModel];
            }
            self.listArr = mutArr.copy;
        }
    }
    return self;
}
@end


@implementation MineHaderModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end


@implementation MineListModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
