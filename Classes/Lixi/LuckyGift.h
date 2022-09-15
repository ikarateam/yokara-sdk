//
//  LuckyGift.h
//  Karaoke
//
//  Created by Rain Nguyen on 11/19/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol Gift;
@interface LuckyGift : JSONModel
@property(strong, nonatomic) NSString *_id;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *descript;
@property(strong, nonatomic) NSString *backgroundUrl;
@property(strong, nonatomic) NSMutableArray<Gift>* gifts;
@property(assign, nonatomic) long startDate;
@property(assign, nonatomic) long endDate;
@property(assign, nonatomic) long buyPrice;
@property(assign, nonatomic) long order;
@end

NS_ASSUME_NONNULL_END
