//
//  DuetLyricView.h
//  Yokara
//
//  Created by APPLE on 9/8/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Lyric.h"
#import "LyricLine.h"

@protocol ColorAndTime;

@interface DuetLyricView : UIView{
     LyricLine * lyricContent;
    NSMutableArray * listElement;
    Lyric *lyric;
     NSString *lyricJson;
    NSString *gender;
    NSString *genderOther;
    UIColor *genderColor;
    UIColor *genderOtherColor;
    UIColor *DuetColor;
    double duration;
}
@property(nonatomic,strong) UIColor *genderColor;
@property(nonatomic,strong) NSMutableArray<ColorAndTime> *listColor;
- (Lyric *)getLyric;
- (void)resetLyric;
- (void)removeLine:(NSInteger)i;
- (id) initWithLyric:(Lyric *) lyri andDuration:(double) duratio;
- (void)updateLyricMeSing:(double )time;
- (void)updateLyricOtherSing:(double )time;
- (void)updateLyricDuetSing:(double )time;
- (void)updateColor:(UIColor *)genderC andOther:(UIColor *)other;

@end
