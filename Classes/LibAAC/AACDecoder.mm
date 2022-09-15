//
//  AACDecoder.m
//  Example
//
//  Created by Rain Nguyen on 6/11/20.
//  Copyright © 2020 hajime-nakamura. All rights reserved.
//

#import "AACDecoder.h"
#include <string.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include "aacenc_lib.h"
@interface AACDecoder ()

@end
@implementation AACDecoder



- (void)setUp{
	 self.dec_handle = aacDecoder_Open(TT_MP4_ADTS, 1);
	 // ASC data for decoder
		 UINT asc_buf_size = 2;
		 UCHAR asc_buf[2] = {18, 16};
		 UCHAR* asc_buf_pt = asc_buf;
		 //env->GetByteArrayRegion(codec_config, 0 , asc_buf_size, (jbyte*) asc_buf);
		 AAC_DECODER_ERROR dec_err;
	 dec_err = aacDecoder_ConfigRaw(self.dec_handle, &asc_buf_pt, &asc_buf_size);
		 if(dec_err != AAC_DEC_OK) {
			// NSLog(@"error writing ASC. AAC_DECODER_ERROR %d", dec_err);
			return;
		 }
	// NSLog(@"decoder sampleRate: %d", aacDecoder_GetStreamInfo(self.dec_handle)->aacSampleRate);
	// NSLog(@"decoder extSamplingRate: %d", aacDecoder_GetStreamInfo(self.dec_handle)->extSamplingRate);
		// NSLog(@"decoder samples per frame: %d", aacDecoder_GetStreamInfo(self.dec_handle)->aacSamplesPerFrame);
	//	 NSLog(@"decoder framesize: %d", aacDecoder_GetStreamInfo(self.dec_handle)->frameSize);
		// NSLog(@"decoder aot: %d", aacDecoder_GetStreamInfo(self.dec_handle)->aot);
	//	NSLog(@"decoder extAot: %d", aacDecoder_GetStreamInfo(self.dec_handle)->extAot);
	//	NSLog(@"decoder channelConfig: %d", aacDecoder_GetStreamInfo(self.dec_handle)->channelConfig);
	//	NSLog(@"decoder numchannels: %d", aacDecoder_GetStreamInfo(self.dec_handle)->numChannels);

		 if (aacDecoder_SetParam(self.dec_handle, AAC_PCM_MAX_OUTPUT_CHANNELS, 2) != AAC_DEC_OK) {
			 //NSLog(@"unable to set number of pcm output channels");
			 return ;
		 }

		 if (aacDecoder_SetParam(self.dec_handle, AAC_PCM_OUTPUT_INTERLEAVED, 1) != AAC_DEC_OK) {
			// NSLog(@"unable to set number of interleaving to 1");
			 return ;
		 }
}
- (int ) nativeDecode:(short [])outData Lenght:(long) size{
	 int out_samples = 0;

	 if(self.dec_handle != NULL) {

			 // decode frame
			 INT_PCM dec_out_buf[sizeof(INT_PCM)*2048];
				 AAC_DECODER_ERROR dec_err;
			 if((dec_err = aacDecoder_DecodeFrame(self.dec_handle, dec_out_buf, 2048, 0)) != AAC_DEC_OK) {
				//  NSLog(@"error decoding frame. AAC_DECODER_ERROR %u", dec_err);
			 } else {
				 // write PCM
				 out_samples = aacDecoder_GetStreamInfo(self.dec_handle)->frameSize * 2;
				// memcpy(outData, dec_out_buf, sizeof(dec_out_buf));

				  for (int i = 0; i < out_samples; i++){
					  outData[i] = dec_out_buf[i];

				  }
			 }
		  
	 }

		 return out_samples;
}
- (void)nativeFill :(unsigned char *)inAudio size:(long) size{
	 if(self.dec_handle != NULL) {
	 UINT in_packet_size =(UINT) size;
			UINT valid =(UINT) size;
		 // UCHAR dec_in_buf[in_packet_size];
		//  UCHAR * dec_in_buf_pt;// = malloc(in_packet_size * sizeof(unsigned char));
		//  memcpy(dec_in_buf_pt, inAudio, sizeof(inAudio));
	 AAC_DECODER_ERROR dec_err = aacDecoder_Fill(self.dec_handle, &inAudio, &in_packet_size, &valid);
		  if (dec_err!= AAC_DEC_OK) {
			   //NSLog(@"error filling decoder buffer. AAC_DECODER_ERROR %u", dec_err);
		  }
	  }
}
- (int ) decode:(unsigned char *)inAudio outData:(short [])lin Lenght:(long) size{
	 [self nativeFill:inAudio size:size];
			 short tempOutput[2048];
			 int decodeSize = 2048;
			 int total = 0;
			 int index = 0;
			 while (decodeSize > 0){
				  decodeSize = [self nativeDecode:tempOutput Lenght:size];
				 // index = 0;
				 for (int i = 0; i < decodeSize; i++){
					 lin[index] = tempOutput[i];
					 index++;
				 }
				 total += decodeSize;
			 }
	// free(tempOutput);
			 return total;
}
- (int) decodeFrame:(unsigned char *)encoded outData:(float [])outData Lenght:(long)size{
	 short tempOutput [2048];
	 int returnSize = [self decode:encoded outData:tempOutput Lenght:size];
			if (returnSize == 2048){

					for (int i = 0; i < returnSize; i++) {
						 outData[ i] = (float)tempOutput[i]/32768.0f;// (((float) tempOutput[i]/32768.0f)>1.0f)?1.0f:((float) tempOutput[i]/32768.0f);// 32768.0f;

						// outData[2 * i + 1] =(((float) (tempOutput[i] >>8)/255.0f)>1)?1.0f:((float) (tempOutput[i] >>8)/255.0f);// 32768.0f;
					}
				// free(tempOutput);
					return returnSize;

			} else {
				//NSLog(@"Something wrong here");
				 // free(tempOutput);
				return 0;
			}
}
- (int) decodeFrameChar:(unsigned char *)encoded outData:(unsigned char [])outData Lenght:(long)size{
    try {
	 short tempOutput [2048];
	 int returnSize = [self decode:encoded outData:tempOutput Lenght:size];
			if (returnSize == 2048){

					for (int i = 0; i < returnSize; i++) {
						 outData[2 * i] = (unsigned char ) tempOutput[i];
						 outData[2 * i + 1] = (unsigned char ) (tempOutput[i] >> 8);
					}
				// free(tempOutput);
					return returnSize*2;

			} else {
				//NSLog(@"Something wrong here");
				 // free(tempOutput);
				return 0;
			}
    }catch (NSException *except) {
        NSLog(@"decodeFrameChar %@", except);
    }
    return  0;
}
- (void) Close {

	 if(self.dec_handle) {

	 aacDecoder_Close(self.dec_handle);
		 self.dec_handle = NULL;
	 }
}
@end
