//
//  GetRecordingsResponse.h
//  Yokara
//
//  Created by Rain Nguyen on 8/28/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol Recording;
@class User;
@interface GetRecordingsResponse : JSONModel

@property (strong, nonatomic) User<Optional> *user;
@property (strong, nonatomic) NSMutableArray<Recording> * recordings;
@property (strong, nonatomic) NSString* cursor;

@end
