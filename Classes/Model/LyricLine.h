//
//  LyricLine.h
//  Yokara
//
//  Created by APPLE on 2/15/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol LyricOneLine;
@interface LyricLine : JSONModel
@property (strong,nonatomic) NSMutableArray <LyricOneLine>*lines;

@end
