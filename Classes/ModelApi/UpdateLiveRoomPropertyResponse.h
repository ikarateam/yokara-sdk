//
//  UpdateLiveRoomPropertyResponse.h
//  Likara
//
//  Created by Rain Nguyen on 3/10/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UpdateLiveRoomPropertyResponse :JSONModel
@property(strong, nonatomic) NSString*  message;
@property(strong, nonatomic) NSString*  status; //FAILED, OK

@end

NS_ASSUME_NONNULL_END
