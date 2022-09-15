//
//  GetMyAndRecentLiveRoomsResponse.h
//  Likara
//
//  Created by Rain Nguyen on 3/10/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol LiveRoom;
NS_ASSUME_NONNULL_BEGIN

@interface GetMyAndRecentLiveRoomsResponse : JSONModel
@property(strong, nonatomic) NSMutableArray<LiveRoom> * myLiveRooms;
@property(strong, nonatomic) NSMutableArray<LiveRoom> * recentLiveRooms;
@end

NS_ASSUME_NONNULL_END
