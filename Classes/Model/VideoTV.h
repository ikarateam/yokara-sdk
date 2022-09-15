//
//  VideoTV.h
//  Yokara
//
//  Created by APPLE on 4/7/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface VideoTV : JSONModel
 @property(strong, nonatomic) NSString *videoId;
 @property(strong, nonatomic) NSString * videoTitle;
 @property(strong, nonatomic) NSNumber * pitchShift;
 @property(strong, nonatomic) NSNumber * duration;

@end
