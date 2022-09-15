//
//  StreamFirebase.h
//  Yokara
//
//  Created by Rain Nguyen on 4/20/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@class EffectFirebase;
@interface StreamFirebase : JSONModel

@property(strong, nonatomic) NSString *  status;
@property(strong, nonatomic) NSString *  message;
@property(strong, nonatomic) NSNumber * offsetPosition;
@property(strong, nonatomic) NSNumber* duration;
@property(strong, nonatomic)  EffectFirebase *effects;

@end
