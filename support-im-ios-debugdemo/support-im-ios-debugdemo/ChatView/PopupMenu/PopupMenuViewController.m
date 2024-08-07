//
//  PopupMenuViewController.m
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/27.
//

#import "PopupMenuViewController.h"
#import "ActionSheetView.h"

@interface PopupMenuViewController ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;
// 取消
@property (nonatomic, strong) UIButton *cancelButton;
// 发起
@property (nonatomic, strong) UIButton *beginButton;

@property (nonatomic, strong) UIView *theLine;

@property (nonatomic, strong) UIButton * conversationTypeBtn;

@property (nonatomic, strong) UITextField * targetIdTextField;

@property (nonatomic, strong) UIView *theMarginLine;

@property (nonatomic, assign) RCConversationType conversationType;

@end

@implementation PopupMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //Register for notifications and listen for keyboard disappearance events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [self addSubViews];
}

- (void)addSubViews {
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    [self.view addSubview:self.containerView];
    
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.contentLabel];
    [self.containerView addSubview:self.cancelButton];
    [self.containerView addSubview:self.beginButton];
    [self.containerView addSubview:self.theLine];
    [self.containerView addSubview:self.theMarginLine];
    [self.containerView addSubview:self.conversationTypeBtn];
    [self.containerView addSubview:self.targetIdTextField];
    
    CGFloat width  = MIN((SCREEN_WIDTH - 100) , 280);
    CGFloat height = 310.0/280 * width;
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.equalTo(@(height));
        make.width.equalTo(@(width));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.containerView.mas_top).offset(12);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.leading.equalTo(self.containerView.mas_leading).offset(24);
        make.trailing.equalTo(self.containerView.mas_trailing).offset(-24);
        make.height.equalTo(@(45));
    }];
    
    [self.conversationTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(15);
        make.leading.equalTo(self.containerView.mas_leading).offset(24);
        make.trailing.equalTo(self.containerView.mas_trailing).offset(-24);
        make.height.equalTo(@(45));
    }];
    
    [self.targetIdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.conversationTypeBtn.mas_bottom).offset(8);
        make.leading.equalTo(self.containerView.mas_leading).offset(24);
        make.trailing.equalTo(self.containerView.mas_trailing).offset(-24);
        make.height.equalTo(@(45));
    }];

    [self.theLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.bottom.equalTo(self.cancelButton.mas_top).mas_offset(-16);
        make.height.equalTo(@(0.5));
    }];

    [self.theMarginLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.theLine.mas_bottom);
        make.bottom.equalTo(self.containerView.mas_bottom).mas_offset(-0.5);
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.width.equalTo(@(0.5));
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-16);
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.leading.equalTo(@(20));
    }];
    
    [self.beginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-16);
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.trailing.equalTo(@(-20));
    }];
}
#pragma mark - Button Action
- (void)cancelBtnClickAction {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)beginBtnClickAction {
    
    if([self.conversationTypeBtn.titleLabel.text isEqualToString:@" 请选择聊天类型"]){
        [RCAlertView showAlertController:@"标题" message:@"请选择聊天类型" cancelTitle:@"确定" inViewController:self];
        return;
    }
    if(self.targetIdTextField.text.length <= 0){
        [RCAlertView showAlertController:@"标题" message:@"targetId不能为空" cancelTitle:@"确定" inViewController:self];
        return;
    }
    
    if (self.startChatMessageBlock) {
        self.startChatMessageBlock(self.conversationType, self.targetIdTextField.text);
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)conversationBtnClickAction:(UIButton *)btn{
    NSArray *arr = @[@"单聊",@"群聊"];
     __weak typeof(self) weakSelf = self;
     ActionSheetView *actionSheet = [[ActionSheetView alloc] initWithCancleTitle:@"取消" withOtherTitles:arr compete:^(NSString * _Nonnull title) {
         NSString * conversationTypeString = title;
         if ([conversationTypeString isEqualToString:@"单聊"]) {
             weakSelf.conversationType = ConversationType_PRIVATE;
         } else  if ([conversationTypeString isEqualToString:@"群聊"]) {
             weakSelf.conversationType = ConversationType_GROUP;
         }
         [weakSelf.conversationTypeBtn setTitle:[NSString stringWithFormat:@" %@",title] forState:UIControlStateNormal];
         [weakSelf.conversationTypeBtn setTitleColor:[RCKitUtility generateDynamicColor:HEXCOLOR(0x707071)
                                                                              darkColor:HEXCOLOR(0x707071)] forState:UIControlStateNormal];
     }];
     [actionSheet show];
}


#pragma mark -Lose the first responder
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.converSationTextField resignFirstResponder];
    [self.targetIdTextField resignFirstResponder];
}


