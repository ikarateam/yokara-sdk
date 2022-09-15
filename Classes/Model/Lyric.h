//
//  Lyric.h
//  Yokara
//
//  Created by Rain Nguyen on 6/27/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "JSONModel.h"
@class User;
@interface Lyric : JSONModel
@property(strong, nonatomic) NSString* key;
@property(strong, nonatomic) NSNumber* privatedId;
@property(strong, nonatomic) NSString* ownerId;
@property(strong, nonatomic) NSString* url;
@property(strong, nonatomic) NSString* content;
@property(strong, nonatomic) NSNumber* openningNo;
@property(strong, nonatomic) NSNumber* totalRating;
@property(strong, nonatomic) NSNumber* ratingCount;
@property(strong, nonatomic) NSString* date;
@property(strong, nonatomic) NSNumber* yourRating;
@property(strong, nonatomic) NSNumber* type;
@property(strong, nonatomic) User<Optional>* owner;

@end
