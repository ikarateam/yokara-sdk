//
//  RiceKaraoke.m
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "RiceKaraoke.h"
#import "Line.h"
#import "Word.h"
#import "RiceKaraokeShow.h"
@implementation RiceKaraoke

-(id) initRiceKaraoke:(NSMutableArray<Line> *)timing{
    self =[super init];
    if (self){
    self.timings =timing;
        [self.timings sortUsingSelector:@selector(compareWithAnotherFoo:)];
        /*[self.timings sortedArrayUsingComparator:^(Line a, Line b) {
            int first = [[a.start intValue];
            int second = [[b.start intValue];
            
            if ( first < second ) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if ( first > second ) {
                return (NSComparisonResult)NSOrderedDescending;
            } else {
                return (NSComparisonResult)NSOrderedSame;
            }
        }];
         
    Collections.sort(self.timings, new Comparator<Line>() {
        public int compare(Line a, Line b) {
            if (a.start == b.start) {
                return 0;
            }
            return a.start < b.start ? -1 : 1;
        };
    });*/
    }
    return self;
}
-(NSMutableArray<Line> *) simpleTimingToTiming:(NSMutableArray<Line> *) simpleTimings{
    if (!self.timings){
    self.timings = [NSMutableArray new];
    }
    for (int i =0 ; i < simpleTimings.count; i++) {
        Line *newLine = [Line new];
        Line *tmpLine=[simpleTimings objectAtIndex:i];
        newLine.start=tmpLine.start;
        newLine.end=tmpLine.end;
        newLine.renderOptions=tmpLine.renderOptions;
        newLine.line = [self simpleKarakokeToKaraoke:tmpLine.line andOption:tmpLine.renderOptions];
        [self.timings addObject: newLine];
    }
    return self.timings;
}
-(NSMutableArray<Word> *)simpleKarakokeToKaraoke:(NSMutableArray<Word> *) simpleKaraoke andOption:(RenderOptions *) renderOptionsOfLine{
    @autoreleasepool {
        
    NSMutableArray<Word> *karaoke=[[NSMutableArray alloc] init];
    for (int i = 0 ; i < simpleKaraoke.count; i++) {
        Word * newWord=[Word alloc];
        Word * tmpWord=[simpleKaraoke objectAtIndex:i];
        newWord.start=tmpWord.start;
        newWord.end=tmpWord.end;
        newWord.text=tmpWord.text;
        if (!tmpWord.renderOptions) newWord.renderOptions=tmpWord.renderOptions;
        else newWord.renderOptions=renderOptionsOfLine;
        [karaoke addObject:newWord];
    }
    return karaoke;
    }
}

-(RiceKaraokeShow *) createShow:(SimpleKaraokeDisplayEngine *)displayEngine andLine:( int) numLines{
    return [[RiceKaraokeShow alloc] initRiceKaraokeShow:self andEn:displayEngine andLine:numLines];
}

@end
