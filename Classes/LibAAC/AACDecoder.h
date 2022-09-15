//
//  AACDecoder.h
//  Example
//
//  Created by Rain Nguyen on 6/11/20.
//  Copyright © 2020 hajime-nakamura. All rights reserved.
//


#import <Foundation/Foundation.h>
#include "aacdecoder_lib.h"

@interface AACDecoder : NSObject
@property (nonatomic, assign) HANDLE_AACDECODER dec_handle;
- (void) Close ;
- (void)setUp;
- (int) decodeFrame:(unsigned char *)encoded outData:(float [])outData Lenght:(long)size;
- (int) decodeFrameChar:(unsigned char *)encoded outData:(unsigned char [])outData Lenght:(long)size;
@end



