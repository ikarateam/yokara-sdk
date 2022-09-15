//
//  AACEncoder.m
//  Likara
//
//  Created by Rain Nguyen on 6/14/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import "AACEncoder.h"

#import "AACEncoderNative.h"
@interface AACEncoder (){


}
@property (strong,nonatomic) AACEncoderNative *Encoder;
@property (assign,nonatomic) long handler;
@property (assign,nonatomic) int bufferSize;
@end


@implementation AACEncoder
@synthesize handler,bufferSize;
- (BOOL) initAAC:(int) bitrate sampleRate:(int )sample_rate channels:(int)channels{
	 handler = [[AACEncoderNative alloc] initAAC:bitrate sampleRate:sample_rate channels:channels];
	 return handler != 0;
}
- (int) getBufferSize {
	if (handler == 0) {
		NSLog(@"handler = 0");
		return 0;
	}
	if (bufferSize == 0)
		 bufferSize = [[AACEncoderNative alloc] getBufferSize:handler];
	return bufferSize;
}

- (int) encodeFrame:(unsigned char [])inData outData:(unsigned char  [])outData Lenght:(long)size{
	 if (handler == 0) {
				 NSLog(@"handler = 0");
				 return 0;
			 }
			 if (size > bufferSize ) {
	 //            if (in.length % bufferSize != 0)
	 //                System.out.println("****** AacEncoder ERROR: in.length % bufferSize != 0 *************");
				  unsigned char tempIn[[self getBufferSize]];
				 unsigned char tempOut[[self getBufferSize]];
				 int totalEncodeByte = 0;
				 for (int i = 0; i < size / bufferSize; i++) {
					 for (int j = 0; j < size; j++) {
						 tempIn[j] = inData[i * size + j];
					 }
					  int outLength = [[AACEncoderNative alloc] encodeFrame:handler inData: tempIn LenghtIn:(int)size encodedData:tempOut];
					 for (int j = 0; j < outLength; j++) {
						 outData[totalEncodeByte + j] = tempOut[j];
					 }

					 totalEncodeByte += outLength;
				 }
				 return totalEncodeByte;
			 } else {
				 return [[AACEncoderNative alloc] encodeFrame:handler inData: inData LenghtIn:(int)size encodedData:outData];
			 }
}

- (int) close {
	 if (handler == 0) {
				NSLog(@"handler = 0");
				return 0;
			}
	 return [[AACEncoderNative alloc] close:handler];
}
@end
