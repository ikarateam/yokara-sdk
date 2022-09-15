//
//  GetInfoUserOnlineResponse.h
//  Likara
//
//  Created by Rain Nguyen on 3/16/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GetInfoUserOnlineResponse :JSONModel
@property(strong, nonatomic) NSString* message;
@property(strong, nonatomic) NSString* status; //FAIL, OK
@property(strong, nonatomic) NSString* userType;
@end

NS_ASSUME_NONNULL_END
