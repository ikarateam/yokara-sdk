//
//  RiceKaraokeKaraokeLine.h
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "RiceKaraokeLine.h"
@class Word;
@protocol Word;
@class Line;
#import "SimpleKaraokeDisplay.h"

@interface RiceKaraokeKaraokeLine : RiceKaraokeLine
{
 
}
@property (strong, nonatomic) Line * _timing;
@property (atomic)int currentFragmentIndex;
@property (strong, nonatomic) NSMutableArray<Word> *passedFragments;
@property (strong, nonatomic) Word *currentFragment;
@property (strong, nonatomic) NSMutableArray<Word> *upcomingFragments;
@property (strong, nonatomic) NSString *passedText;
@property (atomic)CGFloat passedTextWidth;
@property (atomic)CGFloat currentTextWidth;
@property (atomic)CGFloat totalTextWidth;
-(id) initRiceKaraokeKaraokeLine:(SimpleKaraokeDisplay *) display andElap: (CGFloat) elapsed andTime:( Line *) timing;
-(BOOL)  update:(CGFloat) elapsed;
- (RiceKaraokeLine *) expire:(CGFloat) elapsed;

@end
