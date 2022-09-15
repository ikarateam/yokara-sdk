//
//  LiveRoom.h
//  Likara
//
//  Created by Rain Nguyen on 3/10/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@class User;
@class Family;
NS_ASSUME_NONNULL_BEGIN
#define LIVE_ORANGE @"LIVE_ORANGE"
#define LIVE_BLUE @"LIVE_BLUE"
#define LIVE_VIOLET @"LIVE_VIOLET"
#define PK_REDBLUE @"PK_REDBLUE"
#define PK_PINKBLUE_1 @"PK_PINKBLUE_1"
#define PK_PINKBLUE_2 @"PK_PINKBLUE_2"
#define PK_PINKBLUE_3 @"PK_PINKBLUE_3"
//"LIVE_ORANGE","LIVE_BLUE","LIVE_VIOLET","PK_REDBLUE"
@interface LiveRoom : JSONModel
@property(assign, nonatomic) long _id;
@property(assign, nonatomic) long  uid;
@property(strong, nonatomic) NSString * name;
@property(strong, nonatomic) NSString * roomId;
@property(strong, nonatomic) NSString * descript;
@property(strong, nonatomic) User * owner;
@property(strong, nonatomic) NSString * privacyLevel; //PRIVATE PUBLIC
@property(strong, nonatomic) NSString * password;
@property(strong, nonatomic) NSString * type;//NORMAL VERSUS
@property(strong, nonatomic) NSString *  status; // NEW DELETED
@property(strong, nonatomic) NSString * bulletin;
@property(strong, nonatomic) NSString * thumbnail;
@property(assign, nonatomic) long noOnlineMembers;
@property(assign, nonatomic) long queueLimit;
@property(strong, nonatomic) NSString * whoCanSing; //ADMIN VIP EVERYONE
@property(strong, nonatomic) NSString * onlineLiveRoomUrl;
@property(assign, nonatomic) long totalGiftScore;
@property(assign, nonatomic) long totalScore;
@property(assign, nonatomic) long expiredDate;
@property(assign, nonatomic) BOOL autoRenew;
@property(strong, nonatomic) NSString * domain;
@property(assign, nonatomic) long port;
@property(strong, nonatomic) Family * family;
@property(strong, nonatomic) NSString * whoCanJoin; //MEMBER EVERYONE
@property(strong, nonatomic) NSString * backgroundType;
@property(strong, nonatomic) NSString * liveRoomId;
@end

NS_ASSUME_NONNULL_END
