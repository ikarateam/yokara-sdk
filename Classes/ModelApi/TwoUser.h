//
//  TwoUser.h
//  Karaoke
//
//  Created by Admin on 15/12/2021.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN
@class User;
@interface TwoUser : JSONModel

@property(strong, nonatomic) User *fromUser;
@property(strong, nonatomic) User * toUser;
@end

NS_ASSUME_NONNULL_END
