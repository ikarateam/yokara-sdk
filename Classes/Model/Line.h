//
//  Line.h
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol Word;
@class RenderOptions;
@interface Line : JSONModel{
 
}
@property (strong, nonatomic) NSNumber * start;
@property (strong, nonatomic)    NSNumber* end;
@property (strong, nonatomic)    NSString* sex;
@property (strong, nonatomic)    NSMutableArray<Word> *line;
@property (strong, nonatomic)    RenderOptions *renderOptions;
@property (strong, nonatomic)    NSNumber<Ignore> * isSelected;


@end
