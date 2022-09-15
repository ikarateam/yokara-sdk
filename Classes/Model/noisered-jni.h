//
//  noisered-jni.h
//  AudioTapProcessor
//
//  Created by Rain Nguyen on 9/14/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

#ifndef noisered_jni_h
#define noisered_jni_h
long  Java_co_ikara_codec_Noisered_nativeStart(  const char *nativeNoisered);

void Java_co_ikara_codec_Noisered_nativeUpdateEffect(long handler, const char * nativeNoisered);

void Java_co_ikara_codec_Noisered_nativeInit();

void Java_co_ikara_codec_Noisered_nativeProcess(long handler, int* pcmData, int* processedData ,long length);

void Java_co_ikara_codec_Noisered_nativeStop(  long handler) ;

#endif /* noisered_jni_h */
