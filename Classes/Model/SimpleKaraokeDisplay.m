//
//  SimpleKaraokeDisplay.m
//  Yokara
//
//  Created by Rain Nguyen on 7/5/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import "SimpleKaraokeDisplay.h"
#import "RiceKaraokeShow.h"
#import "KaraokeDisplay.h"
#import "CSLinearLayoutView.h"
#import "Word.h"
#import <Constant.h>
#import "Line.h"
#import "Paint.h"
#import "RenderOptions.h"
//NSString *readyText;
@implementation SimpleKaraokeDisplay

- (id) initSimpleKaraokeDisplay:(KaraokeDisplay *) karaokeDispla andEngine:( SimpleKaraokeDisplayEngine *) engine andCon:( CSLinearLayoutView *)container andDis: (int )displayIndex{
    self = [super init];
    if (self){
        widthcon=container.bounds.size.width;
    self.type = RICEKARAOKESHOW_TYPE_KARAOKE;
    self.karaokeDisplay = karaokeDispla;
    
        NSString *texte=@"Hát";
        CGFloat height=[karaokeDispla getHeight:texte andSize:[karaokeDispla.paint.getPaint fontsize] ];
        
        self._display = [[UIView alloc] initWithFrame:CGRectMake(0, 0, container.bounds.size.width, height)];
        
        self._display.backgroundColor=[UIColor clearColor];
                self._element=[LineView new];
        //[self._element setBackgroundColor:[UIColor whiteColor]];
        self._element.backgroundColor=[UIColor clearColor];
        self._element.frame = CGRectMake(0, 0, container.bounds.size.width, height);
        [self._element setTextColor:[UIColor whiteColor]];
        //self._overlay = [UILabel new];
        [self._element setFontSize:[karaokeDispla.paint.getPaint fontsize]];
        //self._element.numberOfLines=1;
       // self._element.autoresizesSubviews;
        self._overlay.font = [UIFont fontWithName:@"Arial" size:[karaokeDispla.paint.getPaint fontsize]];
        self._overlay.numberOfLines=1;
        self._overlay.backgroundColor=[UIColor clearColor];
        self._overlay.frame  = CGRectMake(0, 0,  container.bounds.size.width, height);
        self._overlay.lineBreakMode= UILineBreakModeClip;
        
        [self _setClass];
       
        [self._display addSubview:self._element];
       // [self._display addSubview:self._overlay];
        CSLinearLayoutItem *item = [CSLinearLayoutItem layoutItemForView:self._display];
       // item.padding = CSLinearLayoutMakePadding(10.0, 10.0, 0.0, 10.0);
        item.horizontalAlignment = CSLinearLayoutItemHorizontalAlignmentCenter;
        [container addItem:item];
        [self clear];
    }
    return self;
}

-(void) _setClass{
   /* if (self.type == RICEKARAOKESHOW_TYPE_UPCOMING) {
        self._element.textColor=[UIColor whiteColor];// Color.parseColor(TYPE_UPCOMING));
    } else if (self.type == RICEKARAOKESHOW_TYPE_READY) {
        self._element.textColor=[UIColor blueColor];
        //self._element.textColor=[UIColor colorWithCGColor:TYPE_READY];
        // _element.setTextColor(Color.parseColor(TYPE_READY));
    } else if (self.type == RICEKARAOKESHOW_TYPE_INSTRUMENTAL) {
        self._element.textColor=[UIColor blueColor];
        //_element.setTextColor(Color.parseColor(TYPE_INSTRUMENTAL));
    } else {
         self._element.textColor=[UIColor whiteColor];
        //_element.setTextColor(Color.parseColor(TYPE_KARAOKE));
    }
    self._element.shadowColor= [UIColor blackColor];// setShadowLayer(2, 1, 1, Color.BLACK);*/
}
-(void) _removeOverlay{
   // self._overlay.frame = CGRectMake(0,0,0,self._overlay.frame.size.height);
   // NSLog(@"Remove Overlay");
    [self._element setDistance:0];
}
-(void) clear{
    self._element.text=@"";
    CGRect newframe= self._element.frame;
    newframe.size.width=0;
    self._element.frame = newframe;
    [self _removeOverlay];
}
UIColor *maleLyricColorG  ;
 UIColor *femaleLyricColorG ;
 UIColor *duetLyricColorG;
