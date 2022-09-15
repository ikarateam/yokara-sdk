//
//  SeekStreamRequest.h
//  Yokara
//
//  Created by Rain Nguyen on 4/9/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface SeekStreamRequest : JSONModel
@property(strong, nonatomic) NSString * streamName;
@property(strong, nonatomic)  NSNumber* position;

@end
