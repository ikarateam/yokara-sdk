//
//  XmlWord.h
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface XmlWord : JSONModel
@property (strong, nonatomic)    NSNumber* startTime;
@property (strong, nonatomic)    NSString *stringTime;
@property (strong, nonatomic)    NSString *text;

- (void) setStartTime1:(NSNumber *) value;
- (NSNumber *) getStartTime1;

@end
