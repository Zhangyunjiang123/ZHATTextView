
//
//  TPFriendsChooseTableViewCell.m
//  WolfClient
//
//  Created by 张云江 on 2018/12/4.
//  Copyright © 2018年 shsx. All rights reserved.
//

#import "TPFriendsChooseTableViewCell.h"
#import "Masonry.h"

@implementation TPFriendsChooseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)creatUI
{
    self.nicknameLabel = [[UILabel alloc]init];
    self.nicknameLabel.textColor = [UIColor lightGrayColor];
    self.nicknameLabel.font = [UIFont systemFontOfSize:15];
    self.nicknameLabel.text = @"666";
    self.nicknameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.nicknameLabel];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.chooseBtn = [[UIButton alloc]init];
    [self.chooseBtn setImage:[UIImage imageNamed:@"tp_common_choose"] forState:UIControlStateNormal];
    [self.chooseBtn setImage:[UIImage imageNamed:@"tp_common_choose_selected"] forState:UIControlStateSelected];
    [self addSubview:self.chooseBtn];
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)update:(Friend *)frd
{
    self.nicknameLabel.text = frd.nickName;
}
@end
