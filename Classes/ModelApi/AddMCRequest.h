//
//  AddMCRequest.h
//  Karaoke
//
//  Created by Rain Nguyen on 10/1/20.
//  Copyright © 2020 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddMCRequest : JSONModel
@property(strong, nonatomic) NSString * roomId;
@end

NS_ASSUME_NONNULL_END
