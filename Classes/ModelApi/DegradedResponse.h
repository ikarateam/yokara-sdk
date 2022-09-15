//
//  DegradedResponse.h
//  Karaoke
//
//  Created by Rain Nguyen on 10/27/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DegradedResponse : JSONModel

@property(strong, nonatomic) NSString * status;
@property(strong, nonatomic) NSString * message;
@end

NS_ASSUME_NONNULL_END
