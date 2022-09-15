//
//  RiceKaraokeReadyLine.m
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "RiceKaraokeReadyLine.h"
#import "SimpleKaraokeDisplay.h"
#import "RiceKaraokeShow.h"
@implementation RiceKaraokeReadyLine


-(id) initRiceKaraokeReadyLine:(SimpleKaraokeDisplay *) display andElap:(CGFloat) elapsed andCount: (CGFloat) countdown{
    self = [super init];
    if (self){
    self._display = display;
    self._start = elapsed;
   self.end = elapsed + countdown;
        self._display.type = RICEKARAOKESHOW_TYPE_READY;
        [self._display renderReadyCountdown:lroundf(countdown )];
    }
    return self;
}
-(BOOL) update:(CGFloat) elapsed{
    CGFloat countdown = self.end - elapsed;
    [self._display renderReadyCountdown:lroundf(countdown )];
    return YES;
}
-(RiceKaraokeLine *) expire:(CGFloat) elapsed{
    return nil;
}

@end
