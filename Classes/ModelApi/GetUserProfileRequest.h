//
//  GetUserProfileRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 10/21/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GetUserProfileRequest : JSONModel

@property(strong, nonatomic) NSString * userId;

@property(strong, nonatomic) NSString *  language;
@property(strong, nonatomic) NSString *  ownerFacebookId;
@property(strong, nonatomic) NSString *  ownerKey;
@end

NS_ASSUME_NONNULL_END
