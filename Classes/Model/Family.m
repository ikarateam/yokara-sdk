//
//  Family.m
//  Karaoke
//
//  Created by Rain Nguyen on 9/20/21.
//  Copyright © 2021 Nguyen Anh Tuan Vu. All rights reserved.
//

#import "Family.h"

@implementation Family
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"id": @"_id",
        @"description": @"descript",
    }];
}
@end
