//
//  Freeverb.h
//  AudioTapProcessor
//
//  Created by Rain Nguyen on 9/14/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Freeverb : NSObject{
    long handler;
}
- (void) start: (int) bass;
- (void) stop;
- (void) updateEffect:(int) bass;
- (void) process:(int[]) input withLength:(long)inputLength andOut: (int[]) output withLength:(long)outLength;
- (int) process:(float[]) left right:( float []) right leftOut:( float []) leftOut rightOut:( float[]) rightOut andLength:(long) length;

@end
