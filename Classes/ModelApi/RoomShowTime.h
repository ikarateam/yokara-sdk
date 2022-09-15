//
//  RoomShowTime.h
//  Likara
//
//  Created by Rain Nguyen on 3/11/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@class User;
@class Lyric;
@interface RoomShowTime : JSONModel<NSCoding>
@property(assign, nonatomic) long _id;
@property(assign, nonatomic) long counter;
@property(assign, nonatomic) long dateTime;
@property(assign, nonatomic) long dateTimeUpdatePosition;
@property(assign, nonatomic) long dislikeCounter;
@property(assign, nonatomic) long duration;
@property(strong, nonatomic) NSString* firebaseId;
@property(assign, nonatomic) long  isFavorite;
@property(assign, nonatomic) long likeCounter;
@property(assign, nonatomic) long numberOfLyrics;
@property(strong, nonatomic) User* owner;
@property(assign, nonatomic) long pitchShift;
@property(assign, nonatomic) long progress;
@property(strong, nonatomic) Lyric* selectedLyric;
@property(strong, nonatomic) NSString* songName;
@property(assign, nonatomic) long status;

@property(strong, nonatomic) NSString* userProfile;
@property(strong, nonatomic) NSString* userName;
@property(strong, nonatomic) NSString* message;


@property(strong, nonatomic) NSString* userId;
@property(strong, nonatomic) NSString* userType;

@property(strong, nonatomic) NSString* roomId;

@property(assign, nonatomic) long userUid;
@property(strong, nonatomic) NSString* videoId;


@end
