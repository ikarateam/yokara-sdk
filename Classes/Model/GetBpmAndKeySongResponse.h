//
//  GetBpmAndKeySongResponse.h
//  Yokara
//
//  Created by Rain Nguyen on 3/30/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface GetBpmAndKeySongResponse : JSONModel
@property(strong, nonatomic) NSNumber * bpm;
@property(strong, nonatomic) NSString * key;

@end
