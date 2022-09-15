//
//  CreateLiveRoomRespone.h
//  Karaoke
//
//  Created by Rain Nguyen on 7/13/20.
//  Copyright © 2020 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@class LiveRoom;
NS_ASSUME_NONNULL_BEGIN

@interface CreateLiveRoomRespone :JSONModel
@property(strong, nonatomic) NSString*  message;
@property(strong, nonatomic) NSString*  status; //FAILED, OK
@property(strong, nonatomic) LiveRoom*  liveRoom;
@end
NS_ASSUME_NONNULL_END
