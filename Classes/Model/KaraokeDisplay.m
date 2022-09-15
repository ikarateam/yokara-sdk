
#import "KaraokeDisplay.h"
#import "RiceKaraokeShow.h"
#import "SimpleKaraokeDisplayEngine.h"
#import "RiceKaraoke.h"
#import "Word.h"
#import "Paint.h"
#import "UtilsK.h"
#import "Line.h"
#import "CSLinearLayoutView.h"
#import <UIKit/UIKit.h>
#import <Constant.h>
#import "LocalizationSystem.h"
@implementation KaraokeDisplay

UIColor *namColor;
 UIColor *nuColor;
UIColor *songCaColor;
NSString *instrumentalText;
 NSString *readyText;
NSInteger numDisplayLineLyric;
-(id) initKaraokeDisplay:(UIView *) contex andLine: (CSLinearLayoutView *) karaokeDisplayElemen {
    self = [super init];
    if (self)
    {
		self.context = contex;
		NSString *tf = @"Arial";
        self.paint =[Paint new];
		[self.paint setTypeface:tf];
        if (numDisplayLineLyric>1) {
		numDisplayLines = numDisplayLineLyric;
        }else{
            numDisplayLines=3;
        }
		self.karaokeDisplayElement = karaokeDisplayElemen;
        instrumentalText= AMLocalizedString( @"Nhạc nền",nil);
        readyText= AMLocalizedString( @"Chuẩn bị",nil);
		// the number of line that lyrics display
		self.show = nil;
		self.renderer = nil;
		self.longestLine = @"";
		currentTime = -1;
		self.currentTiming = nil;
        maleLyricColorG=namColor;
        femaleLyricColorG=nuColor;
        duetLyricColorG=songCaColor;
        overlayColorG=[UIColor whiteColor];
    }
    return self;
}


-( void) setLanguage:(NSString *)readyL andIns: (NSString *) instrumentalL{
		readyText = readyL;
		instrumentalText = instrumentalL;
	}

- (void) _updateOrientation {
		if (self.longestLine != nil && self.longestLine.length > 0){
			int maxFontSize = [self getMaxFontSize];
			[self setFontSize:maxFontSize];
		}
	}

-(void) updateSettings:(int) numberOfLyrics andMale:(UIColor *) maleLyricColor andFemale: (UIColor *)femaleLyricColor andDuet: (UIColor *) duetLyricColor andOverlay:(UIColor *)overlayColor{
		numDisplayLines = numberOfLyrics;
		maleLyricColorG = maleLyricColor;
		femaleLyricColorG = femaleLyricColor;
		duetLyricColorG = duetLyricColor;
        overlayColorG=overlayColor;
	}

- (void) render:(float )time {
    
		currentTime = time;
		if (self.show != nil)
			[self.show render:currentTime + 0.0f];
     
}


-(void) setTiming:(NSMutableArray<Line> *) timing {
    
		//Element.getElementById("#karaoke-display").empty();
		currentTime = -1;
		self.karaoke = [[RiceKaraoke alloc] initRiceKaraoke:timing];
		int maxFontSize = [self getMaxFontSize];
		self.renderer = [[SimpleKaraokeDisplayEngine alloc] initSimpleKaraokeDisplayEngine:self andCon:self.karaokeDisplayElement andLine:self->numDisplayLines];
    [self setFontSize:maxFontSize];
    self.show = [self.karaoke createShow:self.renderer andLine:numDisplayLines];
     
}

- (void) reset{
    self.renderer=nil;
		currentTime = -1;
    self.renderer =  [[SimpleKaraokeDisplayEngine alloc] initSimpleKaraokeDisplayEngine:self andCon:self.karaokeDisplayElement andLine:numDisplayLines];
		if (self.karaoke != nil){
			self.show = [self.karaoke createShow:self.renderer andLine:numDisplayLines];
		}
}

-(void) setSimpleTiming:(NSMutableArray <Line> *) simpleTiming {
    
		self.currentTiming = simpleTiming;
		self.longestLine =@"";
		[self caculateLongestLine];
    NSMutableArray<Line> *timing = [[RiceKaraoke alloc ]simpleTimingToTiming:simpleTiming];
    [self setTiming:timing];
    
}

-(void) caculateLongestLine{
		NSString* currentLine = @"";
		if (self.currentTiming != nil){
			for(int i = 0; i < self.currentTiming.count; i++)
			{
				currentLine = @"";
                Line * curTiming= [self.currentTiming objectAtIndex:i];
				if (curTiming.line != nil){
					for( int j = 0 ; j < curTiming.line.count; j++){
                        Word* word=[curTiming.line objectAtIndex:j];
						currentLine=[NSString stringWithFormat:@"%@%@",currentLine, word.text];
					}
				}
				if ([self getWidth:currentLine andSize: 10] > [self getWidth:self.longestLine andSize: 10]){
					self.longestLine = currentLine;
				}
			}
		}
	}
	
- (CGFloat) getWidth:(NSString *) currentLine andSize: (CGFloat) textSize {
		
			//Rect bounds = new Rect();
			//paint.setTextSize(textSize);
			//paint.getTextBounds(currentLine, 0, currentLine.length(), bounds);
	        //return bounds.width();
   [self.paint setTextSize:textSize];
    //   return [[UtilsK alloc] measureText:self.paint andText:currentLine];
    //NSSize
   // NSSize size = [currentLine sizeWithAttributes:[NSDictionary dictionaryWithObject:[NSFont fontWithName:@"Helvetica Neue Bold" size:24.0f] forKey:NSFontAttributeName]];
 
   UIFont *myFont = [UIFont fontWithName:@"Arial" size:textSize];
    
    CGSize stringSize = [currentLine sizeWithFont:myFont];
    
    CGFloat width = stringSize.width;
    return width;/*
    CGSize maximumSize = CGSizeMake(300, 9999);
    NSString *myString = @"This is a long string which wraps";
    UIFont *myFont = [UIFont fontWithName:@"Helvetica" size:14];
    CGSize myStringSize = [myString sizeWithFont:myFont
                               constrainedToSize:maximumSize
                                   lineBreakMode:self.myLabel.lineBreakMode];*/
}

- (CGFloat) getHeight:(NSString *) currentLine andSize: (CGFloat) textSize {
    UIFont *myFont = [UIFont fontWithName:@"Arial" size:textSize];
    
    CGSize stringSize = [currentLine sizeWithFont:myFont];
    
    CGFloat height = stringSize.height;
    return height;
}
-(int) getMaxFontSize{
		if (self.longestLine.length == 0) return 100;
	//	int minFontSize = [[UtilsK alloc] getSize].width/self.longestLine.length;
    int minFontSize = self.karaokeDisplayElement.bounds.size.width/self.longestLine.length;
		for (int i = minFontSize; i < 500; i++) {
            if ([self getWidth:self.longestLine andSize: (float)i] > self.karaokeDisplayElement.bounds.size.width)
			//if ([self getWidth:self.longestLine andSize: (float)i] > [[UtilsK alloc] getSize].width)
				return i - 1;
		}
		return minFontSize;
}

-(void) setFontSize:(int )fontSize{
    [self.paint setTextSize:fontSize];
    
		if (self.renderer != nil)
			[self.renderer updateFontSize];
	
}

@end
