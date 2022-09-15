//
//  RoomQueueSong.h
//  Likara
//
//  Created by Rain Nguyen on 3/11/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@interface RoomQueueSong : JSONModel<NSCoding>
@property(strong, nonatomic) NSString* userProfile;
@property(strong, nonatomic) NSString* userName;
@property(strong, nonatomic) NSNumber* dateTime;
@property(strong, nonatomic) NSNumber* _id;
@property(strong, nonatomic) NSString* userId;
@property(strong, nonatomic) NSString* userType;
@property(strong, nonatomic) NSString* firebaseId;
@property(strong, nonatomic) NSString* roomId;
@property(strong, nonatomic) NSString* songName;
@property(strong, nonatomic) NSString* status;
@property(strong, nonatomic) NSString* userUid;
@property(strong, nonatomic) NSString* videoId;
@property(strong, nonatomic) NSString* userActionId;
@property(strong, nonatomic) NSString* minutesOnline;
@end


