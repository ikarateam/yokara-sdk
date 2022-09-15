//
//  UpdateLiveRoomPropertyRequest.h
//  Likara
//
//  Created by Rain Nguyen on 3/16/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@class LiveRoom;
@interface UpdateLiveRoomPropertyFirRequest : JSONModel<NSCoding>
@property(strong, nonatomic) LiveRoom * liveRoom;
@property(strong, nonatomic) NSString * backgroundId;
@end
