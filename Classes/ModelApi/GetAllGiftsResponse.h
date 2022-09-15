//
//  GetAllGiftsResponse.h
//  Yokara
//
//  Created by Rain Nguyen on 7/19/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
@protocol Gift;
#import "JSONModel.h"
@interface GetAllGiftsResponse : JSONModel
@property(strong, nonatomic)  NSMutableArray <Gift> *gifts ;


@end
