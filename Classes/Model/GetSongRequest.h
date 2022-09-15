//
//  GetSongRequest.h
//  Yokara
//
//  Created by Rain Nguyen on 6/27/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface GetSongRequest : JSONModel
@property (strong, nonatomic) NSString* userId;
@property (strong, nonatomic) NSString* songId;
@property (strong, nonatomic) NSString* facebookId;
@property (strong, nonatomic) NSNumber* isVIP;

@end
