//
//  Gift.m
//  Yokara
//
//  Created by Rain Nguyen on 7/19/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import "Gift.h"

@implementation Gift
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                                  @"id": @"giftId"
                                                                
                                                                  }];
}

@end
