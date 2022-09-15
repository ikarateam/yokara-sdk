//
//  RemoveUserOnLineRequest.h
//  Likara
//
//  Created by Rain Nguyen on 5/22/20.
//  Copyright © 2020 Likara. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "JSONModel.h"
@class LiveRoom;
@interface RemoveUserOnLineRequest : JSONModel<NSCoding>
 @property(strong, nonatomic) NSString* roomId;
@end
