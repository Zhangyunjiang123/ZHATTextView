//
//  TPFriendsChooseViewController.h
//  WolfClient
//
//  Created by 张云江 on 2018/12/4.
//  Copyright © 2018年 shsx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"
#import "Masonry.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TPFriendsChooseViewControllerProtocol <NSObject>
@optional

- (void)onTPFriendsChooseViewControllerBack:(NSMutableArray *)array;

@end

@interface TPFriendsChooseViewController : UIViewController

@property(nonatomic,weak) id <TPFriendsChooseViewControllerProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
