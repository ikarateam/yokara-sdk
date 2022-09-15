//
//  Line.m
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "Line.h"

@implementation Line
- (NSComparisonResult) compareWithAnotherFoo:(Line*) anotherFoo{
    if (anotherFoo.start) {
        return [self.start compare: anotherFoo.start] ;
    }else{
        return NSOrderedAscending;
    }
    
}

@end
