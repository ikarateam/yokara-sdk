//
//  KaraokeDisplay.h
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//

#define  TYPE_UPCOMING @"#FFFFFF"
#define TYPE_READY  @"#065BC4"
#define TYPE_INSTRUMENTAL  @"#065BC4"
#define TYPE_KARAOKE  @"#FFFFFF"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CSLinearLayoutView.h"

@protocol Line;
@class Word;
@class RiceKaraoke;
@class Paint;
@class RiceKaraokeShow;
@class SimpleKaraokeDisplayEngine;
@interface KaraokeDisplay : NSObject
{

int numDisplayLines;
 
 CGFloat currentTime;


}
@property (strong, nonatomic) NSMutableArray<Line> *currentTiming;
@property (strong, nonatomic) RiceKaraokeShow *show;
@property (strong, nonatomic) SimpleKaraokeDisplayEngine *renderer;
@property (strong, nonatomic) Paint *paint ;
@property (strong, nonatomic) RiceKaraoke *karaoke;
@property (strong, nonatomic) UIView *context;
@property (strong, nonatomic) CSLinearLayoutView *karaokeDisplayElement;
@property (strong, nonatomic) NSString * longestLine;
-(id) initKaraokeDisplay:(UIView *) context andLine: (CSLinearLayoutView *) karaokeDisplayElement;
-( void) setLanguage:(NSString *)readyL andIns: (NSString *) instrumentalL;
- (void) _updateOrientation;
-(void) updateSettings:(int) numberOfLyrics andMale:(UIColor *) maleLyricColor andFemale: (UIColor *)femaleLyricColor andDuet: (UIColor *) duetLyricColor andOverlay:(UIColor *)overlayColor;
- (void) render:(float )time;
-(void) setTiming:(NSMutableArray<Line> *) timing;
- (void) reset;
-(void) setSimpleTiming:(NSMutableArray <Line> *) simpleTiming ;
-(void) caculateLongestLine;
- (CGFloat) getWidth:(NSString *) currentLine andSize: (CGFloat) textSize ;
- (CGFloat) getHeight:(NSString *) currentLine andSize: (CGFloat) textSize ;
//- (CGFloat)getWidth :(NSString *)string withFont:(UIFont *)font ;
-(int) getMaxFontSize;
-(void) setFontSize:(int )fontSize;


@end
 extern NSString *instrumentalText;
 extern NSString *readyText;
 extern UIColor *maleLyricColorG  ;
 extern UIColor *femaleLyricColorG ;
 extern UIColor *duetLyricColorG;
extern UIColor *overlayColorG;
