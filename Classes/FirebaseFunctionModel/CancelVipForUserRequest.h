//
//  CancelVipForUserRequest.h
//  Likara
//
//  Created by Rain Nguyen on 3/16/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CancelVipForUserRequest :JSONModel
@property(strong, nonatomic) NSString* roomId;
@property(strong, nonatomic) NSString* userActionId;
@property(strong, nonatomic) NSString* facebookId;
@property(strong, nonatomic) NSString* name;
@property(strong, nonatomic) NSString* profileImageLink;
@end

NS_ASSUME_NONNULL_END
