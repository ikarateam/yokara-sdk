//
//  Recording.m
//  Yokara
//
//  Created by Rain Nguyen on 8/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "Recording.h"

@implementation Recording
- (Recording *)init {
    if (self = [super init]) {
       self.playWithSubVideo=@"TRUE";
    }
    return self;
}
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                                  @"effectsNew": @"newEffects"
                                                                  
                                                                  }];
}

@end