UIColor *overlayColorG;
-(void) renderText:(NSString *)text andSex: (NSString *) sex{
    if (sex == nil)
        self._element.textColor=[UIColor darkGrayColor];//songCaColor;
        //self._element.setTextColor(Color.parseColor(KaraokeDisplay.duetLyricColorG));
    else if ([sex isEqualToString:@"male"]||[sex isEqualToString:@"m"])
        
        self._element.textColor=UIColorFromRGB(0xF8A629);//namColor;//[UIColor blueColor];
        //self._element.setTextColor(Color.parseColor(KaraokeDisplay.maleLyricColorG));
    else if ([sex isEqualToString:@"female"]||[sex isEqualToString:@"f"])
        self._element.textColor=UIColorFromRGB(0x06FFF0);//nuColor;//[UIColor colorWithRed:227/255.0 green:112/255.0 blue:237/255.0 alpha:1];
        //self._element.setTextColor(Color.parseColor(KaraokeDisplay.femaleLyricColorG));
    else
        self._element.textColor=UIColorFromRGB(0x7E38F1);//songCaColor;//[UIColor greenColor];
       // self._element.setTextColor(Color.parseColor(KaraokeDisplay.duetLyricColorG));
    //self._element.setShadowLayer(2, 1, 1, Color.BLACK);
    //self._element.setText(text);
    //self._removeOverlay();
    /////self._element.shadowColor= [UIColor blackColor];
    [self._element setText:text];
    CGFloat wi=[[KaraokeDisplay alloc] getWidth:text andSize:self.karaokeDisplay.paint.fontsize];
    CGFloat hi=[[KaraokeDisplay alloc] getHeight:text andSize:self.karaokeDisplay.paint.fontsize];
    self._element.frame = CGRectMake(0,0,wi,hi + 3);
    self._display.frame = CGRectMake(self._display.frame.origin.x,self._display.frame.origin.y, wi, hi + 3) ;
   [self _removeOverlay];
}
-(void) renderReadyCountdown:(int )countdown{
    NSString *content = [NSString stringWithFormat:@"(%@... %d)",readyText,countdown];
    if (countdown==0) {
        content = @"";
    }
    [self _setClass];
    self._element.text =content ;
    //self._element.textColor = [UIColor whiteColor];
    CGFloat wi=[[KaraokeDisplay alloc] getWidth:content andSize:self.karaokeDisplay.paint.fontsize];
    CGFloat hi=[[KaraokeDisplay alloc] getHeight:content andSize:self.karaokeDisplay.paint.fontsize];
    self._element.frame = CGRectMake(0,20,wi,hi + 3);
    self._display.frame = CGRectMake(self._display.frame.origin.x,self._display.frame.origin.y, wi, hi + 23) ;
    [self._element setDistance:lroundf(wi)];
    //[self _removeOverlay];
    
}
-(void) renderInstrumental{
    NSString *content = instrumentalText;
    [self _setClass];
    self._element.text= content;
    CGFloat wi=[[KaraokeDisplay alloc] getWidth:content andSize:self.karaokeDisplay.paint.fontsize];
    CGFloat hi=[[KaraokeDisplay alloc] getHeight:content andSize:self.karaokeDisplay.paint.fontsize];
    self._element.frame = CGRectMake(0,0,wi,hi + 3);
    self._display.frame = CGRectMake(self._display.frame.origin.x,self._display.frame.origin.y, wi, hi + 3) ;
    [self._element setDistance:lroundf(wi)];
    //[self _removeOverlay];
}
-(void) initRenderKaraoke:(NSMutableArray<Word> *)passed andCur:(Word *) current andUp: (NSMutableArray<Word> *) upcoming andFrag: (CGFloat) fragmentPercent andPass:
(NSString *) passedText andPassTextWid:(CGFloat) passedTextWidth andCurTeW:(CGFloat) currentTextWidth andTotal: (CGFloat )totalTextWidth{
    NSString *upcomingText = @"";
    for (int i = 0; i < upcoming.count; i++) {
        Word *wo= [upcoming objectAtIndex:i];
        upcomingText = [NSString stringWithFormat:@"%@%@",upcomingText,wo.text];
        //upcomingText += upcoming.get(i).text;
    }
    if (current == nil) {return;}
    NSString* content =[NSString stringWithFormat:@"%@%@%@", passedText , current.text , upcomingText];
    [self _setClass];
    self._element.text=content;
    ////////
    CGFloat wi=[[KaraokeDisplay alloc] getWidth:content andSize:self.karaokeDisplay.paint.fontsize];
    CGFloat hi=[[KaraokeDisplay alloc] getHeight:content andSize:self.karaokeDisplay.paint.fontsize];
    //CGRect newframe=self._element.frame;
    //newframe.size.width=wi;
    //newframe.size.height=hi+3;
    //newframe.origin.x= widthcon/2-wi/2;
    ///newframe.origin.x=150-wi/2;
    
    self._element.frame = CGRectMake(0,0,wi,hi + 3);
    self._overlay.frame = CGRectMake(0,0,wi,hi + 3);
    self._display.frame = CGRectMake(self._display.frame.origin.x,self._display.frame.origin.y, wi, hi + 3) ;
    //[self _removeOverlay];
    [self _removeOverlay];
    if (passed.count > 0 && [[passed objectAtIndex:0] renderOptions].sex != nil){
        if ([current.renderOptions.sex isEqualToString:@"male"])
            self._element.textColor=maleLyricColorG;//[UIColor blueColor];
            //self._element.setTextColor(Color.parseColor(KaraokeDisplay.maleLyricColorG));
        if ([current.renderOptions.sex isEqualToString:@"female"])
            // self._element.textColor=[UIColor redColor];
            self._element.textColor=femaleLyricColorG;//[UIColor colorWithRed:227/255.0 green:112/255.0 blue:237/255.0 alpha:1];
           // self._element.setTextColor(Color.parseColor(KaraokeDisplay.femaleLyricColorG));
        if ([current.renderOptions.sex isEqualToString:@"both"])
            self._element.textColor=duetLyricColorG;//[UIColor greenColor];
           // self._element.setTextColor(Color.parseColor(KaraokeDisplay.duetLyricColorG));
    } else {
        if (current != nil && current.renderOptions != nil && current.renderOptions.sex != nil){
            if ([current.renderOptions.sex isEqualToString:@"male"]||[current.renderOptions.sex isEqualToString:@"m"])
                self._element.textColor=UIColorFromRGB(0xF8A629);//[UIColor blueColor];
                //self._element.setTextColor(Color.parseColor(KaraokeDisplay.maleLyricColorG));
            if ([current.renderOptions.sex isEqualToString:@"female"]||[current.renderOptions.sex isEqualToString:@"f"])
              // self._element.textColor=[UIColor redColor];
                self._element.textColor=UIColorFromRGB(0x06FFF0);//[UIColor colorWithRed:227/255.0 green:112/255.0 blue:237/255.0 alpha:1];
                // self._element.setTextColor(Color.parseColor(KaraokeDisplay.femaleLyricColorG));
            if ([current.renderOptions.sex isEqualToString:@"both"])
                self._element.textColor=UIColorFromRGB(0x7E38F1);//[UIColor greenColor];
                //self._element.setTextColor(Color.parseColor(KaraokeDisplay.duetLyricColorG));
        }else {
            self._element.textColor=UIColorFromRGB(0x7E38F1);//[UIColor greenColor];
           // self._element.setTextColor(Color.parseColor(KaraokeDisplay.duetLyricColorG));
        }
    }
    self._overlay.textColor=overlayColorG;
    self._overlay.shadowColor= [UIColor blackColor];
    self._overlay.text=content;
    //self._overlay.frame = CGRectMake(0,0,wi,hi + 3);
    //self._overlay.frame = CGRectMake(0,0,0,self._overlay.frame.size.height);
    //[self _removeOverlay];
    ///CGFloat wi1=[[KaraokeDisplay alloc] getWidth:content andSize:24];
    ///CGRect newframe1=self._element.frame;
   /// newframe.size.width=wi1;
   ///self._overlay.frame = newframe;
  /// self._display.frame=newframe;
    /*_overlay.setTextColor(Color.parseColor(KaraokeDisplay.TYPE_KARAOKE));
    _overlay.setShadowLayer(2, 1, 1, Color.BLACK);
    _overlay.setText(content);*/
    float overlayWidth = passedTextWidth + (fragmentPercent / 100 * currentTextWidth);
    if ( overlayWidth> totalTextWidth) {overlayWidth = totalTextWidth;}
}
-(void) renderKaraoke:(NSMutableArray<Word> *) passed andCur: (Word *) current andUp: (NSMutableArray<Word> *) upcoming andFrag: (CGFloat) fragmentPercent andPassText:
(NSString *) passedText andPassTextWid: (CGFloat) passedTextWidth andCurTextWid: (CGFloat) currentTextWidth andTotal: ( CGFloat) totalTextWidth{
    if (current == nil) {return;}
    float overlayWidth = passedTextWidth + (fragmentPercent / 100 * currentTextWidth);
    if ( overlayWidth > totalTextWidth + 20) {overlayWidth = totalTextWidth + 20;}
    [self._element setDistance:lroundf(overlayWidth)];
    //self._overlay.frame = CGRectMake(0,0,lroundf(overlayWidth),self._overlay.frame.size.height);
}
-(void) updateFontSize{
   
    [self._element setFontSize: self.karaokeDisplay.paint.fontsize];
    self._overlay.font=[UIFont fontWithName:@"Arial" size:self.karaokeDisplay.paint.fontsize];
     CGFloat hi=[self.karaokeDisplay getHeight:@"a" andSize:[self.karaokeDisplay.paint.getPaint fontsize] ];
    CGFloat wi=[self.karaokeDisplay getWidth:self._element.text andSize:[self.karaokeDisplay.paint.getPaint fontsize] ];
    // wi=self._element.bounds.size.width;
    //CGFloat hi=self._element.bounds.size.height;
    self._element.frame = CGRectMake(0,0,wi,hi + 3);
    self._display.frame = CGRectMake(self._display.frame.origin.x,self._display.frame.origin.y, wi, hi + 3) ;
    // self._element.setTextSize(TypedValue.COMPLEX_UNIT_PX,karaokeDisplay.paint.getTextcount);
   // _overlay.setTextSize(TypedValue.COMPLEX_UNIT_PX,karaokeDisplay.paint.getTextcount);
}

@end
