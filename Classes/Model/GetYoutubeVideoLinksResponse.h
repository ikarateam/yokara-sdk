//
//  GetYoutubeVideoLinksResponse.h
//  Yokara
//
//  Created by Rain Nguyen on 8/6/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol Video;
@interface GetYoutubeVideoLinksResponse : JSONModel
@property (strong, nonatomic) NSString * youtubeId;
@property (strong, nonatomic) NSMutableArray<Video> *links;

@end
