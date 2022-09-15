//
//  McRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 10/3/20.
//  Copyright © 2020 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface McRequest : JSONModel
@property(strong, nonatomic) NSString * streamId;
@property(strong, nonatomic) NSString * facebookId;
@end

NS_ASSUME_NONNULL_END
