//
//  Friend.h
//  ZHATTextView
//
//  Created by 张云江 on 2018/12/8.
//  Copyright © 2018年 张云江. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Friend : NSObject

@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,assign)int    userId;

@end

@interface TPListInfo : NSObject

@property(nonatomic,copy)NSString *talk_title;
@property(nonatomic,assign)int    talk_id;

@end

NS_ASSUME_NONNULL_END
