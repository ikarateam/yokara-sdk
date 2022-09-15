//
//  YoutubeMp4.h
//  Yokara
//
//  Created by APPLE on 10/13/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface YoutubeMp4 : JSONModel
@property (strong, nonatomic) NSString * ext ; //3GP, FLV, WEBM, MP4
@property (strong, nonatomic) NSString * type ; // Low Quality, Medium Quality, High Quality, Full High Quality, Original Definition
@property (strong, nonatomic) NSString * url;
@property (strong, nonatomic) NSString * quality ; //144p, 240p, 360p, 480p, 720p, 1080p, 3072p

@end
