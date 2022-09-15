//
//  OpenLiveRoom.h
//  Karaoke
//
//  Created by Rain Nguyen on 10/22/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN
@class LiveRoom;
@class User;
@interface OpenLiveRoom : JSONModel
@property(strong, nonatomic) LiveRoom *liveRoom;
@property(strong, nonatomic) User *user;

@end

NS_ASSUME_NONNULL_END
