//
//  RemoveCommentRecordingRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 6/18/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface RemoveCommentRecordingRequest : JSONModel<NSCoding>
@property(strong, nonatomic) NSString* firebaseId;
@property(strong, nonatomic) NSString* parentCommentId;
@property(strong, nonatomic) NSNumber* recordingId;
@property(strong, nonatomic) NSString* facebookId;
@end

