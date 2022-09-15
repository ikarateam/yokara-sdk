//
//  RiceKaraokeUpcomingLine.m
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "RiceKaraokeUpcomingLine.h"
#import "Word.h"
#import "Line.h"
#import "RiceKaraokeShow.h"
#import "SimpleKaraokeDisplay.h"
#import "RenderOptions.h"
#import "RiceKaraokeKaraokeLine.h"
@implementation RiceKaraokeUpcomingLine
-(id) initRiceKaraokeUpcomingLine:(SimpleKaraokeDisplay *) display andElap: (CGFloat) elapsed andTime:( Line *) timin{
    self = [super init];
    if (self){
        self._display = display;
        self._timing = timin;
        self._elapsed = elapsed;
        self.end = [timin.start floatValue];
        NSString *text = @"";
        for (int i=0 ; i < timin.line.count; i++) {
            Word *lin=[timin.line objectAtIndex:i];
            text = [NSString stringWithFormat:@"%@%@",text, lin.text];
        }
        self._display.type = RICEKARAOKESHOW_TYPE_UPCOMING;
        [self._display renderText:text andSex:timin.renderOptions.sex];
    }
    return self;
}
-(BOOL) update:(CGFloat) elapsed{
    return YES;
}
-(RiceKaraokeLine *) expire:(CGFloat) elapsed{
    return [[RiceKaraokeKaraokeLine alloc] initRiceKaraokeKaraokeLine:self._display andElap:elapsed andTime:self._timing];
}

@end
