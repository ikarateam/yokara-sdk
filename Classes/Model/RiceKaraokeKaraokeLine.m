//
//  RiceKaraokeKaraokeLine.m
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "RiceKaraokeKaraokeLine.h"
#import "RiceKaraokeLine.h"
#import "SimpleKaraokeDisplay.h"
#import "Line.h"
#import "Word.h"
#import "RiceKaraokeShow.h"
#import "UtilsK.h"
#import "Paint.h"
@implementation RiceKaraokeKaraokeLine


-(id) initRiceKaraokeKaraokeLine:(SimpleKaraokeDisplay *) display andElap: (CGFloat) elapsed andTime:( Line *) timin{
    self = [super init];
    if (self){
    self._display = display;
    self._timing = timin;
    self._elapsed = elapsed;
    self.end = [timin.end floatValue];
    self._display.type = RICEKARAOKESHOW_TYPE_KARAOKE;
    
    self.passedFragments = [NSMutableArray new];
    self.currentFragment = nil;
    self.currentFragmentIndex = 0;
    self.upcomingFragments =  [NSMutableArray new];
    self.passedText = @"";
    NSString *upcomingText =@"";
    for (int l = 0; l < self._timing.line.count; l++) {
        Word *fragment = [self._timing.line objectAtIndex:l];
        if ([self._timing.start floatValue] + [fragment.start floatValue] <= elapsed) {
            if (self.currentFragment != nil) {
                [self.passedFragments addObject:self.currentFragment ];
                self.passedText =[NSString stringWithFormat:@"%@%@",
                self.passedText, self.currentFragment.text];
            }
            self.currentFragment = fragment;
            self.currentFragmentIndex = l;
        } else {
            [self.upcomingFragments addObject:fragment];
            upcomingText = [NSString stringWithFormat:@"%@%@",upcomingText, fragment.text];
            
        }
    }
        CGFloat fragmentEnd ;
        Line * lin= [self._timing.line objectAtIndex:self._timing.line.count-1];
        if (lin.end != nil){
            Line* lin2=[self._timing.line objectAtIndex:self._timing.line.count -1];
            fragmentEnd =  [lin2.end floatValue];
        }else if (self._timing.line.count > self.currentFragmentIndex + 1 ){
            Line* lin3=[self._timing.line objectAtIndex: self.currentFragmentIndex + 1];
            fragmentEnd =  [lin3.start floatValue];
        }
        else fragmentEnd = [self._timing.end floatValue] - [self._timing.start floatValue];
    
    CGFloat currentFragmentPercent = (elapsed - ([self._timing.start floatValue]+ [self.currentFragment.start floatValue])) / (fragmentEnd - [self.currentFragment.start floatValue]) * 100;
    NSString *passedTex = self.passedText;
    NSString *strippedCurrentText = self.currentFragment.text;
        Paint* pait=[[Paint alloc] initWithFont:self._display._element.font.fontName andSize:self._display._element.font.pointSize ];
       
        self.passedTextWidth = [UtilsK measureText:pait andText:passedTex ];
        self.currentTextWidth = [UtilsK measureText:pait andText:strippedCurrentText];
    NSString *content =[NSString stringWithFormat:@"%@%@%@", self.passedText,self.currentFragment.text ,upcomingText];
    self.totalTextWidth = [UtilsK measureText:pait andText:content];
        [self._display initRenderKaraoke:self.passedFragments andCur:self.currentFragment andUp:self.upcomingFragments andFrag:currentFragmentPercent andPass:self.passedText andPassTextWid:self.passedTextWidth andCurTeW:self.currentTextWidth andTotal:self.totalTextWidth];
    }
    return self;
}
-(BOOL)  update:(CGFloat) elapsed{
    float currentFragmentPercent = 0.0f;
    int tempCurrentFragmentIndex = self.currentFragmentIndex;
    for (int l = self.currentFragmentIndex; l < self._timing.line.count; l++) {
        Word *fragment = [self._timing.line objectAtIndex:l];
        if (([self._timing.start floatValue]+ [fragment.start floatValue])<= elapsed) {
            if (l > tempCurrentFragmentIndex) {
                [self.passedFragments addObject: self.currentFragment];
                self.passedText= [NSString stringWithFormat:@"%@%@",self.passedText,self.currentFragment.text];
                if (self.upcomingFragments){
                [self.upcomingFragments removeObjectAtIndex:0];
                }
            }
            self.currentFragment = fragment;
            self.currentFragmentIndex = l;
        } else {
            break;
        }
    }
    
    if (tempCurrentFragmentIndex != self.currentFragmentIndex){
        NSString *passedTex = self.passedText;
        NSString * strippedCurrentTex =  self.currentFragment.text;
        Paint* pait=[[Paint alloc] initWithFont:self._display._element.font.fontName andSize:self._display._element.font.pointSize ];
        
        self.passedTextWidth = [UtilsK measureText:pait andText:passedTex ];
        
        self.currentTextWidth = [UtilsK measureText:pait andText:strippedCurrentTex];
    }
    CGFloat fragmentEnd = 0;
    if (self._timing.line.count == self.currentFragmentIndex + 1){
        Line* lin=[self._timing.line objectAtIndex:self._timing.line.count-1];
        fragmentEnd = [lin.end floatValue];
    } else {
        Line* lin=[self._timing.line objectAtIndex:self.currentFragmentIndex + 1];
        if (self._timing.line.count > self.currentFragmentIndex + 1)
            fragmentEnd = [lin.start floatValue];
        else fragmentEnd =[self._timing.end floatValue] - [self._timing.start floatValue];
        
    }
    
    currentFragmentPercent = (elapsed - ([self._timing.start floatValue] + [self.currentFragment.start floatValue])) / (fragmentEnd - [self.currentFragment.start floatValue]) * 100;
    [self._display renderKaraoke:self.passedFragments andCur:self.currentFragment andUp:self.upcomingFragments andFrag:currentFragmentPercent andPassText:self.passedText andPassTextWid:self.passedTextWidth andCurTextWid:self.currentTextWidth andTotal:self.totalTextWidth];
    
    return YES;
}
- (RiceKaraokeLine *) expire:(CGFloat) elapsed{
    return nil;
}

@end
