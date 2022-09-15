//
//  RiceKaraokeShow.h
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#define RICEKARAOKESHOW_TYPE_UPCOMING 0
#define  RICEKARAOKESHOW_TYPE_READY 1
#define  RICEKARAOKESHOW_TYPE_INSTRUMENTAL  2
#define  RICEKARAOKESHOW_TYPE_KARAOKE 3
#import "SimpleKaraokeDisplayEngine.h"
#import "RiceKaraoke.h"
@protocol RiceKaraokeLine;
@class SimpleKaraokeDisplay;
@interface RiceKaraokeShow : NSObject{


}
@property (strong, nonatomic) RiceKaraoke *_engine;
@property (strong, nonatomic) SimpleKaraokeDisplayEngine *_displayEngine;
@property (atomic) int _numLines;
@property (strong, nonatomic) NSMutableArray<RiceKaraokeLine> *_displays;
@property (atomic) BOOL showReady;
@property (atomic) BOOL showInstrumental;
@property (atomic) CGFloat antiFlickerThreshold;
@property (atomic) int upcomingThreshold;
@property (atomic) int readyThreshold;
@property (atomic) int _index;
@property (atomic) CGFloat _relativeLastKaraokeLine;
@property (atomic) BOOL _hasReadyLine;
@property (atomic) BOOL _hasInstrumentalLine;
-(id) initRiceKaraokeShow:(RiceKaraoke *) engine andEn:
(SimpleKaraokeDisplayEngine *) displayEngine andLine:(int) numLines;
- (void) reset;
-(void) render:(CGFloat) elapsed;
-(SimpleKaraokeDisplay *) getDisplay:(int) displayIndex;

@end
