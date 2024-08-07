//
//  CustomMessageCell.m
//  support-im-ios-debugdemo
//
//  Created by 于艳平 on 2022/7/31.
//

#import "CustomMessageCell.h"
#define Message_Font_Size 16

@implementation CustomMessageCell

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
    if(self.model.messageDirection == MessageDirection_RECEIVE){
        [self.textLabel setTextColor:[RCKitUtility generateDynamicColor:HEXCOLOR(0x262626) darkColor:RCMASKCOLOR(0xffffff, 0.8)]];
    }else{
        [self.textLabel setTextColor:RCDYCOLOR(0x262626, 0x040A0F)];
    }
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.textLabel setFont:[UIFont systemFontOfSize:Message_Font_Size]];

    self.textLabel.numberOfLines = 0;
    [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.textLabel setTextAlignment:NSTextAlignmentLeft];
    [self.messageContentView addSubview:self.textLabel];
    
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.bubbleBackgroundView addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
}

- (void)tapAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];

    [self setAutoLayout];
}

- (void)setAutoLayout {
    RCMessage *message = [[RCCoreClient sharedCoreClient] getMessage:self.model.messageId];
    CustomMessage *testMessage = (CustomMessage *)self.model.content;
    NSDictionary *dict = message.expansionDic;
    NSString *value = @"0";
    if ([dict.allKeys containsObject:@"count"]) {
        value = dict[@"count"];
    }
    if (testMessage) {
        self.textLabel.text = [NSString stringWithFormat:@"%@\n消息扩展：count：%@", testMessage.content,value];
    }

    CGSize textLabelSize = [[self class] getTextLabelSize:self.textLabel.text];
    CGSize bubbleBackgroundViewSize = [[self class] getBubbleSize:textLabelSize];
    //拉伸图片
    self.textLabel.frame = CGRectMake(12, (bubbleBackgroundViewSize.height - textLabelSize.height)/2, textLabelSize.width, textLabelSize.height);
    self.messageContentView.contentSize = bubbleBackgroundViewSize;
}

+ (CGSize)getTextLabelSize:(NSString *)text {
    if ([text length] > 0) {
        CGRect textRect = [text
            boundingRectWithSize:CGSizeMake([RCMessageCellTool getMessageContentViewMaxWidth], 8000)
                         options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
                                  NSStringDrawingUsesFontLeading)
                      attributes:@{
                          NSFontAttributeName : [UIFont systemFontOfSize:Message_Font_Size]
                      }
                         context:nil];
        textRect.size.height = ceilf(textRect.size.height);
        textRect.size.width = ceilf(textRect.size.width);
        return CGSizeMake(textRect.size.width + 5, textRect.size.height + 5);
    } else {
        return CGSizeZero;
    }
}


+ (CGSize)getBubbleSize:(CGSize)textLabelSize {
    CGSize bubbleSize = CGSizeMake(textLabelSize.width, textLabelSize.height);

    if (bubbleSize.width + 12 + 12 > 50) {
        bubbleSize.width = bubbleSize.width + 12 + 12;
    } else {
        bubbleSize.width = 50;
    }
    if (bubbleSize.height + 7 + 7 > 40) {
        bubbleSize.height = bubbleSize.height + 7 + 7;
    } else {
        bubbleSize.height = 40;
    }

    return bubbleSize;
}


+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    RCMessage *msg= [[RCCoreClient sharedCoreClient] getMessage:model.messageId];
    CustomMessage *message = (CustomMessage *)model.content;
    NSDictionary *dict = msg.expansionDic;
    NSString *value = @"0";
    if ([dict.allKeys containsObject:@"count"]) {
        value = dict[@"count"];
    }
    NSString *text = [NSString stringWithFormat:@"%@\n，消息扩展：count：%@", message.content,value];
    CGSize size = [CustomMessageCell getBubbleBackgroundViewSize:text];

    CGFloat __messagecontentview_height = size.height;

    if (__messagecontentview_height < RCKitConfigCenter.ui.globalMessagePortraitSize.height) {
        __messagecontentview_height = RCKitConfigCenter.ui.globalMessagePortraitSize.height;
    }

    __messagecontentview_height += extraHeight;

    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}


+ (CGSize)getBubbleBackgroundViewSize:(NSString *)text {
    CGSize textLabelSize = [[self class] getTextLabelSize:text];
    return [[self class] getBubbleSize:textLabelSize];
}


@end
