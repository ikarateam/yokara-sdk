//
//  LuckyGiftGave.h
//  Karaoke
//
//  Created by Rain Nguyen on 11/19/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JSONModel.h"
@class User;
@class LuckyGift;
NS_ASSUME_NONNULL_BEGIN

@interface LuckyGiftGave : JSONModel

@property(assign, nonatomic)  long _id;
@property(assign, nonatomic)  long addTime;
@property(strong, nonatomic)  User *user;
@property(strong, nonatomic)  LuckyGift *luckyGift;
@end

NS_ASSUME_NONNULL_END
