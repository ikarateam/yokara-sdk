//
//  LiveRoom.m
//  Likara
//
//  Created by Rain Nguyen on 3/10/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import "LiveRoom.h"

@implementation LiveRoom
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"id": @"_id",
        @"uid": @"uid",
        @"description": @"descript",
        @"owner": @"owner",
        @"privacyLevel": @"privacyLevel",
        @"bulletin": @"bulletin",
        @"type": @"type",
        @"thumbnail": @"thumbnail",
        @"noOnlineMembers": @"noOnlineMembers",
        @"noOnlineMembers": @"noOnlineMembers",
        @"queueLimit": @"queueLimit",
        @"whoCanSing": @"whoCanSing",
        @"totalGiftScore": @"totalGiftScore"
    }];
}
@end

