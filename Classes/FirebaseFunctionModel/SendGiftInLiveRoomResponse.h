//
//  SendGiftInRecordingResponse.h
//  Likara
//
//  Created by Rain Nguyen on 6/5/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
#define NOTENOUGH  @"NOTENOUGH"
@interface SendGiftInLiveRoomResponse : JSONModel<NSCoding>
@property(strong, nonatomic) NSString*  message;
@property(strong, nonatomic) NSString*  status; //FAILED, OK,NOTENOUGH
@end

