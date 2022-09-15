//
//  XmlWord.m
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "XmlWord.h"

@implementation XmlWord

- (void) setStartTime1:(NSNumber *) value{
    self.startTime = value;
    self.stringTime = [NSString stringWithFormat:@"%@",value];
    
}
- (NSNumber *) getStartTime1{
    if ([self.startTime isKindOfClass:[NSNumber class]])
        return self.startTime;
    else
        if ([self.stringTime isKindOfClass:[NSString class]]){
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
          //  [f setFormatterBehavior:NSNumberFormatterBehavior10_4];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            f.decimalSeparator=@".";
            f.usesGroupingSeparator = NO;
            NSNumber * num=[f numberFromString:self.stringTime];
            return num;
        }
        else
            return nil;
}

@end
