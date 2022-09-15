//
//  Effect.h
//  iMimic
//
//  Created by APPLE on 3/22/19.
//  Copyright © 2019 vnapps. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import <SCRecorder/SCRecorder.h>
@interface Effect : JSONModel
@property(strong, nonatomic) NSString* _id;
@property(strong, nonatomic) SCFilter* filter;
@property(strong, nonatomic) NSString* image;
@property(strong, nonatomic) NSString* name;


@end
