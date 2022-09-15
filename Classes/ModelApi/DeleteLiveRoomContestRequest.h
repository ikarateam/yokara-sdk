//
//  DeleteLiveRoomContestRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 7/16/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"

@interface DeleteLiveRoomContestRequest : JSONModel

@property(strong, nonatomic) NSString *userId;

@property(strong, nonatomic) NSString *platform; //ANDROID, IOS, WINDOWSPHONE

@property(strong, nonatomic) NSString *language; //vi, en.yokara

@property(strong, nonatomic) NSString *packageName;

@property(assign, nonatomic) long  liveRoomContestId;
@end

