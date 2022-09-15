//
//  AddUserOnLineRequest.h
//  Likara
//
//  Created by Rain Nguyen on 3/16/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@class LiveRoom;
@class User;
@interface AddUserOnLineRequest : JSONModel
@property(strong, nonatomic) NSString* userId;
@property(strong, nonatomic) NSString* platform; //ANDROID, IOS, WINDOWSPHONE
@property(strong, nonatomic) NSString* language; //vi, en.yokara
@property(strong, nonatomic) NSString* packageName;
@property(strong, nonatomic) NSString* version;
@property(strong, nonatomic)  LiveRoom *liveRoom;
@property(strong, nonatomic)  User * user;
@end

