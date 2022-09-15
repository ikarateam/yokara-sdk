//
//  AddUserOnlineResponse.h
//  Likara
//
//  Created by Rain Nguyen on 3/16/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddUserOnlineResponse :JSONModel
@property(strong, nonatomic) NSString*  message;
@property(strong, nonatomic) NSString*  status; //FAILED, OK
@property(strong, nonatomic) NSString* roomUserType;
@property(assign, nonatomic) BOOL roomIsExpired;
@property(assign, nonatomic) long dateTime;
@property(strong, nonatomic) NSString* liveRoomId;
@property(strong, nonatomic) NSString* domain;
@property(assign, nonatomic) long port;
@end

NS_ASSUME_NONNULL_END
