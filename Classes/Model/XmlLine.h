//
//  XmlLine.h
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol XmlWord;
@interface XmlLine : JSONModel
@property (strong, nonatomic)    NSString *sex;
@property (strong, nonatomic)    NSMutableArray <XmlWord> *words;
@property (strong, nonatomic)    NSNumber<Ignore> * isSelected;


@end
