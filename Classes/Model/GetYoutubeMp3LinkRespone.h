//
//  GetYoutubeMp3LinkRespone.h
//  Yokara
//
//  Created by Rain Nguyen on 7/16/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>

#import "JSONModel.h"
@interface GetYoutubeMp3LinkRespone : JSONModel
@property (strong, nonatomic) NSString * youtubeId;
@property (strong, nonatomic) NSString * url;

@end
