//
//  RiceKaraokeInstrumentalLine.h
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
@class SimpleKaraokeDisplay;
#import  "RiceKaraokeLine.h"
@interface RiceKaraokeInstrumentalLine : RiceKaraokeLine

- (id) initRiceKaraokeInstrumentalLine:(SimpleKaraokeDisplay *) display andElap: (CGFloat) elapsed andEnd: (CGFloat) end ;
- (BOOL) update:(CGFloat) elapsed;
-(RiceKaraokeLine *) expire:(CGFloat) elapsed;

@end
