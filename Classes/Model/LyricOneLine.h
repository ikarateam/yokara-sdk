//
//  LyricOneLine.h
//  Yokara
//
//  Created by APPLE on 2/15/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol LyricOneWord;
@interface LyricOneLine : JSONModel
@property (strong, nonatomic)    NSMutableArray<LyricOneWord> *words;
@property (strong, nonatomic)  NSString *sex;
@property  (strong, nonatomic)  NSNumber<Ignore>* isSelected;

@end
