//
//  LuckyGiftHistory.h
//  Karaoke
//
//  Created by Rain Nguyen on 11/19/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@class User;
@class Gift;
NS_ASSUME_NONNULL_BEGIN

@interface LuckyGiftHistory : JSONModel
@property(strong, nonatomic)  User * user;
@property(strong, nonatomic)  Gift* gift;
@property(assign, nonatomic) long addTime;
@end

NS_ASSUME_NONNULL_END
