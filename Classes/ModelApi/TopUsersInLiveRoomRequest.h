//
//  TopUsersInLiveRoomRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 1/8/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@class LiveRoom;
NS_ASSUME_NONNULL_BEGIN

@interface TopUsersInLiveRoomRequest : JSONModel
@property(strong, nonatomic) NSString * userId;
@property(strong, nonatomic) NSString * platform; //ANDROID, IOS, WINDOWSPHONE
@property(strong, nonatomic) NSString * language; //vi, en.yokara
@property(strong, nonatomic) NSString * packageName;
@property(strong, nonatomic) NSString * cursor;

@property(assign, nonatomic) long liveRoomId;
@property(assign, nonatomic)  int type; //0 daily 1 weekly 2 monthly
@end

NS_ASSUME_NONNULL_END
