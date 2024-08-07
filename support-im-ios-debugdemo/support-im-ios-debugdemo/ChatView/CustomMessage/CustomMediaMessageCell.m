//
//  CustomMediaMessageCell.m
//  support-im-ios-debugdemo
//
//  Created by 于艳平 on 2022/7/31.
//

#import "CustomMediaMessageCell.h"
#import "CustomMediaMessage.h"
#define Message_Height 147
#define Message_Width 240


@implementation CustomMediaMessageCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self showBubbleBackgroundView:YES];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.messageContentView addSubview:self.imageView];

}

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    return CGSizeMake(collectionViewWidth, extraHeight + Message_Height);
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    [self setAutoLayout];
}

- (void)setAutoLayout {
    CustomMediaMessage *mediaMessage = (CustomMediaMessage *)self.model.content;
    CGSize bubbleBackgroundViewSize = CGSizeMake(Message_Width + 5, Message_Height + 5);
    //拉伸图片
    self.imageView.frame = CGRectMake(2.5, 2.5, Message_Width, Message_Height);
    self.messageContentView.contentSize = bubbleBackgroundViewSize;
    self.imageView.image = mediaMessage.thumbnailImage;
}
@end
