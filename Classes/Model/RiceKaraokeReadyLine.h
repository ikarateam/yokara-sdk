//
//  RiceKaraokeReadyLine.h
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "RiceKaraokeLine.h"
@class SimpleKaraokeDisplay;
#import <UIKit/UIKit.h>
@interface RiceKaraokeReadyLine : RiceKaraokeLine

-(id) initRiceKaraokeReadyLine:(SimpleKaraokeDisplay *) display andElap:(CGFloat) elapsed andCount: (CGFloat) countdown;
-(BOOL) update:(CGFloat) elapsed;
-(RiceKaraokeLine *) expire:(CGFloat) elapsed;

@end
