//
//  DuetLyricView.m
//  Yokara
//
//  Created by APPLE on 9/8/19.
//  Copyright © 2019  SmartApp All rights reserved.
//


#import "DuetLyricView.h"
#import "LyricOneLine.h"
#import <Constant.h>
#import "ColorAndTime.h"
#import "LyricOneWord.h"
@implementation DuetLyricView
@synthesize genderColor;
- (id) initWithLyric:(Lyric *) lyri andDuration:(double) duratio{
    self = [self init];
    if(self)
    {
        lyric=lyri;
        self.listColor=[NSMutableArray<ColorAndTime> new];
        duration=duratio;
        lyricContent=[[LyricLine alloc] initWithString:lyric.content error:nil];
        gender=[[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
        if (gender.length==0) {
            gender=@"m";
            genderColor=namColor;
            
        }else if ([gender isEqualToString:@"male"]){
            gender=@"m";
            genderColor=namColor;
        }else{
            gender=@"f";
            genderColor=nuColor;
            
        }
        genderOtherColor=[UIColor whiteColor];
        genderOther=@"f";
        if ([gender isEqualToString:@"f"]) {
            genderOther=@"m";
        }
        
        
    }
    return self;

}
- (void)updateColor:(UIColor *)genderC andOther:(UIColor *)other{
    genderColor=genderC;
    genderOtherColor=other;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGRect frame = self.bounds;
    self.listColor=[NSMutableArray<ColorAndTime> new];
    ColorAndTime *first=[ColorAndTime new];
    first.time=0.0;
    first.color=genderColor;
    first.gender=0;
    [self.listColor addObject:first];
    // Set the background color
    [genderColor set];
    UIRectFill(frame);
   [lyricContent.lines sortUsingComparator:^NSComparisonResult(LyricOneLine *a, LyricOneLine *b) {
         LyricOneWord * word1=[a.words objectAtIndex:0];
         LyricOneWord * word2=[b.words objectAtIndex:0];
        return [word1.startTime compare:word2.startTime];
    }];
    for (LyricOneLine *line in lyricContent.lines) {
       
        if (line.words.count>0) {
            LyricOneWord * word=[line.words objectAtIndex:0];
            double start=[word.startTime doubleValue]/duration*frame.size.width;
            ColorAndTime * ct=[ColorAndTime new];
            ct.time=[word.startTime doubleValue];
            if ([line.sex isEqualToString:gender]) {
                [genderColor set];
                ct.color=genderColor;
                ct.gender=0;
            }else  if ([line.sex isEqualToString:genderOther]) {
                [genderOtherColor set];
                ct.color=genderOtherColor;
                ct.gender=1;
            }else{
                [songCaColor set];
                ct.color=songCaColor;
                ct.gender=2;
            }
            if (ct.time>0.0) {
                 [self.listColor addObject:ct];
            }
           
            UIRectFill(CGRectMake(start, 0,frame.size.width- start, frame.size.height));
        }
       
      
    }
}
- (Lyric *)getLyric{
    lyric.content=[lyricContent toJSONString];
    return lyric;
}
- (void)resetLyric{
    CGRect frame = self.bounds;
    LyricOneLine*line=[[LyricOneLine alloc] init];
    LyricOneWord *word=[[LyricOneWord alloc] init];
    word.startTime=[NSNumber numberWithDouble: 0];
    
    
    word.text=@"";
    line.sex=gender;
    line.words=[[NSMutableArray<LyricOneWord> alloc] initWithObjects:word, nil];
    
    //   double start=[word.startTime doubleValue]/duration*frame.size.width;
    
    //     [genderColor set];
    
    //  UIRectFill(CGRectMake(start, 0,frame.size.width- start, frame.size.height));
    [lyricContent.lines removeAllObjects];
    [lyricContent.lines addObject:line];
}
- (void)removeLine:(NSInteger)i{
    
    [lyricContent.lines removeObjectAtIndex:i];
}
- (void)updateLyricMeSing:(double )time{
     CGRect frame = self.bounds;
    LyricOneLine*line=[[LyricOneLine alloc] init];
    LyricOneWord *word=[[LyricOneWord alloc] init];
    word.startTime=[NSNumber numberWithDouble: time];
    
    
    word.text=@"";
    line.sex=gender;
    line.words=[[NSMutableArray<LyricOneWord> alloc] initWithObjects:word, nil];
 
     //   double start=[word.startTime doubleValue]/duration*frame.size.width;
    
       //     [genderColor set];
        
      //  UIRectFill(CGRectMake(start, 0,frame.size.width- start, frame.size.height));
    
    [lyricContent.lines addObject:line];
}
- (void)updateLyricOtherSing:(double )time{
    CGRect frame = self.bounds;
    LyricOneLine*line=[[LyricOneLine alloc] init];
    LyricOneWord *word=[[LyricOneWord alloc] init];
    word.startTime=[NSNumber numberWithDouble: time];
    
    
    word.text=@"";
    line.sex=genderOther;
    line.words=[[NSMutableArray<LyricOneWord> alloc] initWithObjects:word, nil];
    
    //   double start=[word.startTime doubleValue]/duration*frame.size.width;
    
    //     [genderColor set];
    
    //  UIRectFill(CGRectMake(start, 0,frame.size.width- start, frame.size.height));
    
    [lyricContent.lines addObject:line];
}
- (void)updateLyricDuetSing:(double )time{
    CGRect frame = self.bounds;
    LyricOneLine*line=[[LyricOneLine alloc] init];
    LyricOneWord *word=[[LyricOneWord alloc] init];
    word.startTime=[NSNumber numberWithDouble: time];
    
    
    word.text=@"";
    line.sex=@"b";
    line.words=[[NSMutableArray<LyricOneWord> alloc] initWithObjects:word, nil];
    
    //   double start=[word.startTime doubleValue]/duration*frame.size.width;
    
    //     [genderColor set];
    
    //  UIRectFill(CGRectMake(start, 0,frame.size.width- start, frame.size.height));
    
    [lyricContent.lines addObject:line];
}

@end
