//
//  SetTopSongInQueueResponse.h
//  Likara
//
//  Created by Rain Nguyen on 3/18/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SetTopSongInQueueResponse :JSONModel
@property(strong, nonatomic) NSString*  message;
@property(strong, nonatomic) NSString*  status; //FAILED, OK
@property (assign, nonatomic) long position;
@end

NS_ASSUME_NONNULL_END
