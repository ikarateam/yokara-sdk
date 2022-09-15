//
//  LuckyGift.m
//  Karaoke
//
//  Created by Rain Nguyen on 11/19/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import "LuckyGift.h"

@implementation LuckyGift
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"id": @"_id",
        @"description": @"descript",
    }];
}
@end
