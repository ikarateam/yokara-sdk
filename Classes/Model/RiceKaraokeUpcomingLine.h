//
//  RiceKaraokeUpcomingLine.h
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "RiceKaraokeLine.h"
@class SimpleKaraokeDisplay;

@class Line;
@interface RiceKaraokeUpcomingLine : RiceKaraokeLine
-(id) initRiceKaraokeUpcomingLine:(SimpleKaraokeDisplay *) display andElap: (CGFloat) elapsed andTime:( Line *) timing;
-(BOOL) update:(CGFloat) elapsed;
-(RiceKaraokeLine *) expire:(CGFloat) elapsed;

@end
