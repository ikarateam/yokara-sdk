//
//  noiseprof-jni.h
//  AudioTapProcessor
//
//  Created by Rain Nguyen on 9/14/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

#ifndef noiseprof_jni_h
#define noiseprof_jni_h
long  Java_co_ikara_codec_NoiseProf_nativeStart(  const char *nativeNoiseProf);

void Java_co_ikara_codec_NoiseProf_nativeUpdateEffect(long handler, const char * nativeNoiseProf);

void Java_co_ikara_codec_NoiseProf_nativeInit();

void Java_co_ikara_codec_NoiseProf_nativeProcess(long handler, int* pcmData, int* processedData ,long length);

void Java_co_ikara_codec_NoiseProf_nativeStop(  long handler) ;

#endif /* noiseprof_jni_h */
