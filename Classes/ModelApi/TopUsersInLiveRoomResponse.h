//
//  TopUsersInLiveRoomResponse.h
//  Karaoke
//
//  Created by Rain Nguyen on 1/8/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol User;
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TopUsersInLiveRoomResponse : JSONModel
@property(strong, nonatomic)  NSMutableArray<User>* users;
@property(strong, nonatomic) NSString * cursor;
@end

NS_ASSUME_NONNULL_END
