//
//  IMDataSource.m
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/28.
//

#import "IMDataSource.h"

@implementation IMDataSource


+ (IMDataSource *)sharedInstance {
    static IMDataSource *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}

#pragma mark - GroupInfoFetcherDelegate
- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup * groupInfo))completion {
    //开发者调自己的服务器接口，根据 groupId 异步请求群组信息
    if ([groupId length] == 0)
        return;
    RCGroup *groupInfoModel = [[RCGroup alloc] init];
    groupInfoModel.groupName = [NSString stringWithFormat:@"群组 %@",groupId];
    groupInfoModel.groupId = groupId;
    return completion(groupInfoModel);
}
#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion{
    //开发者调自己的服务器接口，根据 userID 异步请求用户信息
    if ([userId length] == 0)
        return;
    RCUserInfo *userInfoModel = [[RCUserInfo alloc] init];
    userInfoModel.userId = userId;
    userInfoModel.name = [NSString stringWithFormat:@"用户 %@",userId];
    
    int index = [self getRandomNumber:0 to:9];
    
    NSString * imge1 =@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Finews.gtimg.com%2Fnewsapp_bt%2F0%2F13617583465%2F1000.jpg&refer=http%3A%2F%2Finews.gtimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1662279145&t=89a2a4e3468cfe398fc41b54c3506c71";

    NSString * imge2 = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fedpic%2F62%2F3b%2Fe1%2F623be1bed1dcdbc71ee2dc3c28505aed.jpg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1662279208&t=6ddad26308b44841c3dc7afc7887ff2c";

    NSString * imge3 =@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Finews.gtimg.com%2Fnewsapp_bt%2F0%2F13715839860%2F641&refer=http%3A%2F%2Finews.gtimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1662279240&t=b800909ba8e8f52003d5b65d87b0e667";

    NSString * imge4 =@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fnimg.ws.126.net%2F%3Furl%3Dhttp%253A%252F%252Fdingyue.ws.126.net%252F2021%252F1202%252F5cef0995j00r3gz1h000tc000c800c8c.jpg%26thumbnail%3D650x2147483647%26quality%3D80%26type%3Djpg&refer=http%3A%2F%2Fnimg.ws.126.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1662279240&t=db4639039e2317a2b151839b6f70ca90";

    NSString * imge5 =@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Finews.gtimg.com%2Fnewsapp_bt%2F0%2F13905311255%2F1000.jpg&refer=http%3A%2F%2Finews.gtimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1662279286&t=d3f106091379d69813c17e848c8e3de4";

    NSString * imge6 =@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fn.sinaimg.cn%2Fsinakd2020328s%2F580%2Fw690h690%2F20200328%2F9beb-irpunaf9040343.jpg&refer=http%3A%2F%2Fn.sinaimg.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1662279286&t=d27a575e43509addad68174b7de85638";

    NSString * imge7 =@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi.qqkou.com%2Fi%2F0a3738897897x1113329549b26.jpg&refer=http%3A%2F%2Fi.qqkou.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1662279286&t=730373dac61ca3f708e896adfff37f2a";

    NSString * imge8 =@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Finews.gtimg.com%2Fnewsapp_bt%2F0%2F9434916430%2F1000.jpg&refer=http%3A%2F%2Finews.gtimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1662279367&t=aac3e44df012726012c500dce283bc41";

    NSString * imge9 =@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi.qqkou.com%2Fi%2F0a274095798x2052101250b26.jpg&refer=http%3A%2F%2Fi.qqkou.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1662279368&t=001f308642c3a196b9cb8d9d2026e881";

    NSString * imge10 =@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fnimg.ws.126.net%2F%3Furl%3Dhttp%253A%252F%252Fdingyue.ws.126.net%252FuPedPaMCtutVUiIzg21%253DZvjFJuqzZ9T8kYMMqMGZdJ4ig1519569380474compressflag.jpeg%26thumbnail%3D650x2147483647%26quality%3D80%26type%3Djpg&refer=http%3A%2F%2Fnimg.ws.126.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1662279421&t=7e9220f3f4d1fb4c3502c2b43409d4b1";
    
    
    
    
    NSArray * imgesArr = @[imge1,imge2,imge3,imge4,imge5,imge6,imge7,imge8,imge9,imge10];
    
    NSLog(@"随机数======%d",index);
    
    userInfoModel.portraitUri = imge1;
    
    return completion(userInfoModel);
}

// 获得随机数
-(int)getRandomNumber:(int)from to:(int)to{

    return (int)(from + (arc4random()%to - from + 1));
}


#pragma mark - RCIMGroupUserInfoDataSource
/**
 *  获取群组内的用户信息。
 *  如果群组内没有设置用户信息，请注意：1，不要调用别的接口返回全局用户信息，直接回调给我们nil就行，SDK会自己巧用用户信息提供者；2一定要调用completion(nil)，这样SDK才能继续往下操作。
 *
 *  @param groupId  群组ID.
 *  @param completion 获取完成调用的BLOCK.
 */
- (void)getUserInfoWithUserId:(NSString *)userId
                      inGroup:(NSString *)groupId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    //在这里查询该group内的群名片信息，如果能查到，调用completion返回。如果查询不到也一定要调用completion(nil)
    
    if([groupId isEqualToString:@"1101"] && [userId isEqualToString:@"1002"]){
        RCUserInfo *userInfo = [[RCUserInfo alloc] init];
        userInfo.userId = userId;
        return completion(userInfo);
    }
}

#pragma mark - RCIMGroupMemberDataSource
- (void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *))resultBlock {
    
}

#pragma mark - 消息接收监听
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    
}
@end
