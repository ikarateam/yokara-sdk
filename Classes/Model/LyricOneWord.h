//
//  LyricOneWord.h
//  Yokara
//
//  Created by APPLE on 2/15/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface LyricOneWord : JSONModel
@property (strong,nonatomic)NSString *stringTime;
@property (strong,nonatomic)NSString *text;
@property (strong,nonatomic)NSNumber *startTime;

@end
