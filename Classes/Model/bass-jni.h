//
//  bass-jni.h
//  AudioTapProcessor
//
//  Created by Rain Nguyen on 9/14/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

#ifndef bass_jni_h
#define bass_jni_h

long  Java_co_ikara_codec_Bass_nativeStart(  const char *nativeBass);

void Java_co_ikara_codec_Bass_nativeUpdateEffect(long handler, const char * nativeBass);

void Java_co_ikara_codec_Bass_nativeInit();

void Java_co_ikara_codec_Bass_nativeProcess(long handler, int pcmData[], int processedData[] ,long length);

void Java_co_ikara_codec_Bass_nativeStop(  long handler) ;
#endif /* bass_jni_h */
