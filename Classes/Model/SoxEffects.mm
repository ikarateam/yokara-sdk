//
//  SoxEffects.m
//  AudioTapProcessor
//
//  Created by Rain Nguyen on 9/14/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//


#import "SoxEffects.h"
#include "SuperpoweredSimple.h"
#include "RingBufferInt.h"
#import "Freeverb.h"
#import "Bass.h"
#import "Treble.h"
@interface SoxEffects ()
{
    RingBufferInt *inputBuffer ;
    RingBufferInt *outputBuffer ;
    int tempIn[minimumBufferSize * 2]; //= new int[minimumBufferSize * 2];
    int tempOut[minimumBufferSize * 2]; //= new int[minimumBufferSize * 2];
}



@end

@implementation SoxEffects



-(id) initWithSoxEffects:(int) echoPara Bass:(int) bassPara Treble:(int) treblePara { // ECHO từ 0 -> BASS từ -100 đến 100 và TREBLE từ -100 đến 100
    self = [super init];
    
    if (self)
    {
        echoParam = echoPara;
        bassParam = bassPara;
        trebleParam = treblePara;
        freeverb=[Freeverb new];
        [freeverb start:echoParam];
        bass=[Bass new];
        [bass start:bassParam];
        treble=[Treble new];
        [treble start:trebleParam];
        // tempIn= new int[minimumBufferSize * 3 ];
        //tempOut= new int[minimumBufferSize * 3 ];
    }
    
    return self;
    
    
}

-(void) updateEcho:(int) echoPara {
    
    [freeverb updateEffect:echoPara];
    echoParam = echoPara;
    
}

-(void) updateBass:(int )bassPara {
    
    [bass updateEffect:bassPara];
    bassParam = bassPara;
    
}

-( void) updateTreble:(int) treblePara {
    
    [treble updateEffect:treblePara];;
    trebleParam = treblePara;
    
}


-(void) processFloat:(float*) input andOut: (float*) output andLength:(long) length {
    
    int intInput [length];
    int intOutput[length ];
    
    for (int i = 0; i < length; i++) {
        
        intInput[i] = (int) (input[i] * 2147483648.0f);
       
    }
    
    [self process: intInput andOut: intOutput andSample:length];
    for (int i = 0; i < length; i++) {
        
        output[i] = intOutput[i] / 2147483648.0f;
        
    }
    
}

- (void) process:(int[]) input  andOut:(int[]) output andSample:(long) length {
    
    if (inputBuffer == nil) {
        if (length <= (minimumBufferSize * 2)) {
            inputBuffer = new RingBufferInt(minimumBufferSize * 2 * 2);
            outputBuffer = new RingBufferInt(minimumBufferSize * 2 * 2);
        } else {
            inputBuffer = new RingBufferInt(length * 2);
            outputBuffer = new RingBufferInt(length * 2);
        }
    }
    for (int j = 0; j < length; j++)
    {
        inputBuffer ->push(input[j]);
    }
    int bufferLenght=inputBuffer->length();
    while(bufferLenght >= minimumBufferSize * 2) {
        
        for (long j = 0; j <  minimumBufferSize * 2; j++)
        {
            tempIn[j]= inputBuffer ->pop();
            
        }
        [self internalProcess:tempIn inputLength:minimumBufferSize * 2 andOut:tempOut];
        for (long j = 0; j < minimumBufferSize * 2; j++)
        {
            outputBuffer ->push(tempOut[j]);
            
        }
        
        bufferLenght=inputBuffer->length();
    }
    bufferLenght=outputBuffer->length();
    if (bufferLenght>= length) {
        for (int j = 0; j <  length; j++)
        {
            output[j]= outputBuffer ->pop();
            
        }
    } else {
        for (int i = 0 ; i < length; i++) {
            output[i] = 0;
        }
    }
    
}

- (void) internalProcess:(int[]) inpu inputLength:(long) inputLength andOut:(int[])outpu {
    //int * output=(int *)malloc(inputLength *sizeof(int));
    
    if (echoParam != 0)
        [freeverb process:inpu withLength:inputLength andOut:inpu withLength:inputLength];
    if (abs(bassParam) >= 5)
        [bass process:inpu withLength:inputLength andOut:inpu withLength:inputLength];
    if (abs(trebleParam) >= 5)
        [treble process:inpu withLength:inputLength andOut:inpu withLength:inputLength];
    
    for (int i = 0; i < inputLength; i++) {
        outpu[i] = inpu[i];
    }
    
    
}
-(void) processFloatLeftInput:(float*) leftInput andRightInput: (float*) rightInput andLeftOutput:(float*) leftOutput andRightOutput:(float*)rightOutput andLength:(long) length {
    
    int input [length * 2];
    int output[length * 2];
    for(int i = 0; i < length; i++) {
        input[2 * i] =  (int) (leftInput[i] * 2147483648.0f);
        input[2 * i + 1] = (int) (rightInput[i] * 2147483648.0f);
    }
    
    [self process: input andOut: output andSample:length*2];
    
    for(int i = 0; i < length; i++) {
        leftOutput[i] = output [2 * i]/ 2147483648.0f;
        rightOutput[i] = output [2 * i + 1]/ 2147483648.0f;
    }
    
}


-(void) dealloc{
    [freeverb stop];
    [bass stop];
    [treble stop];
}




@end
