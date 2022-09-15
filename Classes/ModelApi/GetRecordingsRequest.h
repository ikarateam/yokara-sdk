//
//  GetRecordingsRequest.h
//  Yokara
//
//  Created by Rain Nguyen on 9/23/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface GetRecordingsRequest : JSONModel

@property (strong, nonatomic) NSString*  userId;
@property (strong, nonatomic) NSString* ownerKey;
@property (strong, nonatomic) NSString* language;
@property (strong, nonatomic) NSString* cursor;
@property (strong, nonatomic) NSString* ownerFacebookId;

@end
