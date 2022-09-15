//
//  LineView.h
//  DrawLyric
//
//  Created by MACBOOK on 1/19/22.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface LineView : UIView{
    CGFloat distan;
    float sizeText;
    
}

@property(strong,nonatomic) UIFont* font;
@property(assign,atomic)BOOL isDrawWhiteText;
@property(strong,nonatomic) NSString *text;
@property(strong,nonatomic) UIColor *textColor;
- (void) setFontSize:(CGFloat) fontS ;
- (void) setDistance:(CGFloat)distance;
-(void)passParam:(CGFloat) distance lyrics:(NSString *) lyric width:(float) width height:(float) height sizefont:(float) size ;
- (void) setText:(NSString * )text;
- (void) setFont:(UIFont *) fontS;
//- (void) setTextColor:(UIColor *)textColor;
@end

NS_ASSUME_NONNULL_END
