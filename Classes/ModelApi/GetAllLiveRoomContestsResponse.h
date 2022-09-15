//
//  GetAllLiveRoomContestsResponse.h
//  Karaoke
//
//  Created by Rain Nguyen on 7/16/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JSONModel.h"
@protocol LiveRoomContest;

@interface GetAllLiveRoomContestsResponse : JSONModel

@property(strong, nonatomic) NSMutableArray<LiveRoomContest>* futureLiveRoomContests;

@property(strong, nonatomic) NSMutableArray<LiveRoomContest>*  currentLiveRoomContests;

@property(strong, nonatomic) NSMutableArray<LiveRoomContest>* passedLiveRoomContests;

@property(strong, nonatomic) NSString *cursor;
@end


