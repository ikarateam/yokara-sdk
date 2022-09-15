//
//  GetSongResponse.h
//  Yokara
//
//  Created by Rain Nguyen on 6/27/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "Song.h"
@interface GetSongResponse : JSONModel
@property (strong, nonatomic) Song* song;
@property (strong, nonatomic) NSNumber* vipProblem ;
@property(strong, nonatomic) NSString* message;

@end
