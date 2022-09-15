//
//  RiceKaraokeInstrumentalLine.m
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "RiceKaraokeInstrumentalLine.h"
#import "RiceKaraokeLine.h"
#import "RiceKaraokeShow.h"
#import "SimpleKaraokeDisplay.h"
@implementation RiceKaraokeInstrumentalLine

- (id) initRiceKaraokeInstrumentalLine:(SimpleKaraokeDisplay *) display andElap: (CGFloat) elapsed andEnd: (CGFloat) endf {
    self = [super init];
    if (self){
        
    self._display = display;
    self._start = elapsed;
    self.end = endf;
    self._display.type = RICEKARAOKESHOW_TYPE_INSTRUMENTAL;
    [self._display renderInstrumental ] ;
    }
    return self;
}
- (BOOL) update:(CGFloat) elapsed{
    return YES;
}
-(RiceKaraokeLine *) expire:(CGFloat) elapsed{
    return nil;
}

@end
