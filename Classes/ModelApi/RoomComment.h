//
//  RoomComment.h
//  Likara
//
//  Created by Rain Nguyen on 3/11/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
#define NOTIFICATION @"NOTIFICATION"
#define GIFT @"GIFT"
#define COMMENT @"COMMENT"
@interface RoomComment : JSONModel<NSCoding>

@property(assign, nonatomic) long dateTime;
@property(strong, nonatomic) NSString* message;
@property(assign, nonatomic) long luckyGiftGaveId;
@property(strong, nonatomic) NSString* userId;
@property(assign, nonatomic) long userUid;
@property(strong, nonatomic) NSString* userName;
@property(strong, nonatomic) NSString* giftId;
@property(strong, nonatomic) NSString* giftName;
@property(strong, nonatomic) NSString* giftUrl;
@property(assign, nonatomic) long giftNoItem;
@property(strong, nonatomic) NSString* userProfile;
@property(strong, nonatomic) NSString* userType;
@property(strong, nonatomic) NSString* parentCommentId;
@property(strong, nonatomic) NSString* roomType;//NOTIFICATION, GIFT, COMMENT
@property(strong, nonatomic) NSString* roomId;
@property(strong, nonatomic) NSString* toFacebookId;
@property(strong, nonatomic) NSString* fromFacebookId;
@property(assign, nonatomic) long totalScore;
@property(strong, nonatomic) NSString* commentId;
@property(strong, nonatomic) NSString* targetId;
@property(strong, nonatomic) NSString* targetName;
@end

