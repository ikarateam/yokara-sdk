//
//  GetYoutubeMp3LinkRequest.h
//  Yokara
//
//  Created by Rain Nguyen on 7/23/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@class Song;
@interface GetYoutubeMp3LinkRequest : JSONModel
@property (strong, nonatomic) NSString * userId;
@property (strong, nonatomic) NSString * platform; //ANDROID, IOS, WINDOWSPHONE
@property (strong, nonatomic) NSString * language;
@property (strong, nonatomic) NSString * videoId;
@property (strong, nonatomic) NSString * packageName;
@property (strong, nonatomic) NSString * version;
@property (strong, nonatomic) NSString * songName;
@property (strong, nonatomic) NSNumber * pitchShift;
@property (strong, nonatomic) NSMutableArray* contents;
@end
