//
//  RiceKaraokeShow.m
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "RiceKaraokeShow.h"
#import "SimpleKaraokeDisplay.h"
#import "RiceKaraokeLine.h"
#import "SimpleKaraokeDisplayEngine.h"
#import "RiceKaraokeReadyLine.h"
#import "RiceKaraokeInstrumentalLine.h"
#import "RiceKaraokeKaraokeLine.h"
#import "RiceKaraokeUpcomingLine.h"
#import "RiceKaraoke.h"
#import "Line.h"
@protocol BOOL;
@implementation RiceKaraokeShow
-(id) initRiceKaraokeShow:(RiceKaraoke *) engine andEn:
(SimpleKaraokeDisplayEngine *) displayEngine andLine:(int) numLines{
    self = [super init];
    self._displays = [NSMutableArray new];
    if (self){
        
        self.showReady = YES;
        self.showInstrumental = YES;
        self.upcomingThreshold = 5;
    self.readyThreshold = 2;
    self.antiFlickerThreshold = 0.5f;
    self._engine = engine;
    self._displayEngine = displayEngine;
    self._numLines = numLines;
        [self._displays removeAllObjects];
  //  _displays.clear();
    self._index = 0;
    self._relativeLastKaraokeLine = 0;
    self._hasReadyLine = NO;
    self._hasInstrumentalLine = NO;
    [self reset];
    }
    return self;
}
- (void) reset{
    [self._displays removeAllObjects];
    for (int i = 0; i < self._numLines; i++) {
        //this._displays.add(null);
        //this._displayEngine.getDisplay(i).clear();
        NSNull *a=[NSNull new];
        [self._displays addObject:a ];
        [self._displayEngine getDisplay:i];
    }
    self._index = 0;
    self._relativeLastKaraokeLine = 0;
    self._hasReadyLine = NO;
    self._hasInstrumentalLine = NO;
}/*
- (void) render:(float )position {
    @try {
        if (lyrics == nil) return;
        if (currentLine == nil) {
            currentLine = [self findCurrentLine:position];
            if (currentLine == -1) return;
        }
        if (currentLine == -1) return;
        
        if ((currentLine == 0 || [[(Line *)lyrics[currentLine - 1] end] floatValue] <= position || [[(Line *)lyrics[currentLine ] start] floatValue] <= position) && position <= [[(Line *)lyrics[currentLine ] end] floatValue]) {
            if ((([[(Line *)lyrics[currentLine ] start] floatValue] - position < 4) &&
                 (([[(Line *)lyrics[currentLine ] start] floatValue] - position > 1) ||
                  ([[(Line *)lyrics[currentLine ] start] floatValue] - position > 0 && currentLine > 0 )))) {
                
                if (showDot == 0) {
                    showDot = [[(Line *)lyrics[currentLine ] start] floatValue] - position;
                }
                if (showDot > 3) {
                    [self.paint setFontsize:]
                    paint.setTextSize(fontSize);
                    float width = measureText(paint, "● ● ● ●");
                    dotView.setVisibility(View.VISIBLE);
                    float fragmentPercent = 100 - ((lyrics.get(currentLine).start - position) / showDot) * 100;
                    float overlayWidth = ((fragmentPercent / 100) * width) * 2;
                    dotView.increaseCount(overlayWidth / 2);
                    if ((lyrics.get(currentLine).start - position) <= 1.05) {
                        dotView.increaseCount(width);
                        dotView.setVisibility(View.INVISIBLE);
                        showDot = 0;
                    }
                }
                if (smoothScrollLinearLayoutManager.findFirstVisibleItemPosition() != currentLine) {
                    lyricAdapter.setCurrentPosition(currentLine);
                    smoothScrollLinearLayoutManager.scrollToPosition(currentLine);
                }
            }
            if ((currentWord == 0 || lyrics.get(currentLine).line.get(currentWord - 1).end <= position || lyrics.get(currentLine).line.get(currentWord).start <= position) && position <= lyrics.get(currentLine).line.get(currentWord).end) {
                
            } else {
                if (lyrics.get(currentLine).line.get(currentWord).end <= position && position <= lyrics.get(currentLine).line.get(currentWord + 1).end) {
                    passedText += lyrics.get(currentLine).line.get(currentWord).text;
                    passedTextWidth += lyrics.get(currentLine).line.get(currentWord).textWidth;
                    currentWord++;
                    if (dotView.getVisibility() == View.VISIBLE)
                        dotView.setVisibility(View.INVISIBLE);
                } else {
                    currentWord = findCurrentWord(position);
                }
            }
            if (smoothScrollLinearLayoutManager.findFirstVisibleItemPosition() != currentLine) {
                lyricAdapter.setCurrentPosition(currentLine);
                smoothScrollLinearLayoutManager.scrollToPosition(currentLine);
            }
            float fragmentPercent = 0;
            if (lyrics.get(currentLine).line.get(currentWord).start <= position && position <= lyrics.get(currentLine).line.get(currentWord).end) {
                fragmentPercent = (position - lyrics.get(currentLine).line.get(currentWord).start) / (lyrics.get(currentLine).line.get(currentWord).end - lyrics.get(currentLine).line.get(currentWord).start);
            }
            float currentTextWidth = lyrics.get(currentLine).line.get(currentWord).textWidth;
            float overlayWidth = passedTextWidth + (fragmentPercent * currentTextWidth);
            updateStatus(currentLine, overlayWidth / 2);
        } else {
            if (lyrics.get(currentLine).end <= position && (currentLine == lyrics.size() - 1 || position <= lyrics.get(currentLine + 1).end)) {
                if (currentLine + 1 < lyrics.size()) {
                    lyricAdapter.setCurrentPosition(currentLine + 1);
                    container.smoothScrollToPosition(currentLine + 1);
                }
                if (currentLine < (lyrics.size() - 1))
                    currentLine++;
                else
                    currentLine = -1;
                currentWord = 0;
                passedText = "";
                passedTextWidth = 0;
            } else {
                currentLine = findCurrentLine(position);
                if (currentLine == -1) return;
                currentWord = 0;
                passedText = "";
                passedTextWidth = 0;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}*/
