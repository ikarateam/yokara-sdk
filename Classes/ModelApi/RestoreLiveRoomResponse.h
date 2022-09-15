//
//  RestoreLiveRoomResponse.h
//  Karaoke
//
//  Created by Rain Nguyen on 8/19/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RestoreLiveRoomResponse : JSONModel
@property(strong, nonatomic) NSString *  message; // FAILED,  OK
@property(strong, nonatomic) NSString *  status;
@end

NS_ASSUME_NONNULL_END
