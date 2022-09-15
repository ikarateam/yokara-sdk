//
//  DeleteContestFirebaseRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 7/16/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JSONModel.h"
@class LiveRoomContest;
@interface DeleteContestFirebaseRequest : JSONModel
@property(strong, nonatomic) NSString *roomId;

@property(strong, nonatomic) NSString *liveRoomContestId;

@end

