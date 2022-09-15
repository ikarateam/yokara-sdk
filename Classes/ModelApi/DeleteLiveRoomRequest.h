//
//  DeleteLiveRoomRequest.h
//  Likara
//
//  Created by Rain Nguyen on 3/12/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DeleteLiveRoomRequest : JSONModel
@property(strong, nonatomic) NSString * userId;
       @property(strong, nonatomic) NSString * platform; //ANDROID, IOS, WINDOWSPHONE
       @property(strong, nonatomic) NSString * language; //vi, en.yokara
       @property(strong, nonatomic) NSString * packageName;
@property(assign, nonatomic) long roomId;
@end

NS_ASSUME_NONNULL_END