-(void) render:(CGFloat) elapsed{
    NSMutableArray *freeDisplays =  [[NSMutableArray alloc] init];
    NSMutableArray *displaysToClear =[[NSMutableArray alloc] init];
    NSMutableArray * unfreedDisplays =  [[NSMutableArray alloc] init];
    NSMutableArray *displaysToUpdate =[[NSMutableArray alloc] init];
    
        for (int i = 0; i < self._numLines; i++) {
            [unfreedDisplays addObject:[NSNull alloc]];
        }
        int currentLine = 0;
        for (int i = 0; i < self._displays.count; i++) {
            RiceKaraokeLine *dis=[self._displays objectAtIndex:i];
            if (![dis isKindOfClass:[NSNull class]]
                && dis.end > elapsed) {
                currentLine = i;
                break;
            }
        }
        for (int k = 0; k < self._displays.count; k++) {
            int i = (currentLine + k) % self._displays.count;
            RiceKaraokeLine *dis=[self._displays objectAtIndex:i];
            if ( [dis isKindOfClass:[NSNull class]]) {
                [freeDisplays addObject:[NSNumber numberWithInt: i]];
            } else if (dis.end <= elapsed) {
                if ([dis isKindOfClass: [RiceKaraokeReadyLine class]]) {
                    self._hasReadyLine = NO;
                }
                if ([dis isKindOfClass:[RiceKaraokeInstrumentalLine class]]) {
                    self._hasInstrumentalLine = NO;
                }
                RiceKaraokeLine *replacement = [dis expire:elapsed];
                if (replacement != nil) {
                    [self._displays replaceObjectAtIndex:i withObject:replacement];
                    NSLog(@"Currentline %d %d %d %d",currentLine,freeDisplays.count,displaysToClear.count,displaysToUpdate.count);
                    if (currentLine>4 && currentLine<self._displays.count-5){
                        [self._displayEngine._container setContentOffset:CGPointMake(0,replacement._display._display.frame.origin.y- 3*replacement._display._display.frame.size.height) animated:YES ];
                    }
                } else {
                    [freeDisplays addObject:[NSNumber numberWithInt: i]];
                    [displaysToClear addObject:[NSNumber numberWithInt: i]];
                }
            } else {
                [displaysToUpdate addObject:[NSNumber numberWithInt: i]];
            }
        }
   
        if (freeDisplays.count > 0) {
            for (int i = self._index; i < self._engine.timings.count; i++) {
                if (freeDisplays.count == 0) {
                    break;
                }
                Line *timin = [self._engine.timings objectAtIndex:i];
                
                if ([timin.start floatValue] <= elapsed && [timin.end floatValue] >= elapsed) {
                    int freeDisplay =[[freeDisplays objectAtIndex:0] intValue];
                    [freeDisplays removeObjectAtIndex:0];
                    [unfreedDisplays replaceObjectAtIndex:freeDisplay withObject:[NSNumber numberWithBool: YES] ];
                    RiceKaraokeKaraokeLine * karaLine =[[RiceKaraokeKaraokeLine alloc] initRiceKaraokeKaraokeLine:[self getDisplay:freeDisplay] andElap:elapsed andTime:timin];
                    [self._displays replaceObjectAtIndex:freeDisplay withObject:karaLine];
                    
                    self._relativeLastKaraokeLine =[ timin.end floatValue];
                    self._index = i + 1;
                } else if (([timin.start floatValue] - self.upcomingThreshold <= elapsed || [timin.start floatValue]
                            - self._relativeLastKaraokeLine < self.antiFlickerThreshold)
                           && [timin.end floatValue] >= elapsed ) {
                    if (self.showReady
                        && elapsed - self._relativeLastKaraokeLine >= self.readyThreshold
                        && !self._hasReadyLine) {
                        int freeDisplay =[[freeDisplays objectAtIndex:0] intValue];
                        if (freeDisplays){
                            [freeDisplays removeObjectAtIndex:0];
                        }
                        [unfreedDisplays replaceObjectAtIndex:freeDisplay withObject:[NSNumber numberWithBool: YES] ];
                        [self._displays replaceObjectAtIndex:freeDisplay withObject:[[RiceKaraokeReadyLine alloc] initRiceKaraokeReadyLine:[self getDisplay:freeDisplay] andElap:elapsed andCount:[timin.start floatValue]-elapsed]];
                        
                        self._hasReadyLine = YES;
                    }
                    int freeDisplay;
                    if (freeDisplays.count>0){
                        int freeDisplay =[[freeDisplays objectAtIndex:0] intValue];
                        [freeDisplays removeObjectAtIndex:0];
                         [unfreedDisplays replaceObjectAtIndex:freeDisplay withObject:[NSNumber numberWithBool: YES] ];
                         [self._displays replaceObjectAtIndex:freeDisplay withObject:[[RiceKaraokeUpcomingLine alloc] initRiceKaraokeUpcomingLine:[self getDisplay:freeDisplay] andElap:elapsed andTime:timin]];
                    }
                   
                   
                    
                    self._index = i + 1;
                    self._relativeLastKaraokeLine = [timin.end floatValue];
                } else if (self.showInstrumental
                           && freeDisplays.count == self._displays.count
                           && !self._hasInstrumentalLine ) {
                    
                    int freeDisplay =[[freeDisplays objectAtIndex:0] intValue];
                    [freeDisplays removeObjectAtIndex:0];
                    [unfreedDisplays replaceObjectAtIndex:freeDisplay withObject:[NSNumber numberWithBool: YES] ];
                    [self._displays replaceObjectAtIndex:freeDisplay withObject:[[RiceKaraokeInstrumentalLine alloc] initRiceKaraokeInstrumentalLine:[self getDisplay:freeDisplay] andElap:elapsed andEnd:[timin.start floatValue] - self.upcomingThreshold]];
                    
                    self._hasInstrumentalLine = YES;
                } else if ([timin.end floatValue] > elapsed) {
                    break;
                }
            }
        }
        if (displaysToClear.count > 0) {
            for (int i = 0; i < displaysToClear.count; i++) {
                if ([[unfreedDisplays objectAtIndex:[[displaysToClear objectAtIndex:i] intValue]] isKindOfClass:[NSNull class]]) {
                    [self._displays replaceObjectAtIndex:[[displaysToClear objectAtIndex:i] intValue] withObject:[NSNull alloc]];
                    //[[self._displayEngine getDisplay:[[displaysToClear objectAtIndex:i] intValue]] clear];
                    
                }
            }
        }
        if (displaysToUpdate.count > 0) {
            for (int i = 0; i < displaysToUpdate.count; i++) {
                [[self._displays objectAtIndex:[[displaysToUpdate objectAtIndex:i] intValue]] update:elapsed];
            }
        }
   // } catch (NSException ex) {
      //  Utils.handleException(ex);
    //}
}
-(SimpleKaraokeDisplay *) getDisplay:(int) displayIndex{
    return [self._displayEngine getDisplay:displayIndex];
}

@end
