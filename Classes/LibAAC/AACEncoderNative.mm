//
//  AACEncoderNative.m
//  Likara
//
//  Created by Rain Nguyen on 6/16/20.
//  Copyright © 2020 Likara. All rights reserved.
//

#import "AACEncoderNative.h"
#include "aacenc_lib.h"
#import "AACEncoder.h"
@implementation AACEncoderNative
- (long) initAAC:(int) bitrate sampleRate:(int )sample_rate channels:(int)channels{
	 AACOutput* fdkencode;
	 fdkencode=(AACOutput *) malloc(sizeof(AACOutput));
	 fdkencode->channels=channels;
	 fdkencode->samplerate=sample_rate;
	 fdkencode->bitrate=bitrate;

	 fdkencode->transMux = TT_MP4_ADTS; //TODO ??
	 fdkencode->afterburner = 1; //TODO ??
	 fdkencode->channelLoader = 1; //TODO ？？
	 fdkencode->aot = AOT_AAC_LC; //aot类型。

	 //先打开编码器，给handle 赋值。
	 if (aacEncOpen(&fdkencode->handle, 0, channels) != AACENC_OK) {
		 fprintf(stderr, "无法打开编码器\n");
		 return 0;
	 }
	 //设置AOT值
	 if (aacEncoder_SetParam(fdkencode->handle, AACENC_AOT, fdkencode->aot)
			 != AACENC_OK) {
		 fprintf(stderr, "无法设置AOT值：%d\n", fdkencode->aot);
		 return 0;
	 }

	 //设置采样频率
	 if (aacEncoder_SetParam(fdkencode->handle, AACENC_SAMPLERATE, sample_rate)
			 != AACENC_OK) {
		 fprintf(stderr, "无法设置采样频率\n");
		 return 0;
	 }

	 //根据声道数设置声道模式。
	 switch (channels) {
	 case 1:
		 fdkencode->mode = MODE_1;
		 break;
	 case 2:
		 fdkencode->mode = MODE_2;
		 break;
	 default:
		 fprintf(stderr, "不支持的声道数 %d\n", channels);
		 return 0;
	 }

	 if (aacEncoder_SetParam(fdkencode->handle, AACENC_CHANNELMODE,
			 fdkencode->mode) != AACENC_OK) {
		 fprintf(stderr, "无法设置声道模式\n");
		 return 0;
	 }

	 //设置比特率
	 if (aacEncoder_SetParam(fdkencode->handle, AACENC_BITRATE, bitrate)
			 != AACENC_OK) {
		 fprintf(stderr, "无法设置比特率\n");
		 return 0;
	 }
	  //thêm cho livestream để cho ra số byte đồng đều
	 if (aacEncoder_SetParam(fdkencode->handle, AACENC_PEAK_BITRATE, fdkencode->bitrate)
				!= AACENC_OK) {
		 		fprintf(stderr, "无法设置比特率\n");
		 		return 0;
			}
	 if (aacEncoder_SetParam(fdkencode->handle, AACENC_TRANSMUX, fdkencode->transMux)
			 != AACENC_OK) {
		 fprintf(stderr, "无法设置 ADTS transmux\n");
		 return 0;
	 }
	 if (aacEncoder_SetParam(fdkencode->handle, AACENC_AFTERBURNER,
			 fdkencode->afterburner) != AACENC_OK) {
		 fprintf(stderr, "无法设置 afterburner 模式\n");
		 return 0;
	 }
	 if (aacEncEncode(fdkencode->handle, NULL, NULL, NULL, NULL) != AACENC_OK) {
		 fprintf(stderr, "无法初始化aac编码器\n");
		 return 0;
	 }
	 if (aacEncInfo(fdkencode->handle, &fdkencode->info) != AACENC_OK) {
		 fprintf(stderr, "无法获取到编码器信息\n");
		 return 0;
	 }

	 return (long) fdkencode;
}
- (int) getBufferSize:(long) handle{
	 AACOutput* fdkencode = (AACOutput*)handle;
	 int frameLength =fdkencode->info.frameLength; //每帧的长度
	 int channels = fdkencode->channels; //获取声道数。
	 int input_size = channels * 2 * frameLength; //计算每帧的大小
	 fdkencode->input_size=input_size;
	 return input_size;
}

