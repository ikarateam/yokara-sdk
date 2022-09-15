//
//  GetMyAndRecentLiveRoomsRequest.h
//  Likara
//
//  Created by Rain Nguyen on 3/10/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@class LiveRoom;
NS_ASSUME_NONNULL_BEGIN

@interface GetMyAndRecentLiveRoomsRequest : JSONModel
@property(strong, nonatomic) NSString * userId;
@property(strong, nonatomic) NSString * platform; //ANDROID, IOS, WINDOWSPHONE
@property(strong, nonatomic) NSString * language; //vi, en.yokara
@property(strong, nonatomic) NSString * packageName;

@property(strong, nonatomic) NSMutableArray* recentLiveRooms;
@end

NS_ASSUME_NONNULL_END
