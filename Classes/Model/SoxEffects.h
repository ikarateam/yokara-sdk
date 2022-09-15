//
//  SoxEffects.h
//  AudioTapProcessor
//
//  Created by Rain Nguyen on 9/14/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#define  minimumBufferSize 1024

@class Treble;
@class Bass;
@class Freeverb;
@interface SoxEffects : NSObject{
    
    Freeverb* freeverb;
    Bass* bass ;
    Treble* treble ;
    
    int echoParam;
    int bassParam;
    int trebleParam;
    
    
    
}
-(id) initWithSoxEffects:(int) echoPara Bass:(int) bassPara Treble:(int) treblePara ;
-(void) updateEcho:(int) echoPara;
-(void) updateBass:(int )bassPara;
-( void) updateTreble:(int) treblePara ;
-(void) processFloat:(float*) input andOut: (float*) output andLength:(long) length;
- (void) process:(int[]) input  andOut:(int[]) output andSample:(long) length ;

-(void) processFloatLeftInput:(float*) leftInput andRightInput: (float*) rightInput andLeftOutput:(float*) leftOutput andRightOutput:(float*)rightOutput andLength:(long) length;

@end
