//
//  ActionSheetView.m
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/15.
//


#import "ActionSheetView.h"

static const NSInteger cancleBarHeight = 8;
static const NSInteger cellHeight = 56;

@interface ActionSheetView()

@property(nonatomic, strong) UITableView *tableview;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, strong) NSString *cancleTitle;
@property(nonatomic, assign) CGFloat tableviewHeight;
@property(nonatomic, assign) CGFloat safeAreaHeight;//iPhoneX底部安全区域
@property (nonatomic, copy) void(^competeBlock)(NSString *title);
@end

@implementation ActionSheetView

-(instancetype)initWithCancleTitle:(NSString *)cancleTitle withOtherTitles:(NSArray *)titles compete:(nonnull void (^)(NSString * _Nonnull))competeBlock{
self = [super init];
    if(self){
        
        // data init
        _tableviewHeight = 0;
        _items = @[].mutableCopy;
        _cancleTitle = cancleTitle;
        
        [titles enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.items addObject:text];
        }];
        
        _tableviewHeight = (titles.count + 1) * cellHeight + cancleBarHeight;
        self.competeBlock = competeBlock;
        [self addSubViews];
        
    }
    return self;
}

-(void)addSubViews{
    
    self.backgroundColor = [RCKitUtility generateDynamicColor:[HEXCOLOR(0x000000) colorWithAlphaComponent:0.5] darkColor:[HEXCOLOR(0x000000) colorWithAlphaComponent:0.5]];
    [self addSubview:self.tableview];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = (CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT};
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *aTouch = [touches anyObject];
    CGPoint point = [aTouch locationInView:self];
    if(point.y < SCREEN_HEIGHT - _tableviewHeight){
        [self dismiss:nil];
    }
    [super touchesBegan:touches withEvent:event];
}


-(UITableView *)tableview{
    if(_tableview == nil){
        _tableview = [[UITableView alloc] initWithFrame:(CGRect){0,0,0,0} style:UITableViewStylePlain];
        [_tableview setShowsVerticalScrollIndicator:NO];
        [_tableview setShowsHorizontalScrollIndicator:NO];
        _tableview.delegate = (id<UITableViewDelegate>)self;
        _tableview.dataSource = (id<UITableViewDataSource>)self;
        _tableview.scrollEnabled = NO;
        _tableview.backgroundColor = [UIColor blueColor];
        //        UIView *footerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH, 20}];
        //        footerView.backgroundColor = [UIColor blueColor];
        //        _tableview.tableFooterView = footerView;
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        if([_tableview respondsToSelector:@selector(setSeparatorInset:)]){
            [_tableview setSeparatorInset:UIEdgeInsetsZero];
        }
        _tableview.separatorColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xE3E3E3)
                                                             darkColor:HEXCOLOR(0xE3E3E3)];
    }
    return _tableview;
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? self.items.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if(section == 0){
        UIView *view = [[UIView alloc] init];
        view.frame = (CGRect){0,0,SCREEN_WIDTH,0};
        view.backgroundColor =[RCKitUtility generateDynamicColor:HEXCOLOR(0xF6F6F6)
                                                       darkColor:HEXCOLOR(0xF6F6F6)];
        return view;
    }
    return [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,0}];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return cancleBarHeight;
    }
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x2A2A2A)
                                                        darkColor:HEXCOLOR(0x2A2A2A)];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    
    if(indexPath.section == 0){
        cell.textLabel.text = _items[indexPath.row];
    }else{
        cell.textLabel.text = _cancleTitle;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        __weak typeof(self) weakSelf = self;
        [self dismiss:^{
            weakSelf.competeBlock(weakSelf.items[indexPath.row]);
        }];
    }else{
        [self dismiss:nil];
    }
}

#pragma mark tools
-(void)show{
    _tableview.frame = (CGRect){0,SCREEN_HEIGHT,SCREEN_WIDTH,_tableviewHeight};
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableview.frame = (CGRect){0,SCREEN_HEIGHT - self.tableviewHeight,SCREEN_WIDTH,self.tableviewHeight};
    }];
}

-(void)dismiss:(void (^)(void))action{
    _tableview.frame = (CGRect){0,SCREEN_HEIGHT - _tableviewHeight,SCREEN_WIDTH,_tableviewHeight};
    
    NSTimeInterval duration = action == nil ? 0.2 : 0.1;
    self.backgroundColor = [RCKitUtility generateDynamicColor:[HEXCOLOR(0x000000) colorWithAlphaComponent:0.5] darkColor:[HEXCOLOR(0x000000) colorWithAlphaComponent:0.5]];
    [UIView animateWithDuration:duration animations:^{
        self.tableview.frame = (CGRect){0,SCREEN_HEIGHT,SCREEN_WIDTH,self.tableviewHeight};
        self.backgroundColor = [RCKitUtility generateDynamicColor:[HEXCOLOR(0x000000) colorWithAlphaComponent:0.0] darkColor:[HEXCOLOR(0x000000) colorWithAlphaComponent:0.0]];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if(action){
            action();
        }
    }];
}

@end
