//
//  MineListCell.m
//  support-im-ios-debugdemo
//
//  Created by pengwenxin on 2022/7/13.
//

#import "MineListCell.h"

@interface MineListCell ()

@property (nonatomic, strong) UILabel * titleLab;

@property (nonatomic, strong) UILabel * subTitleLab;

@property (nonatomic, strong) UISwitch * switchView; // 开关

@property (nonatomic, strong) UIButton * lauguageBtn;//语言选择

@property (nonatomic, strong) UIImageView * arrowImage;//箭头

@property (nonatomic, strong) UIView * theline;

@end


@implementation MineListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.subTitleLab];
        [self.contentView addSubview:self.switchView];
        [self.contentView addSubview:self.lauguageBtn];
        [self.contentView addSubview:self.arrowImage];
        [self.contentView addSubview:self.theline];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.titleLab.frame = CGRectMake(16, (56 - 20)/2, 120, 20);
        self.switchView.frame  = CGRectMake(SCREEN_WIDTH - 80, (56 - 40)/2 , 80, 40);
        self.lauguageBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - 80 - 20 - 5, (56 - 40)/2, 80, 40);
        self.arrowImage.frame = CGRectMake(SCREEN_WIDTH - 10 - 20, (56 - 20)/2, 20, 20);
        self.theline.frame = CGRectMake(8, 56 - 0.5, SCREEN_WIDTH - 16, 0.5);
    }
    return self;
}

#pragma mark - Action
- (void)switchViewDidChangeValue{
  
    if(self.switchView.on){
        self.listModel.isOpen = @"1";
    }else{
        self.listModel.isOpen = @"0";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:didSetProfileListModel:)]) {
        [self.delegate tableViewCell:self didSetProfileListModel:self.listModel];
    }
}

- (void)setListModel:(MineListModel *)listModel{
    _listModel = listModel;

    if([listModel.listId isEqualToString:@"103"]){
        self.switchView.hidden = YES;
        self.lauguageBtn.hidden = NO;
        self.arrowImage.hidden = NO;
        [self.lauguageBtn setTitle:listModel.isOpen forState:UIControlStateNormal];
    }else{
        self.switchView.hidden = NO;
        self.lauguageBtn.hidden = YES;
        self.arrowImage.hidden = YES;
        if ([listModel.isOpen isEqualToString:@"1"]) {
            self.switchView.on = YES;
        }else{
            self.switchView.on = NO;
        }
    }
    self.titleLab.text = [NSString stringWithFormat:@"%@",listModel.title];
}

- (void)lauguageBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:didSelectLauguageMineListModel:)]) {
        [self.delegate tableViewCell:self didSelectLauguageMineListModel:self.listModel];
    }
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.numberOfLines = 1;
    }
    return _titleLab;
}

- (UISwitch *)switchView{
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        _switchView.on = NO;
        _switchView.hidden = YES;
        _switchView.onTintColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x4DA7F8)
                                                           darkColor:HEXCOLOR(0x4DA7F8)];
        [_switchView addTarget:self action:@selector(switchViewDidChangeValue) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UIImageView *)arrowImage{
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"]];
        _arrowImage.hidden = YES;
        _arrowImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _arrowImage;
}

- (UIButton *)lauguageBtn{
    if (!_lauguageBtn) {
        _lauguageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lauguageBtn.hidden = YES;
        [_lauguageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _lauguageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_lauguageBtn addTarget:self action:@selector(lauguageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lauguageBtn;
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
