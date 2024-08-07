//
//  CustomMediaMessage.m
//  support-im-ios-debugdemo
//
//  Created by 于艳平 on 2022/7/31.
//

#import "CustomMediaMessage.h"
#import <objc/runtime.h>

extern UIImage *generateThumbnailImage(UIImage *oringialImage);

UIImage *generateThumbnailImage(UIImage *oringialImage) {
    UIImage *thumbnailImage = [RCUtilities generateThumbnailByConfig:oringialImage];
    return thumbnailImage;
}
@interface CustomMediaMessage ()
@property (nonatomic, copy) NSString *thumbnailBase64String;
@end

@implementation CustomMediaMessage
///初始化
+ (instancetype)messageWithLocalPath:(NSString *)localPath {
    CustomMediaMessage *message = [[CustomMediaMessage alloc] init];
    if (message) {
        message.localPath = localPath ? localPath : @"";
        UIImage *originalImage = [UIImage imageWithContentsOfFile:localPath];
        message.thumbnailImage = generateThumbnailImage(originalImage);
    }
    return message;
}
///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.thumbnailImage = [aDecoder decodeObjectForKey:@"thumbnailImage"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
        self.localPath = [aDecoder decodeObjectForKey:@"localPath"];
        self.remoteUrl = [aDecoder decodeObjectForKey:@"remoteUrl"];
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.thumbnailImage forKey:@"thumbnailImage"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
    [aCoder encodeObject:self.localPath forKey:@"localPath"];
    [aCoder encodeObject:self.remoteUrl forKey:@"remoteUrl"];
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    NSData *imageData = UIImageJPEGRepresentation(self.thumbnailImage, 0.3);
    NSString *thumbnailBase64String = nil;
    if ([imageData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        thumbnailBase64String = [imageData base64EncodedStringWithOptions:kNilOptions];
    } else {
        thumbnailBase64String = [RCUtilities base64EncodedStringFrom:imageData];
    }
    
    if (thumbnailBase64String) {
        [dataDict setObject:thumbnailBase64String forKey:@"content"];
    }
    
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    if (self.senderUserInfo) {
        [dataDict setObject:[self encodeUserInfo:self.senderUserInfo] forKey:@"user"];
    }
    if (self.localPath.length > 0) {
        [dataDict setObject:self.localPath forKey:@"localPath"];
    };
    if (self.remoteUrl.length > 0) {
        [dataDict setObject:self.remoteUrl forKey:@"remoteUrl"];
    };

    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}


///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

        if (dictionary) {
            self.extra = dictionary[@"extra"];
            self.thumbnailBase64String = dictionary[@"content"];
            self.localPath = dictionary[@"localPath"];
            self.remoteUrl = dictionary[@"remoteUrl"];
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

- (UIImage *)thumbnailImage {
    if (!_thumbnailImage) {
        if (self.thumbnailBase64String) {
            NSData *imageData = nil;
            if (class_getInstanceMethod([NSData class], @selector(initWithBase64EncodedString:options:))) {
                imageData = [[NSData alloc] initWithBase64EncodedString:self.thumbnailBase64String
                                                                options:NSDataBase64DecodingIgnoreUnknownCharacters];
            } else {
                imageData = [RCUtilities dataWithBase64EncodedString:self.thumbnailBase64String];
            }
            self.thumbnailImage = [UIImage imageWithData:imageData];
        } else {
            RCLogI(@">>>>>>>> Error!!!!!!!! thumbnail is missing...");
        }
    }
    return _thumbnailImage;
}


/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    return @"自定义媒体消息";
}

///消息的类型名
+ (NSString *)getObjectName {
    return RCDCustomMediaMessageTypeIdentifier;
}
@end
