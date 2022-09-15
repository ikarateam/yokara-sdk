//
//  UpdateFacebookNoForRecordingRespone.h
//  Yokara
//
//  Created by Rain Nguyen on 7/23/19.
//  Copyright (c) 2019 Unitel All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface UpdateFacebookNoForRecordingRequest : JSONModel
@property(strong, nonatomic) NSString* userId;
@property(strong, nonatomic) NSString* platform; //ANDROID, IOS, WINDOWSPHONE
@property(strong, nonatomic) NSString* language; //vi, en.Yokara
@property(strong, nonatomic) NSString* packageName;
@property(strong, nonatomic) NSString* recordingId;
@property(strong, nonatomic) NSNumber* noLike;
@property(strong, nonatomic) NSNumber* noComment;
@property(strong, nonatomic) NSString* facebookId;
@property(strong, nonatomic) NSString* password;

@end
