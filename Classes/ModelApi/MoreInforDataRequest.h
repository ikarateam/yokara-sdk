//
//  MoreInforDataRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 11/4/20.
//  Copyright © 2020 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MoreInforDataRequest : JSONModel
@property(strong, nonatomic) NSString *  streamId;
@property(strong, nonatomic) NSString *  streamName;
@property(strong, nonatomic) NSString *  facebookId;
@property(strong, nonatomic) NSString *  facebookName;
@end

NS_ASSUME_NONNULL_END
