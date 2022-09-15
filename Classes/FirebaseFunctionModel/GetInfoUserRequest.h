//
//  GetInfoUserRequest.h
//  Likara
//
//  Created by Rain Nguyen on 3/16/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GetInfoUserRequest :JSONModel
@property(strong, nonatomic) NSString* userId;
@property(strong, nonatomic) NSString* roomId;
@end

NS_ASSUME_NONNULL_END
