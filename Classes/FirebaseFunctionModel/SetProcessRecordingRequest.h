//
//  SetProcessRecordingRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 7/2/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>




#import "JSONModel.h"
@interface SetProcessRecordingRequest : JSONModel
@property(strong, nonatomic)  NSNumber * recordingId;
@property(strong, nonatomic) NSString* message;
@property(strong, nonatomic) NSString* status;

@end

