//
//  CreateLiveRoomRequest.h
//  Likara
//
//  Created by Rain Nguyen on 3/10/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LiveRoom;
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CreateLiveRoomRequest : JSONModel
@property(strong, nonatomic) NSString * userId;
       @property(strong, nonatomic) NSString * platform; //ANDROID, IOS, WINDOWSPHONE
       @property(strong, nonatomic) NSString * language; //vi, en.yokara
       @property(strong, nonatomic) NSString * packageName;

       @property(strong, nonatomic)  LiveRoom * liveRoom;
@end

NS_ASSUME_NONNULL_END
