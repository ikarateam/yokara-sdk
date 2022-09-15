//
//  GetAllLuckyGiftsResponse.h
//  Karaoke
//
//  Created by Rain Nguyen on 11/19/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
@protocol LuckyGift;
NS_ASSUME_NONNULL_BEGIN
@interface GetAllLuckyGiftsResponse : JSONModel
@property(strong, nonatomic) NSMutableArray  <LuckyGift> * luckyGifts;

@end

NS_ASSUME_NONNULL_END