//弹出 keyboard
-(void)keyboardDidShow:(NSNotification *)notification{
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat keyboardHeight =  keyboardRect.size.height;
    CGFloat changeHeight = self.containerView.frame.size.height+ keyboardHeight;
    CGFloat contenOffSet_y = SCREEN_HEIGHT - changeHeight - 8;
    
    CGFloat width  = MIN((SCREEN_WIDTH - 100) , 280);
    CGFloat height = 310.0/280 * width;
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).mas_offset(contenOffSet_y);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(height));
        make.width.equalTo(@(width));
    }];
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:duration
                          delay:0
                        options:(UIViewAnimationOptions) (UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
        
        [self.view layoutIfNeeded];
    } completion:nil];
}

//隐藏 keyboard
-(void)keyboardDidHidden:(NSNotification*)notification {
    
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    /* 输入框下移 */
    CGFloat width  = MIN((SCREEN_WIDTH - 100) , 280);
    CGFloat height = 310.0/280 * width;
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.equalTo(@(height));
        make.width.equalTo(@(width));
    }];
    
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - getter
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius  = 5;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.text = @"发起聊天";
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.numberOfLines = 2;
        _contentLabel.text = @"conversationType: 单聊、群聊 \ntargetId: 对方userId或者群组groupId";
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.borderWidth = 1.0;
        _cancelButton.layer.cornerRadius = 4;
        _cancelButton.layer.borderColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xCFCFCF)
                                                                   darkColor:HEXCOLOR(0xCFCFCF)].CGColor;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[RCKitUtility generateDynamicColor:HEXCOLOR(0xCFCFCF)
                                                              darkColor:HEXCOLOR(0xCFCFCF)] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_cancelButton addTarget:self action:@selector(cancelBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)beginButton {
    if (!_beginButton) {
        _beginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _beginButton.layer.masksToBounds = YES;
        _beginButton.layer.borderWidth = 1.0;
        _beginButton.layer.cornerRadius = 4;
        _beginButton.layer.borderColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x4DA7F8)
                                                                  darkColor:HEXCOLOR(0x4DA7F8)].CGColor;
        [_beginButton setTitle:@"发起" forState:UIControlStateNormal];
        [_beginButton setTitleColor:[RCKitUtility generateDynamicColor:HEXCOLOR(0x4DA7F8)
                                                             darkColor:HEXCOLOR(0x4DA7F8)] forState:UIControlStateNormal];
        _beginButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _beginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_beginButton addTarget:self action:@selector(beginBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beginButton;
}

- (UIView *)theLine{
    if (!_theLine) {
        _theLine = [[UIView alloc] init];
        _theLine.backgroundColor = [UIColor grayColor];
    }
    return _theLine;
}

- (UIView *)theMarginLine{
    if (!_theMarginLine) {
        _theMarginLine = [[UIView alloc] init];
        _theMarginLine.backgroundColor = [UIColor grayColor];
    }
    return _theMarginLine;
}

- (UIButton *)conversationTypeBtn{
    if (!_conversationTypeBtn) {
        _conversationTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _conversationTypeBtn.layer.masksToBounds = YES;
        _conversationTypeBtn.layer.borderWidth = 1.0;
        _conversationTypeBtn.layer.cornerRadius = 6;
        _conversationTypeBtn.layer.borderColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xCFCFCF)
                                                                           darkColor:HEXCOLOR(0xCFCFCF)].CGColor;
        [_conversationTypeBtn setTitle:@" 请选择聊天类型" forState:UIControlStateNormal];
        [_conversationTypeBtn setTitleColor:[RCKitUtility generateDynamicColor:HEXCOLOR(0xDEDEDE) darkColor:HEXCOLOR(0xDEDEDE)] forState:UIControlStateNormal];
        _conversationTypeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _conversationTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_conversationTypeBtn addTarget:self action:@selector(conversationBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _conversationTypeBtn;
}

- (UITextField *)targetIdTextField{
    if(!_targetIdTextField){
        _targetIdTextField = [[UITextField alloc] init];
        _targetIdTextField.font = [UIFont systemFontOfSize:15];
        _targetIdTextField.layer.masksToBounds = YES;
        _targetIdTextField.layer.borderWidth = 1.0;
        _targetIdTextField.layer.cornerRadius = 6;
        _targetIdTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
        _targetIdTextField.leftView.userInteractionEnabled = NO;
        _targetIdTextField.leftViewMode = UITextFieldViewModeAlways;
        _targetIdTextField.layer.borderColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xCFCFCF)
                                                                         darkColor:HEXCOLOR(0xCFCFCF)].CGColor;
        _targetIdTextField.textColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x707071)
                                                               darkColor:HEXCOLOR(0x707071)];
        _targetIdTextField.backgroundColor =[UIColor whiteColor];
        _targetIdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入targetId" attributes:@{NSForegroundColorAttributeName:[RCKitUtility generateDynamicColor:HEXCOLOR(0xDEDEDE) darkColor:HEXCOLOR(0xDEDEDE)], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    }
    return _targetIdTextField;
}

@end
