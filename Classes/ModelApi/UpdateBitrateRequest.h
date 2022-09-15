//
//  UpdateBitrateRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 11/16/20.
//  Copyright © 2020 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UpdateBitrateRequest : JSONModel
@property(strong, nonatomic) NSString * streamId;
@property(strong, nonatomic) NSString * facebookId;
@property(assign, nonatomic) long bitrate; // 128000 96000 64000 48000 32000
@end

NS_ASSUME_NONNULL_END
