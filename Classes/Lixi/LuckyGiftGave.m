//
//  LuckyGiftGave.m
//  Karaoke
//
//  Created by Rain Nguyen on 11/19/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import "LuckyGiftGave.h"

@implementation LuckyGiftGave
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"id": @"_id"
       
    }];
}
@end
