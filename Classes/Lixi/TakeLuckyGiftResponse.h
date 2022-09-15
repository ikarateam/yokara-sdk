//
//  TakeLuckyGiftResponse.h
//  Karaoke
//
//  Created by Rain Nguyen on 11/19/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JSONModel.h"
@class Gift;
NS_ASSUME_NONNULL_BEGIN
@interface TakeLuckyGiftResponse : JSONModel
@property(strong, nonatomic) NSString * status;
@property(strong, nonatomic) NSString * message;
@property(strong, nonatomic) Gift *gift;

@end

NS_ASSUME_NONNULL_END
