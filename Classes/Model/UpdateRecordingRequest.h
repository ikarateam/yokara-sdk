//
//  UpdateRecordingRequest.h
//  Yokara
//
//  Created by Rain Nguyen on 9/11/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@class Recording;
@interface UpdateRecordingRequest : JSONModel
@property (strong, nonatomic)Recording * recording;
@property (strong, nonatomic) NSString*  userId;

@end
