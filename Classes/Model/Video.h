//
//  Video.h
//  Yokara
//
//  Created by Rain Nguyen on 8/6/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface Video : JSONModel
@property (strong, nonatomic) NSString * ext ; //3GP, FLV, WEBM, MP4
@property (strong, nonatomic) NSString * type ; // Low Quality, Medium Quality, High Quality, Full High Quality, Original Definition
@property (strong, nonatomic) NSString * url;
@property (strong, nonatomic) NSString * def ; //144p, 240p, 360p, 480p, 720p, 1080p, 3072p
@property (strong, nonatomic) NSString * res ;

@end
