//
//  YoutubeMp4Respone.h
//  Yokara
//
//  Created by APPLE on 10/13/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol YoutubeMp4;
@interface YoutubeMp4Respone : JSONModel
@property (strong, nonatomic)NSMutableArray<YoutubeMp4>* videos;

@end
