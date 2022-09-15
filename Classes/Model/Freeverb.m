//
//  Freeverb.m
//  AudioTapProcessor
//
//  Created by Rain Nguyen on 9/14/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//


#import "Freeverb.h"
#include "reverb-jni.h"
#import "SoxEffects.h"
@implementation Freeverb
- (id) init{
    self=[super init];
    if (self) {
        Java_co_ikara_codec_Freeverb_nativeInit();
        
    }
    return self;
}
-( void )start: (int) bass { // -100 -> 100
    NSString *bassStr=[NSString stringWithFormat:@"%d", (bass)];
    handler = Java_co_ikara_codec_Freeverb_nativeStart([bassStr UTF8String]);
}

-( void ) stop {
    Java_co_ikara_codec_Freeverb_nativeStop(handler);
}

-(void) updateEffect:(int) bass {
    Java_co_ikara_codec_Freeverb_nativeUpdateEffect(handler,[[NSString stringWithFormat:@"%d", (bass)] UTF8String]);
}

- (void) process:(int[]) input withLength:(long)inputLength andOut: (int[]) output withLength:(long)outLength  { //CHá»ˆ Xá»¬ LÃ� Vá»šI INPUT 2 KÃŠNH TRÃ�I PHáº¢I XEN Káº¼ VÃ€ LENGTH LÃ€ SoxEffects.minimumBufferSize x 2, tá»©c lÃ  cÃ³ tá»•ng cá»™ng SoxEffects.minimumBufferSize lÃ¡t cáº¯t
    if (inputLength != minimumBufferSize * 2 || outLength != minimumBufferSize * 2){
        return;
        
    }
    
    int input1[minimumBufferSize  ];
    int input2[minimumBufferSize  ];
    for (int i= 0; i < minimumBufferSize; i++) {
        input1[i] = input[i];
        input2[i] = input[minimumBufferSize + i] ;
    }
    int output1 [minimumBufferSize  ];
    int output2[minimumBufferSize  ];
    
    Java_co_ikara_codec_Freeverb_nativeProcess(handler, input1, output1,minimumBufferSize);
    Java_co_ikara_codec_Freeverb_nativeProcess(handler, input2, output2,minimumBufferSize);
    
    for (int i= 0; i <minimumBufferSize; i++) {
        output[i] = output1[i];
        output[minimumBufferSize + i] = output2[i];
    }
    
    
}

- (int) process:(float[]) left right:( float []) right leftOut:( float []) leftOut rightOut:( float[]) rightOut andLength:(long) length{
    int* input1 =( int *)malloc(length );
    int* input2 = ( int *)malloc(length );
    
    for (int i= 0; i < length/2; i++) {
        input1[ 2 * i] = (int)(left[i] * 2147483648.0f);
        input1[ 2 * i + 1] = (int)(right[i] * 2147483648.0f);
    }
    
    for (int i= 0; i < length/2; i++) {
        input2[ 2 * i] = (int)(left[i +length/2] * 2147483648.0f);
        input2[ 2 * i + 1] = (int)(right[i +length/2] * 2147483648.0f);
    }
    
    int* output1 = ( int *)malloc(length  );
    int* output2 =( int *)malloc(length );
    
    Java_co_ikara_codec_Freeverb_nativeProcess(handler, input1, output1,length);
    Java_co_ikara_codec_Freeverb_nativeProcess(handler, input2, output2,length);
    
    for (int i= 0; i < length/2; i++) {
        leftOut[i] = output1[2 * i] / 2147483648.0f;
        rightOut[i] = output1[2 * i + 1] / 2147483648.0f;
        
    }
    
    for (int i= 0; i < length/2; i++) {
        leftOut[length/2 + i] = output2[2 * i] / 2147483648.0f;
        rightOut[length/2 + i] = output2[2 * i + 1] / 2147483648.0f;
    }
    
    return 0;
}

@end
