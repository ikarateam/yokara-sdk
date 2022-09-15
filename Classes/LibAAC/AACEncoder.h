//
//  AACEncoder.h
//  Likara
//
//  Created by Rain Nguyen on 6/14/20.
//  Copyright © 2020 Likara. All rights reserved.
//



#import <Foundation/Foundation.h>


@interface AACEncoder : NSObject

- (int) close ;
- (BOOL) initAAC:(int) bitrate sampleRate:(int )sample_rate channels:(int)channels;
- (int) encodeFrame:(unsigned char [])inData outData:(unsigned char  [])outData Lenght:(long)size;
@end

