//
//  Word.h
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
@class RenderOptions;
#import "JSONModel.h"
@interface Word : JSONModel
@property (strong, nonatomic)    NSNumber* start;
@property (strong, nonatomic)    NSString *text;
@property (strong, nonatomic)    NSNumber* end;
@property (strong, nonatomic)    RenderOptions *renderOptions;



@end
