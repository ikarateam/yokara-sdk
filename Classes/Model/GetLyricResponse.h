//
//  GetLyricResponse.h
//  Yokara
//
//  Created by Rain Nguyen on 7/9/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "TheLyrics.h"
#import "Lyric.h"
@interface GetLyricResponse : JSONModel
@property (strong, nonatomic) NSString* content;

@end
