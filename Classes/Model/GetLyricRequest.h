//
//  GetLyricRequest.h
//  Yokara
//
//  Created by Rain Nguyen on 7/9/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface GetLyricRequest : JSONModel
@property (strong, nonatomic) NSString*  lyricKey;
@property (strong, nonatomic) NSString*  userId;

@end
