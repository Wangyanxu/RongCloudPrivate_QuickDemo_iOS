//
//  ViewController.m
//  support-im-ios-debugdemo
//
//  Created  on 2022/7/11.
//

#import "LoginVC.h"
#import "TabBarController.h"
#import "ChatListVC.h"
#import "CustomMessage.h"
#import "CustomMediaMessage.h"
#import "IMDataSource.h"


@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *appkeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *tokenTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *naviServerTextField;
@property (weak, nonatomic) IBOutlet UITextField *fileServerTextField;
@property (weak, nonatomic) IBOutlet UITextField *environmentTextField;
@end

@implementation LoginVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    /// 设置 log 等级 如何获取本地 log 请参考: https://help.rongcloud.cn/t/topic/871
    [RCCoreClient sharedCoreClient].logLevel = RC_Log_Level_Verbose;
    
    /// 如果模拟器不方便复制粘贴，请在这里输入您的配置导航信息
    [self configRCInitOption];
}

- (void)configRCInitOption {
    /// 填写 appkey
    self.appkeyTextField.text = @"";
    /// 填写 token
    self.tokenTextField.text = @"";
    /// 填写导航地址
    self.naviServerTextField.text = @"";
    /// RCX 服务的需要设置文件服务器地址,FCS 服务不需要设置文件服务器地址
    self.fileServerTextField.text = @"";
    /// 配置内外网;字段取值有 内网：intranet、外网：extranet、其他：others、默认：default (外网)
    self.environmentTextField.text = @"";
    
    ///如果导航 https 证书用了自签名，需要在原生端配置下 ssl 证书忽略  https://help.rongcloud.cn/t/topic/883

}

- (IBAction)loginButtonAction:(UIButton *)sender {
   
    [self detectionParameters];
    
    // 配置初始化参数
    RCInitOption *option = [[RCInitOption alloc] init];
    // 配置导航地址服务
    option.naviServer = self.naviServerTextField.text;
    // 配置文件服务 RCX 服务的需要设置文件服务器地址,FCS 服务不需要设置文件服务器地址
    option.fileServer = self.fileServerTextField.text;
    // 初始化 SDK
    [[RCIM sharedRCIM] initWithAppKey:self.appkeyTextField.text option:option];
    
    // 设置 IM 相关监听 https://doc.rongcloud.cn/im/IOS/5.X/ui/connection/monitor-status
    [self configRongIMSDK];
    
    // 连接 IM
    [self connectIM:self.tokenTextField.text];
}

- (void)connectIM:(NSString *)token {
    [[RCIM sharedRCIM] connectWithToken:token dbOpened:^(RCDBErrorCode code) {

    } success:^(NSString *userId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //从 APP 服务器获得当前用户信息
            RCUserInfo *userInfoModel = [[RCUserInfo alloc] init];
            userInfoModel.userId = userId;
            userInfoModel.name = [NSString stringWithFormat:@"用户 %@",userId];
            userInfoModel.portraitUri= @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg3.doubanio.com%2Fview%2Fgroup_topic%2Fl%2Fpublic%2Fp314207052.jpg&refer=http%3A%2F%2Fimg3.doubanio.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1638589198&t=39c7009d85d3f904cb57e1ee1c008982";
            [[RCIM sharedRCIM] setCurrentUserInfo:userInfoModel];
            
            TabBarController *tabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
            [[UIApplication sharedApplication].keyWindow setRootViewController:tabBarVC];
        });
    } error:^(RCConnectErrorCode errorCode) {
        if (errorCode == RC_CONN_TOKEN_INCORRECT) {
            [[AppGlobalConfig shareInstance] removeToken];
            [SVProgressHUD showErrorWithStatus:@"token失效，点击登录按钮重新获取"];
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"登录失败:%ld", errorCode]];
        }
    }];
}


- (void)configRongIMSDK{
    // 注册自定义消息
    [[RCCoreClient sharedCoreClient] registerMessageType:[CustomMessage class]];
    [[RCCoreClient sharedCoreClient] registerMessageType:[CustomMediaMessage class]];
    /*!
      选择媒体资源时，是否包含视频文件，默认值是NO
      @discussion 默认是不包含， 如果设置成 YES 图库中 包含了视频文件
     */
    RCKitConfigCenter.message.isMediaSelectorContainVideo = YES;
    
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].userInfoDataSource = RCDataSource;
    [RCIM sharedRCIM].groupInfoDataSource = RCDataSource;
    [RCIM sharedRCIM].groupUserInfoDataSource = RCDataSource;
    [RCIM sharedRCIM].groupMemberDataSource = RCDataSource;
    [RCIM sharedRCIM].receiveMessageDelegate = RCDataSource;
    
}

- (void)detectionParameters {
    if (self.appkeyTextField.text.length == 0) {
        [RCAlertView showAlertController:@"标题" message:@"appkey不能为空" cancelTitle:@"确定" inViewController:self];
        return;
    }
    if (self.tokenTextField.text.length == 0) {
        [RCAlertView showAlertController:@"标题" message:@"token 不能为空" cancelTitle:@"确定" inViewController:self];
        return;
    }
    if (self.naviServerTextField.text.length == 0) {
        [RCAlertView showAlertController:@"标题" message:@"导航地址 不能为空" cancelTitle:@"确定" inViewController:self];
        return;
    }
}
@end
