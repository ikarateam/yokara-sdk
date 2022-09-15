//
//  JoinLiveRoomContestResponse.h
//  Karaoke
//
//  Created by Rain Nguyen on 7/16/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"

@interface JoinLiveRoomContestResponse : JSONModel
@property(strong, nonatomic) NSString *message;

@property(strong, nonatomic) NSString *status; //FAILED, OK

@end
