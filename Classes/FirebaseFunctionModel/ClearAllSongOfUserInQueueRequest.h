//
//  ClearAllSongOfUserInQueueRequest.h
//  Likara
//
//  Created by Rain Nguyen on 6/3/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@interface ClearAllSongOfUserInQueueRequest : JSONModel<NSCoding>
@property(strong, nonatomic) NSString* userId;
@property(strong, nonatomic) NSString* roomId;
@end

