//
//  ContestRules.h
//  Karaoke
//
//  Created by Rain Nguyen on 6/3/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol TextContestRule;
@protocol ContestGiftItem;
@interface ContestRules : JSONModel
@property(strong, nonatomic) NSMutableArray <TextContestRule> *textContestRules ;
@property(strong, nonatomic) NSMutableArray <ContestGiftItem> *gifts_1;
@property(strong, nonatomic) NSMutableArray <ContestGiftItem>* gifts_2;
@property(strong, nonatomic) NSMutableArray <ContestGiftItem>* gifts_3;
@property(strong, nonatomic) NSMutableArray <ContestGiftItem>* gifts_4_10;
@end

NS_ASSUME_NONNULL_END
