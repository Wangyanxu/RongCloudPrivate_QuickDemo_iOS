//
//  MineVC.m
//  support-im-ios-debugdemo
//
//  Created by 于艳平 on 2022/7/11.
//

#import "MineVC.h"
#import "MineModel.h"
#import "MineListCell.h"
#import "ActionSheetView.h"

@interface HeaderView : UIView

@property (nonatomic, strong) MineHaderModel * headerModel;// Model
@property (nonatomic, strong) UILabel * nameLab; //昵称
@property (nonatomic, strong) UILabel * userIDLab;//用户id
@property (nonatomic, strong) UIImageView * avatarImage;//用户头像
@property (nonatomic, strong) UIButton * logOutBtn;//退出登录
@property (nonatomic, copy) void (^logOutActionBlock)(MineHaderModel * headerModel);

@property (nonatomic, strong) UIView * theline; //线

@end

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}

#pragma mark - views
- (void)addSubviews {
    
    self.backgroundColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xF5F5F5)
                                                    darkColor:HEXCOLOR(0xF5F5F5)];
    [self addSubview:self.nameLab];
    [self addSubview:self.userIDLab];
    [self addSubview:self.avatarImage];
    [self addSubview:self.logOutBtn];
    [self addSubview:self.theline];
    
    self.avatarImage.frame = CGRectMake(20, (100 - 70)/2, 70, 70);
    self.nameLab.frame = CGRectMake(self.avatarImage.frame.origin.x + self.avatarImage.frame.size.width + 10, (100 - 60)/2, 160, 20);
    self.userIDLab.frame = CGRectMake(self.nameLab.frame.origin.x, 100 - 10 - 30, 160, 20);
    self.logOutBtn.frame = CGRectMake(SCREEN_WIDTH - 80 - 10, (100 - 30)/2, 80, 40);
    
    self.theline.frame = CGRectMake(0, 100 - 0.5, SCREEN_WIDTH, 0.5);
}

- (void)setHeaderModel:(MineHaderModel *)headerModel{
    _headerModel = headerModel;
    
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:headerModel.avatar] placeholderImage:RCResourceImage(@"default_portrait_msg")];

    self.nameLab.text = [NSString stringWithFormat:@"%@",headerModel.name];
    self.userIDLab.text = [NSString stringWithFormat:@"ID : %@",headerModel.ID];
}

- (void)logOutBtnClick{
    
    if (self.logOutActionBlock) {
        self.logOutActionBlock(self.headerModel);
    }
}

- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.text = @"你的昵称";
        _nameLab.textColor = [UIColor blackColor];
        _nameLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLab.font = [UIFont boldSystemFontOfSize:17];
        _nameLab.numberOfLines = 1;
    }
    return _nameLab;
}

- (UILabel *)userIDLab{
    if (!_userIDLab) {
        _userIDLab = [[UILabel alloc] init];
        _userIDLab.textColor = [UIColor blackColor];
        _userIDLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _userIDLab.font = [UIFont systemFontOfSize:15];
        _userIDLab.numberOfLines = 1;
    }
    return _userIDLab;
}

- (UIImageView *)avatarImage{
    if (!_avatarImage) {
        _avatarImage = [[UIImageView alloc] init];
        _avatarImage.backgroundColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xE5E7EB)
                                                                darkColor:HEXCOLOR(0xE5E7EB)];
        _avatarImage.layer.cornerRadius = 35;
        _avatarImage.layer.masksToBounds = YES;
        _avatarImage.layer.borderWidth = 1.0;
        _avatarImage.layer.borderColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x4CA1F0)
                                                                  darkColor:HEXCOLOR(0x4CA1F0)].CGColor;
        _avatarImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarImage;
}

- (UIButton *)logOutBtn{
    if (!_logOutBtn) {
        _logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logOutBtn.backgroundColor = [UIColor whiteColor];
        _logOutBtn.layer.masksToBounds = YES;
        _logOutBtn.layer.borderWidth = 1.0;
        _logOutBtn.layer.cornerRadius = 4;
        _logOutBtn.layer.borderColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x707071)
                                                                darkColor:HEXCOLOR(0x707071)].CGColor;
        [_logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logOutBtn setTitleColor:[RCKitUtility generateDynamicColor:HEXCOLOR(0x707071)
                                                           darkColor:HEXCOLOR(0x707071)] forState:UIControlStateNormal];
        _logOutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_logOutBtn addTarget:self action:@selector(logOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logOutBtn;
}

- (UIView *)theline{
    if (!_theline) {
        _theline = [[UIView alloc] init];
        _theline.backgroundColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xE5E7EB)
                                                            darkColor:HEXCOLOR(0xE5E7EB)];
    }
    return _theline;
}

@end

///**************    MineVC     ***********************/
@interface MineVC ()<UITableViewDelegate,UITableViewDataSource,MineListCellDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic,   copy) NSArray     * datasArr;
@property (nonatomic, strong) HeaderView  * headerView;

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubviews];
    [self setData];
    
//    __weak typeof(self) weakSelf = self;
    [self.headerView setLogOutActionBlock:^(MineHaderModel *headerModel) {
       //退出登录
        [[RCIM sharedRCIM] logout];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"APP_LOGOUT_SUCESS_NOTIFICATION" object:nil userInfo:@{@"isForce":@(0)}];
        });
    }];
}
// 添加 view
- (void)addSubviews{
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100);
}

- (void)setData {
    
    //当前用户名
    RCUserInfo *currentUserInfo = [[RCIM sharedRCIM] currentUserInfo];
    NSString * name = currentUserInfo.name;
    //用户id
    NSString * userId = currentUserInfo.userId;
    //用户头像
    NSString * avatar = currentUserInfo.portraitUri;
    //组建临时model
    NSMutableDictionary * mutDict = @{}.mutableCopy;
    NSMutableDictionary * mutHeaderDict = @{}.mutableCopy;
    NSMutableArray * mutListArr = @[].mutableCopy;
    NSMutableArray * mutListDict0 = @{}.mutableCopy;
    NSMutableArray * mutListDict1 = @{}.mutableCopy;
    NSMutableArray * mutListDict2 = @{}.mutableCopy;
    
    [mutDict setValue:mutHeaderDict forKey:@"header"];
    [mutDict setValue:mutListArr forKey:@"list"];
    
    [mutHeaderDict setValue:name forKey:@"name"];
    [mutHeaderDict setValue:userId forKey:@"ID"];
    [mutHeaderDict setValue:avatar forKey:@"avatar"];
    
    MineModel * model = [[MineModel alloc] initWithDictionary:mutDict];
    self.headerView.headerModel = model.haderModel;
    self.datasArr = model.listArr;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.datasArr.count <=0) {
        return [[UITableViewCell alloc] init];
    }
    static NSString *reusableID = @"MineListCellId";
    MineListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reusableID];
    if (!cell) {
        cell = [[MineListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableID];
        cell.delegate = self;
    }
    cell.listModel = self.datasArr[indexPath.row];
    cell.tintColor =  [UIColor colorWithRed:58/255.0 green:145/255.0 blue:243/255.0 alpha:1/1.0];
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.datasArr.count >=0) {return;}
}

#pragma mark - UILazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        self.headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        
        _tableView.tableHeaderView = self.headerView;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.estimatedRowHeight = 0.f;
        _tableView.delaysContentTouches = NO;
    }
    return _tableView;
}

@end
