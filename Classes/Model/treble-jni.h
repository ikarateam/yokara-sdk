//
//  treble-jni.h
//  AudioTapProcessor
//
//  Created by Rain Nguyen on 9/14/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

#ifndef treble_jni_h
#define treble_jni_h

long  Java_co_ikara_codec_Treble_nativeStart(  const char *nativeTreble);

void Java_co_ikara_codec_Treble_nativeUpdateEffect(long handler, const char * nativeTreble);

void Java_co_ikara_codec_Treble_nativeInit();

void Java_co_ikara_codec_Treble_nativeProcess
(long handler, int pcmData[], int processedData[],long length) ;

void Java_co_ikara_codec_Treble_nativeStop(  long handler) ;

#endif /* treble_jni_h */
