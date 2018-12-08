//
//  TPFriendsChooseTableViewCell.h
//  WolfClient
//
//  Created by 张云江 on 2018/12/4.
//  Copyright © 2018年 shsx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

NS_ASSUME_NONNULL_BEGIN

@interface TPFriendsChooseTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel      *nicknameLabel;
@property (strong, nonatomic) UILabel      *levelLable;
@property (strong, nonatomic) UIButton     *chooseBtn;

- (void)update:(Friend *)frd;

@end

NS_ASSUME_NONNULL_END
