//
//  Lyrics.h
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol XmlLine;
@interface Lyrics : JSONModel
@property (strong, nonatomic)    NSMutableArray<XmlLine> *lines;



@end
