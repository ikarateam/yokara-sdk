//
//  RoomUserOnline.h
//  Likara
//
//  Created by Rain Nguyen on 3/26/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@interface RoomUserOnline : JSONModel<NSCoding>
@property(strong, nonatomic) NSString* facebookId;
@property(strong, nonatomic) NSString* name;
@property(strong, nonatomic) NSString* roomId;
@property(strong, nonatomic) NSString* profileImageLink;
@property(strong, nonatomic) NSString* userActionId;
@property(assign, nonatomic) long dateTimeOnline;
@property(strong, nonatomic) NSString* roomUserType;
@property(strong, nonatomic) NSString* roomUserActionType;
@property(assign, nonatomic) long uid;
@property(assign, nonatomic) long totalScore;
@end


