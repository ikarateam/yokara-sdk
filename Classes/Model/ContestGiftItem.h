//
//  ContestGiftItem.h
//  Karaoke
//
//  Created by Rain Nguyen on 6/3/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ContestGiftItem : JSONModel
@property(strong, nonatomic) NSString *  imageUrl;
@property(strong, nonatomic) NSString *  text;
@end

NS_ASSUME_NONNULL_END
