//
//  GetAllFollowingUsersResponse.h
//  Karaoke
//
//  Created by Rain Nguyen on 11/30/20.
//  Copyright © 2020 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol User;
@interface GetAllFollowingUsersResponse : JSONModel
@property(strong, nonatomic) NSMutableArray<User> * users;

@end

NS_ASSUME_NONNULL_END
