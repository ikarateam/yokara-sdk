//
//  SimpleKaraokeDisplayEngine.h
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CSLinearLayoutView.h"
@protocol SimpleKaraokeDisplay;
@class SimpleKaraokeDisplay;

@class KaraokeDisplay;
@interface SimpleKaraokeDisplayEngine : NSObject{

 
}
@property (strong, nonatomic)  CSLinearLayoutView * _container;
@property (strong, nonatomic)  NSMutableArray<SimpleKaraokeDisplay> *_displays;
-(id) initSimpleKaraokeDisplayEngine:(KaraokeDisplay *)karaokeDisplay andCon:( CSLinearLayoutView *) container andLine:( int )numLines;
-(SimpleKaraokeDisplay *) getDisplay:(int )displayIndex;
-(void) clear;
-(void) updateFontSize;

@end
