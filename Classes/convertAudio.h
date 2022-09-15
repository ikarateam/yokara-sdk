//
//  convertAudio.h
//  Yokara
//
//  Created by Rain Nguyen on 2/6/19.
//  Copyright (c) 2019  SmartApp All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AudioFileConvertOperation.h"
@class Recording;
@interface convertAudio : NSObject<AudioFileConvertOperationDelegate>{
    
}
- (void)convertAudio: (Recording*)record;
@property (nonatomic, strong) NSString *sourceFilePath;
@property (nonatomic, strong) NSString *destinationFilePath;
@property (nonatomic, assign) BOOL doneConvert;
@property (nonatomic, strong) Recording* record;
@property (nonatomic, strong) AudioFileConvertOperation *operation;

@end
