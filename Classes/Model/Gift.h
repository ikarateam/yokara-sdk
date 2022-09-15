//
//  Gift.h
//  Yokara
//
//  Created by Rain Nguyen on 7/19/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"


@interface Gift : JSONModel
@property (strong, nonatomic) NSString *giftId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSNumber * buyPrice;
@property (strong, nonatomic) NSNumber *sellPrice;
@property (strong, nonatomic) NSNumber *noItem;

@property(strong, nonatomic) NSString * animatedUrl;    //.PNG .SVGA .WEBP
@property(strong, nonatomic) NSString * type; //STATIC ANIMATED
@property(strong, nonatomic) NSString * tag; //NORMAL EVENT NEW

@property (assign, nonatomic) long score;
@end
