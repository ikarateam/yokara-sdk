//
//  Response.h
//  Yokara
//
//  Created by Rain Nguyen on 4/9/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface Response : JSONModel

@property(strong, nonatomic) NSString * status;
@property(strong, nonatomic) NSString * message;
@property(strong, nonatomic) NSString * action;
@end
