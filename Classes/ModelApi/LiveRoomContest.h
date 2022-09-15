//
//  LiveRoomContest.h
//  Karaoke
//
//  Created by Rain Nguyen on 7/16/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@class User;
@class LiveRoom;
@class GiftRule;
@interface LiveRoomContest : JSONModel
@property(assign, nonatomic) long  _id;

@property(strong, nonatomic) NSString *name;

@property(strong, nonatomic) NSString *thumbnail;

@property(strong, nonatomic) NSString *_description;

@property(assign, nonatomic) long  startTime;

@property(assign, nonatomic) long  timeZone; //UTC+7

@property(strong, nonatomic) NSString *rules;

@property(strong, nonatomic) GiftRule *giftRule;

@property(assign, nonatomic) long  registrationFee;

@property(strong, nonatomic) NSString *whoCanRegister; //VIP EVERYONE

@property(strong, nonatomic) User* owner;

@property(strong, nonatomic) LiveRoom* liveRoom;

@property(strong, nonatomic) NSString *onlineLiveRoomContestUrl;

@property(assign, nonatomic) long noCandidates;

@property(strong, nonatomic) NSString *status;

@end

