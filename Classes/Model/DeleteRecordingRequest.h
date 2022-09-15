//
//  DeleteRecordingRequest.h
//  Yokara
//
//  Created by Rain Nguyen on 9/25/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface DeleteRecordingRequest : JSONModel
@property (strong, nonatomic) NSString*  userId;
@property (strong, nonatomic) NSString*  recordingId;
@property(strong, nonatomic) NSString*  language;
@property(strong, nonatomic) NSString*  facebookId;
@property(strong, nonatomic) NSString*  password;

@end
