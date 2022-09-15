//
//  DoNothingLiveStreamRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 6/17/20.
//  Copyright © 2020 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@interface DoNothingLiveStreamRequest : JSONModel
@property(strong, nonatomic) NSString * streamId;
@property(strong, nonatomic) NSString * facebookId;

@end

