//
//  LogStreamRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 8/15/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LogStreamRequest : JSONModel
@property(strong, nonatomic) NSString * streamId;
@property(strong, nonatomic) NSString * facebookId;
@property(strong, nonatomic) NSString * message;

@end

NS_ASSUME_NONNULL_END
