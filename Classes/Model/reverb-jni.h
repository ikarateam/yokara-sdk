//
//  reverb-jni.h
//  AudioTapProcessor
//
//  Created by Rain Nguyen on 9/14/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

#ifndef reverb_jni_h
#define reverb_jni_h

long  Java_co_ikara_codec_Freeverb_nativeStart(  const char *nativeFreeverb);

void Java_co_ikara_codec_Freeverb_nativeUpdateEffect(long handler, const char * nativeFreeverb);

void Java_co_ikara_codec_Freeverb_nativeInit();

void Java_co_ikara_codec_Freeverb_nativeProcess(long handler, int pcmData[], int processedData[] ,long length);

void Java_co_ikara_codec_Freeverb_nativeStop(  long handler) ;
#endif /* reverb_jni_h */
