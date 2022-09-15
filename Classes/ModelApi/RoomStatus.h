//
//  RoomStatus.h
//  Likara
//
//  Created by Rain Nguyen on 3/11/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@interface RoomStatus : JSONModel<NSCoding>
@property(strong, nonatomic) NSString* userProfile;
@property(strong, nonatomic) NSString* userName;
@property(strong, nonatomic) NSString* userId;
@property(assign, nonatomic) long dateTime;
@property(strong, nonatomic) NSString* userType;
@property(assign, nonatomic) long totalScore;
@property(strong, nonatomic) NSString* toFacebookId;
@property(strong, nonatomic) NSString* roomType;
@property(strong, nonatomic) NSString* giftId;
@property(strong, nonatomic) NSString* giftName;
@property(assign, nonatomic) long giftNoItem;
@property(strong, nonatomic) NSString* giftUrl;
@property(strong, nonatomic) NSString* message;

@property(strong, nonatomic) NSString* giftType;
@property(strong, nonatomic) NSString* giftTag;
@property(strong, nonatomic) NSString* giftAnimatedUrl;
@property(strong, nonatomic) NSString* comboId;
@property(assign, nonatomic) BOOL isFinishCombo;
@property(assign, nonatomic) long noItemSent;
@end

