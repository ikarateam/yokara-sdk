//
//  GetYoutubeVideoLinksRequest.h
//  Yokara
//
//  Created by Rain Nguyen on 8/6/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface GetYoutubeVideoLinksRequest : JSONModel
@property (strong, nonatomic) NSString * userId;
@property (strong, nonatomic) NSString * platform; //ANDROID, IOS, WINDOWSPHONE
@property (strong, nonatomic) NSString * language;
@property (strong, nonatomic) NSString * content;
@property (strong, nonatomic) NSString * videoId;

@end
