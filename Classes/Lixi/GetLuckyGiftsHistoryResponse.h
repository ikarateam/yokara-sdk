//
//  GetLuckyGiftsHistoryResponse.h
//  Karaoke
//
//  Created by Rain Nguyen on 11/19/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol LuckyGiftHistory;
@interface GetLuckyGiftsHistoryResponse : JSONModel
@property(strong, nonatomic) NSMutableArray<LuckyGiftHistory>* luckyGiftsHistory;
@property(strong, nonatomic) NSString* message;
@end

NS_ASSUME_NONNULL_END
