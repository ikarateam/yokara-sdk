//
//  Room.h
//  Likara
//
//  Created by Rain Nguyen on 3/11/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@interface Room : JSONModel<NSCoding>
@property(strong, nonatomic) NSString* packageName;
@property(strong, nonatomic) NSString* roomCanMic;
@property(strong, nonatomic) NSNumber* dateTime;
@property(strong, nonatomic) NSNumber* version;
@property(strong, nonatomic) NSNumber* roomTopLimit;
@property(strong, nonatomic) NSString* roomId;
@property(strong, nonatomic) NSString* roomName;
@property(strong, nonatomic) NSString* roomPermision;
@property(strong, nonatomic) NSString* roomThumbnail;
@property(strong, nonatomic) NSString* userId;
@property(strong, nonatomic) NSString* userName;
@property(strong, nonatomic) NSString* userProfile;
@property(strong, nonatomic) NSString* userUid;
@end

