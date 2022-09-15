//
//  RiceKaraoke.h
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
@protocol Line;
@protocol Word;
@class Line;
@class RenderOptions;
@class RiceKaraokeShow;
@class SimpleKaraokeDisplayEngine;
@interface RiceKaraoke : NSObject
@property (strong, nonatomic)    NSMutableArray<Line> *timings;

-(id) initRiceKaraoke:(NSMutableArray<Line> *)timings;
-(NSMutableArray<Line> *) simpleTimingToTiming:(NSMutableArray<Line> *) simpleTimings;
-(NSMutableArray<Word> *)simpleKarakokeToKaraoke:(NSMutableArray<Word> *) simpleKaraoke andOption:(RenderOptions *) renderOptions;
-(RiceKaraokeShow *) createShow:(SimpleKaraokeDisplayEngine *)displayEngine andLine:( int) numLines;

@end
