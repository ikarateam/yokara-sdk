//
//  SetTopSongInQueueRequest.h
//  Likara
//
//  Created by Rain Nguyen on 3/16/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN
@class Song;
@interface SetTopSongInQueueRequest :JSONModel
@property(strong, nonatomic) NSString* roomId;
@property(strong, nonatomic) Song* song;
@property(strong, nonatomic) NSString* userActionId;
@end

NS_ASSUME_NONNULL_END
