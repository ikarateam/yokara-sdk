//
//  Bass.m
//  AudioTapProcessor
//
//  Created by Rain Nguyen on 9/14/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//


#import "Bass.h"
#include "bass-jni.h"

@implementation Bass
- (id) init{
    self=[super init];
    if (self) {
        Java_co_ikara_codec_Bass_nativeInit();
        
    }
    return self;
}
-( void )start: (int) bass { // -100 -> 100
    NSString *bassStr=[NSString stringWithFormat:@"%d", (bass/5)];
    handler = Java_co_ikara_codec_Bass_nativeStart([bassStr UTF8String]);
    handler2 = Java_co_ikara_codec_Bass_nativeStart([bassStr UTF8String]);
}

-( void ) stop {
    Java_co_ikara_codec_Bass_nativeStop(handler);
    Java_co_ikara_codec_Bass_nativeStop(handler2);
}

-(void) updateEffect:(int) bass {
    Java_co_ikara_codec_Bass_nativeUpdateEffect(handler,[[NSString stringWithFormat:@"%d", (bass/5)] UTF8String]);
    Java_co_ikara_codec_Bass_nativeUpdateEffect(handler2, [[NSString stringWithFormat:@"%d", (bass/5)] UTF8String]);
}

- (void) process:(int[]) input withLength:(long)inputLength andOut: (int[]) output withLength:(long) outLength { //CHá»ˆ Xá»¬ LÃ� Vá»šI INPUT 2 KÃŠNH TRÃ�I PHáº¢I XEN Káº¼ VÃ€ LENGTH LÃ€ SoxEffects.minimumBufferSize x 2, tá»©c lÃ  cÃ³ tá»•ng cá»™ng SoxEffects.minimumBufferSize lÃ¡t cáº¯t
    if (inputLength != minimumBufferSize * 2 || outLength != minimumBufferSize * 2){
        return;
        
    }
    
    for (int i= 0; i < minimumBufferSize; i++) {
        inputLeft[i] = input[ 2 * i];
        inputRight[i] = input[2 * i + 1] ;
    }
    
    Java_co_ikara_codec_Bass_nativeProcess(handler, inputLeft, outputLeft,minimumBufferSize);
    Java_co_ikara_codec_Bass_nativeProcess(handler2, inputRight, outputRight,minimumBufferSize);
    
    for (int i= 0; i <minimumBufferSize; i++) {
        output[ 2 * i] = outputLeft[i];
        output[ 2 * i + 1] = outputRight[i];
    }
}

- (int) process:(float[]) left right:( float []) right leftOut:( float []) leftOut rightOut:( float[]) rightOut andLength:(long) length{
    
    
    for (int i= 0; i < length; i++) {
        inputLeft[i] = (int) (left[i] * 2147483648.0f);
    }
    for (int i= 0; i < length; i++) {
        inputRight[i] = (int) (left[i] * 2147483648.0f);
    }
    
    Java_co_ikara_codec_Bass_nativeProcess(handler, inputLeft, outputLeft,length);
    Java_co_ikara_codec_Bass_nativeProcess(handler2, inputRight, outputRight,length);
    
    
    for (int i= 0; i < length; i++) {
        leftOut[i] = outputLeft[i] / 2147483648.0f;
        rightOut[i] = outputRight[i] / 2147483648.0f;
    }
    
    return 0;
}

@end
