//
//  SimpleKaraokeDisplayEngine.m
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "SimpleKaraokeDisplayEngine.h"
#import "SimpleKaraokeDisplay.h"
#import "CSLinearLayoutView.h"
@implementation SimpleKaraokeDisplayEngine

-(id) initSimpleKaraokeDisplayEngine:(KaraokeDisplay *)karaokeDisplay andCon:( CSLinearLayoutView *) container andLine:( int )numLines{
    self = [super init];
    self._displays = [NSMutableArray new];
    if (self){
    self._container = container;
    [self clear];
    for (int i = 0; i < numLines; i++) {
        [self._displays addObject:[[SimpleKaraokeDisplay alloc] initSimpleKaraokeDisplay:karaokeDisplay andEngine:self andCon:container andDis:i]];
    }
    }
    return self;
}
-(SimpleKaraokeDisplay *) getDisplay:(int )displayIndex{
    return [self._displays objectAtIndex: displayIndex];
}
-(void) clear{
    [self._displays removeAllObjects];
    [self._container removeAllItems];
}
-(void) updateFontSize{
    for (int i = 0; i < self._displays.count; i++) {
        [[self._displays objectAtIndex:i] updateFontSize];
    }
}

@end
