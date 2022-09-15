//
//  UploadRecordingResponse.h
//  Yokara
//
//  Created by Rain Nguyen on 8/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@class Recording;
@interface UploadRecordingResponse : JSONModel
@property (strong, nonatomic) Recording*  recording;




@end
