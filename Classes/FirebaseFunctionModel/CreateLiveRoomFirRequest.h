//
//  CreateLiveRoomRequest.h
//  Likara
//
//  Created by Rain Nguyen on 3/16/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN
@class LiveRoom;
@interface CreateLiveRoomFirRequest :JSONModel
@property(strong, nonatomic)  LiveRoom* liveroom;
@end

NS_ASSUME_NONNULL_END
