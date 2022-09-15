//
//  EndLiveRoomContestRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 7/16/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface EndLiveRoomContestRequest : JSONModel

@property(assign, nonatomic) long  liveRoomContestId;

@property(strong, nonatomic) NSString *firstPrizeFacebookId;

@property(strong, nonatomic) NSString *secondPrizeFacebookId;

@property(strong, nonatomic) NSString *thirdPrizeFacebookId;
@end

