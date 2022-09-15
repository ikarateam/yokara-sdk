//
//  LineView.m
//  DrawLyric
//
//  Created by MACBOOK on 1/19/22.
//

#import "LineView.h"
#import <CoreText/CoreText.h>
@implementation LineView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@synthesize text,isDrawWhiteText;
//int count = 0;

- (void)drawRect:(CGRect) rect {
     self.font = [UIFont fontWithName:@"Arial" size:sizeText];
    if (self.font==nil) {
        self.font = [UIFont fontWithName:@"Avenir" size:30];
    }
    if (self.textColor==nil) {
        self.textColor = [UIColor darkGrayColor];
    }
   // if(!isDrawWhiteText) {
        //Chữ nền
        //[text drawAtPoint:CGPointMake(0 , 0) withAttributes:@{NSFontAttributeName:self.font, NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [text drawWithRect:CGRectMake(0 , sizeText, rect.size.width, 0)options:
         NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics
                attributes:@{NSFontAttributeName:self.font,
                             NSForegroundColorAttributeName:self.textColor}
                   context:nil];
   // }
    //Chữ đè
    if (distan>0)
    [text drawWithRect:CGRectMake(0 , sizeText, distan, 0)options:
     NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics
            attributes:@{NSFontAttributeName:self.font,
                         NSForegroundColorAttributeName:[UIColor whiteColor]}
               context:nil];
}

-(void)passParam:(CGFloat) distance lyrics:(NSString *) lyric width:(float) width height:(float) height sizefont:(float) size {
    text = lyric;
    distan = distance;
    sizeText = size;
}
- (void) setText:(NSString * )textS{
    text = textS;
    distan = 0;
    [self setNeedsDisplay];
}
- (void) setDistance:(CGFloat)distance{
    distan = distance;
    [self setNeedsDisplay];
}

- (void) setFontSize:(CGFloat) fontS {
    sizeText = fontS;
    // [self setNeedsDisplay];
}
/*
- (void) setTextColor:(UIColor *)textColor{
    self.textColor = textColor;
    [self setNeedsDisplay];
}*/
@end
