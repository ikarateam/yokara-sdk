//
//  BannedObject.h
//  Karaoke
//
//  Created by Rain Nguyen on 7/5/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BannedObject : JSONModel
@property(strong, nonatomic) NSString * reason;
@property (assign, nonatomic) BOOL banned;
@property (assign, nonatomic) long expiredDate;
@end

NS_ASSUME_NONNULL_END