- (int) encodeFrame:(long)handle inData:(unsigned char [])pcmData LenghtIn:(int) lenghtIn encodedData:(unsigned char []) encodedData {

	 AACOutput* fdkencode = (AACOutput*)handle;

		 uint8_t* input_buf = (uint8_t*) pcmData;
		 int16_t* convert_buf = (int16_t*) malloc(fdkencode->input_size); //分配转换空间

		 int read = fdkencode->input_size;
		 int i;
		 //将8位的值转为16位。
		 for ( i = 0; i < read / 2; i++) {
			 const uint8_t* inp = &input_buf[2 * i];
			 convert_buf[i] = inp[0] | (inp[1] << 8);
		 }

		 AACENC_BufDesc in_buf = { 0 }, out_buf = { 0 };
		 AACENC_InArgs in_args = { 0 };
		 AACENC_OutArgs out_args = { 0 };
		 int in_identifier = IN_AUDIO_DATA;
		 int in_size, in_elem_size;
		 int out_identifier = OUT_BITSTREAM_DATA;
		 int out_size, out_elem_size;
		 void *in_ptr, *out_ptr;
		 uint8_t outbuf[20480];

		 if (read <= 0) {
			 in_args.numInSamples = -1;
		 } else {
			 in_ptr = convert_buf;
			 in_size = read;
			 in_elem_size = 2;

			 in_args.numInSamples = read / 2;
			 in_buf.numBufs = 1;
			 in_buf.bufs = &in_ptr;
			 in_buf.bufferIdentifiers = &in_identifier;
			 in_buf.bufSizes = &in_size;
			 in_buf.bufElSizes = &in_elem_size;
		 }
		 out_ptr = outbuf;
		 out_size = sizeof(outbuf);
		 out_elem_size = 1;

		 out_buf.numBufs = 1;
		 out_buf.bufs = &out_ptr;
		 out_buf.bufferIdentifiers = &out_identifier;
		 out_buf.bufSizes = &out_size;
		 out_buf.bufElSizes = &out_elem_size;

	 bool success =  [self aacEncoderProcess:handle inBuffer:&in_buf outBuf:&out_buf inArg:&in_args outArg:&out_args];

		 if (success) {
			 if (out_args.numOutBytes != 0) {

				 if(fdkencode->first==0){
					 //char  asc[2];
					 //asc[0] = 0x10 | ((4 >> 1) & 0x3);
					 //asc[1] = ((4 & 0x1) << 7) | ((2 & 0xF) << 3);
					 //send_rtmp_audio_spec((unsigned char*)asc, 2);
					 //send_rtmp_audio_spec(fdkencode->info.confBuf,fdkencode->info.confSize);
					 fdkencode->first = 1;
				 }
				 //send_rtmp_audio(outbuf,out_args.numOutBytes,getSystemTime());

			 }
			 for (int i = 0; i < out_args.numOutBytes; i++) {
				 encodedData[i] = outbuf[i];
			 }
		 }
		 free(convert_buf);

		 return out_args.numOutBytes;
}
- (BOOL) aacEncoderProcess:(long) handle inBuffer:(AACENC_BufDesc*) in_buf outBuf:(
																				   AACENC_BufDesc*) out_buf inArg:(
																												   AACENC_InArgs*) in_args outArg:(
		AACENC_OutArgs*) out_args {

	AACENC_ERROR err;
	AACOutput* fdkencode = (AACOutput*)handle;
	if ((err = aacEncEncode(fdkencode->handle, in_buf, out_buf, in_args, out_args))
			!= AACENC_OK) {
		if (err == AACENC_ENCODE_EOF) {
			//结尾，正常结束
			return true;
		}
		fprintf(stderr, "编码失败！！err = %d \n", err);
		return false;
	}
	return true;
}
- (int) close:(long) handle {

	 AACOutput* fdkencode = (AACOutput*)handle;
	 aacEncClose(&fdkencode->handle);
	 free(fdkencode);
	 return 1;
}
@end
