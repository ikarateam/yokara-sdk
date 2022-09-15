//
//  GetFriendsStatusResponse.h
//  Karaoke
//
//  Created by Rain Nguyen on 7/15/20.
//  Copyright © 2020 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetFriendsStatusResponse :JSONModel
@property(strong, nonatomic) NSMutableArray * friendsStatus;
@end

NS_ASSUME_NONNULL_END
