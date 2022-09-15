//
//  AACEncoderNative.h
//  Likara
//
//  Created by Rain Nguyen on 6/16/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "aacenc_lib.h"

typedef struct AudioOutput {
	int transMux;  //TODO ??
	int afterburner;  //TODO ??
	int channelLoader; //TODO ？？
	int aot ; //aot类型。
	int channels;
	int samplerate;
	int bitrate;
	CHANNEL_MODE mode; //通道模式。
	HANDLE_AACENCODER handle; //aac处理实例
	AACENC_InfoStruct info;
	int input_size;
	int first;
}AACOutput;

@interface AACEncoderNative : NSObject
- (int) close:(long) handle ;
- (int) encodeFrame:(long)handle inData:(unsigned char [])pcmData LenghtIn:(int) lenghtIn encodedData:(unsigned char []) encodedData;
- (int) getBufferSize:(long) handle;
- (long) initAAC:(int) bitrate sampleRate:(int )sample_rate channels:(int)channels;
@end

