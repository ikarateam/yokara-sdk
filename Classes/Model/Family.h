//
//  Family.h
//  Karaoke
//
//  Created by Rain Nguyen on 9/20/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN
@class User;
@class LiveRoom;
@interface Family : JSONModel

@property (assign, nonatomic) long  _id;
@property (assign, nonatomic) long  uid;
@property(strong, nonatomic) NSString * name;
@property(strong, nonatomic) NSString * descript;

@property(strong, nonatomic) NSString * message;

@property(strong, nonatomic) NSString * thumbnail;
@property (strong, nonatomic)  User<Optional>* owner;
@property (assign, nonatomic) long totalScore;
@property (assign, nonatomic) long  totalMember;
@property (assign, nonatomic) long  totalRecording;
@property (assign, nonatomic) long  level;
@property(strong, nonatomic) NSString * levelColor;// "#37474F";


@property (assign, nonatomic) long  minScoreOfNextLevel;
@property (assign, nonatomic) long  minScoreOfCurrentLevel;
@property (assign, nonatomic) long  maxMember;
@property (assign, nonatomic) long  maxSubLeader;

@property (strong, nonatomic)  NSMutableArray <Optional>* subLeadersId;

@property(strong, nonatomic) NSString * status; //NEW , // DELETED

@property(strong, nonatomic)  LiveRoom *liveRoomNormal;
@property(strong, nonatomic)  LiveRoom *liveRoomVersus;
@end

NS_ASSUME_NONNULL_END
