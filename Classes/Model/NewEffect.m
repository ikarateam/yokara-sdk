//
//  NewEffect.m
//  Yokara
//
//  Created by APPLE on 1/4/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import "NewEffect.h"

@implementation NewEffect

- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        
       
        _name = [dict objectForKey:@"name"];
        _type = [dict objectForKey:@"type"];
        
        _version = [dict objectForKey:@"version"];
        _preset = [dict objectForKey:@"preset"];
        _parameters = [dict objectForKey:@"parameters"];
       
    }
    return self;
}

@end
